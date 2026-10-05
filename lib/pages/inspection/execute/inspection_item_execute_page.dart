import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:flant/components/image_preview.dart';
import 'package:cloud/pages/inspection/execute/widgets/dynamic_inspection.dart';
import 'package:cloud/pages/inspection/execute/widgets/dynamic_template_schema.dart';
import 'package:cloud/pages/inspection/detail/widgets/inspection_history_panel.dart';
import 'package:cloud/pages/inspection/execute/widgets/inspection_batch_history.dart';
import 'package:cloud/pages/inspection/execute/widgets/inspection_bottom_buttons.dart';
import 'package:cloud/pages/inspection/execute/widgets/inspection_remark.dart';
import 'package:cloud/pages/inspection/execute/widgets/normal_inspection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/models/inspection/inspection_round_snapshot.dart';
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:cloud/pages/login/widgets/scan.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/inspection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud/pages/inspection/const.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// 执行验货页面，根据模板类型，显示不同的验货页面 id:某一项验货任务的id
@RoutePage()
class InspectionItemExecutePage extends HookConsumerWidget {
  final int id;
  const InspectionItemExecutePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final inspectionItem = useState<InspectionItem?>(null);
    final isLoading = useState(false);
    final detailState = ref.watch(inspectionDetailProvider);
    final detailNotifier = ref.read(inspectionDetailProvider.notifier);
    final isSubmitting = useState(false);
    final submittingStatus = useState<int>(0);
    final mediaMap = useState<Map<String, List<TemporaryMedia>>>({});

    final remarkController = useTextEditingController();
    final scrollController = useScrollController();
    final remarkHasError = useState(false);
    final isHistoryExpanded = useState(false);
    final isBatchHistoryExpanded = useState(false);
    final batchNoController = useTextEditingController();
    final batchNo = useState('');
    final recognizedBatchNo1 = useState<String?>(null);
    final recognizedBatchNo2 = useState<String?>(null);

    bool isBatchPhotoKey(String key) {
      final fields = inspectionItem.value?.photoCheckFields;
      if (fields == null) return false;
      for (final field in fields) {
        if (field.name.toLowerCase().contains('batch') && field.name == key) {
          return true;
        }
      }
      return false;
    }

    List<TemporaryMedia> getAllBatchPhotos() {
      final fields = inspectionItem.value?.photoCheckFields;
      if (fields == null) return const [];
      final photos = <TemporaryMedia>[];
      for (final field in fields) {
        if (field.name.toLowerCase().contains('batch')) {
          photos.addAll(mediaMap.value[field.name] ?? []);
        }
      }
      return photos;
    }

    final isYunDianInspection = detailState.inspection?.departmentId == 275 ||
        detailState.inspection?.taskType == 3;

    void syncBatchNoFromRecognition() {
      final v1 = recognizedBatchNo1.value;
      final v2 = recognizedBatchNo2.value;

      if (v1 != null && v2 != null) {
        if (v1 == v2) {
          batchNo.value = v1;
          batchNoController.text = v1;
          EasyLoading.showSuccess('批次号1和批次号2识别一致：$v1');
        } else {
          EasyLoading.showInfo('批次号识别不一致，请手动选择');
        }
      } else if (v1 != null && batchNo.value.trim().isEmpty) {
        batchNo.value = v1;
        batchNoController.text = v1;
        EasyLoading.showSuccess('已自动识别批次号1：$v1');
      } else if (v2 != null && batchNo.value.trim().isEmpty) {
        batchNo.value = v2;
        batchNoController.text = v2;
        EasyLoading.showSuccess('已自动识别批次号2：$v2');
      }
    }

    void updateMedia(String key, List<TemporaryMedia> medias) {
      FocusManager.instance.primaryFocus?.unfocus();
      final newMap = Map<String, List<TemporaryMedia>>.from(mediaMap.value);
      newMap[key] = medias;
      mediaMap.value = newMap;

      if (isYunDianInspection && medias.isNotEmpty && isBatchPhotoKey(key)) {
        final thumbUrl = medias.first.thumbUrl;
        if (thumbUrl != null && thumbUrl.isNotEmpty) {
          identifyBatchNo(thumbUrl).then((result) {
            if (result != null && result.trim().isNotEmpty) {
              final value = result.trim();
              if (key == 'batch_number') {
                recognizedBatchNo1.value = value;
              } else if (key == 'batch_number_2') {
                recognizedBatchNo2.value = value;
              }
              syncBatchNoFromRecognition();
            }
          }).catchError((_) => null);
        }
      }
    }

    final useNormalTemplate =
        detailState.inspection?.inspectionDynamicTemplate?.id == null ||
            detailState.inspection?.inspectionDynamicTemplate?.id.toString() ==
                '0';

    useEffect(() {
      void clearRemarkError() {
        if (remarkHasError.value) {
          remarkHasError.value = false;
        }
      }

      remarkController.addListener(clearRemarkError);
      return () {
        remarkController.removeListener(clearRemarkError);
        remarkController.clear();
      };
    }, [remarkController]);

    Future loadInspection() async {
      try {
        isLoading.value = true;
        final data = await showInspectionItem(id);
        inspectionItem.value = data;
        if (data?.remark != null && data!.status != 4) {
          remarkController.text = data!.remark!;
        }
        if (!useNormalTemplate) {
          final schema = DynamicTemplateSchema.extract(
            data?.inspectionDynamicTemplateJson,
          );

          detailNotifier.setDynamicZonesNode(
            schema == null ? const {} : DynamicTemplateSchema.zoneNodes(schema),
          );
        } else {
          if (data?.media != null &&
              data!.media!.isNotEmpty &&
              data.status != 4) {
            final Map<String, List<TemporaryMedia>> initMap = {};
            for (var item in data.media!) {
              if (item.id == null || item.url == null) continue;
              final String key = item.collectionName ?? 'details';
              final tempMedia = TemporaryMedia(
                id: item.id!,
                url: item.url!,
                thumbUrl: item.thumbUrl ?? item.url,
                uuid: null,
              );
              if (!initMap.containsKey(key)) initMap[key] = [];
              initMap[key]!.add(tempMedia);
            }
            mediaMap.value = initMap;
          }
        }
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadInspection();
      return null;
    }, []);

    // 提交验货
    Future<void> handleSubmitNormal(int targetStatus) async {
      if (isSubmitting.value) return;

      if (targetStatus == 3 && remarkController.text.trim().isEmpty) {
        EasyLoading.showInfo('不合格必须填写验货备注');
        remarkHasError.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!scrollController.hasClients) return;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
        return;
      }

      final bool hasImages =
          mediaMap.value.values.any((medias) => medias.isNotEmpty);

      if (!hasImages) {
        EasyLoading.showInfo('请至少上传一张验货图片');
        return;
      }

      submittingStatus.value = targetStatus;
      isSubmitting.value = true;

      final int? originalStatus = inspectionItem.value?.status;

      try {
        final Map<String, dynamic> submitData = {};

        mediaMap.value.forEach((key, medias) {
          if (medias.isNotEmpty) {
            submitData[key] = medias
                .map((e) => {
                      'id': e.id,
                      if (e.uuid != null) 'uuid': e.uuid,
                    })
                .toList();
          }
        });

        submitData['remark'] = remarkController.text;
        submitData['status'] = targetStatus;

        if (inspectionItem.value?.barcode != null) {
          submitData['barcode'] = inspectionItem.value!.barcode;
        }

        await updateInspectionItem(id, submitData);

        if (isYunDianInspection) {
          try {
            final Map<String, dynamic> batchData = {
              'task_id': inspectionItem.value?.taskId,
              'batch_no': batchNoController.text.trim(),
              'status': targetStatus,
              'ctns': inspectionItem.value?.ctns ?? 0,
              'unit_per_ctn': inspectionItem.value?.unitPerCtn ?? 0,
              'qty': inspectionItem.value?.qty ?? 0,
              'remark': remarkController.text,
              'std_barcode': inspectionItem.value?.stdBarcode,
              'scan_barcode': inspectionItem.value?.scanBarcode,
              'user_id': inspectionItem.value?.userId,
            };

            mediaMap.value.forEach((key, medias) {
              if (medias.isNotEmpty) {
                batchData[key] = medias
                    .map((e) => {
                          'id': e.id,
                          if (e.uuid != null) 'uuid': e.uuid,
                        })
                    .toList();
              }
            });

            final savedBatch = await saveInspectionItemBatch(id, batchData);
            if (targetStatus == 3 && savedBatch?.id != null) {
              notifyInspectionItemBatchRejected(id, savedBatch!.id!)
                  .catchError((_) {});
            }
          } catch (_) {
            if (originalStatus != null) {
              await updateInspectionItem(id, {
                'status': originalStatus,
                'remark': inspectionItem.value?.remark ?? '',
              }).catchError((_) => null);
            }
            rethrow;
          }
        } else {
          if (targetStatus == 3) {
            notifyInspectionItemRejected(id).catchError((_) {});
          }
        }

        EasyLoading.showSuccess('验货完成');
        if (context.mounted) Navigator.pop(context);
      } on DioException catch (e) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['message']?.toString() ?? '提交失败，请重试')
            : (e.message ?? '提交失败，请重试');
        EasyLoading.showError(msg);
      } catch (_) {
        EasyLoading.showError('提交失败，请重试');
      } finally {
        isSubmitting.value = false;
      }
    }

    Future<void> handleSubmitDynamic(int targetStatus) async {
      if (isSubmitting.value) return;

      if (targetStatus == 3 && remarkController.text.trim().isEmpty) {
        EasyLoading.showInfo('不合格必须填写验货备注');
        remarkHasError.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!scrollController.hasClients) return;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
        return;
      }

      submittingStatus.value = targetStatus;
      isSubmitting.value = true;

      final int? originalStatus = inspectionItem.value?.status;

      try {
        final Map<String, dynamic> submitData = {};
        submitData['remark'] = remarkController.text;
        submitData['status'] = targetStatus;

        if (inspectionItem.value?.barcode != null) {
          submitData['barcode'] = inspectionItem.value!.barcode;
        }
        final currentTemplateJson = Map<String, dynamic>.from(
          inspectionItem.value?.inspectionDynamicTemplateJson ?? const {},
        );
        final dynamicZonesNodes = detailState.dynamicZonesNodes ?? const {};
        currentTemplateJson['zones'] = dynamicZonesNodes;
        submitData['inspection_dynamic_template_json'] = currentTemplateJson;

        await updateInspectionItem(id, submitData);

        if (isYunDianInspection) {
          try {
            final Map<String, dynamic> batchData = {
              'task_id': inspectionItem.value?.taskId,
              'batch_no': batchNoController.text.trim(),
              'status': targetStatus,
              'ctns': inspectionItem.value?.ctns ?? 0,
              'unit_per_ctn': inspectionItem.value?.unitPerCtn ?? 0,
              'qty': inspectionItem.value?.qty ?? 0,
              'remark': remarkController.text,
              'std_barcode': inspectionItem.value?.stdBarcode,
              'scan_barcode': inspectionItem.value?.scanBarcode,
              'user_id': inspectionItem.value?.userId,
            };

            final savedBatch = await saveInspectionItemBatch(id, batchData);
            if (targetStatus == 3 && savedBatch?.id != null) {
              notifyInspectionItemBatchRejected(id, savedBatch!.id!)
                  .catchError((_) {});
            }
          } catch (_) {
            if (originalStatus != null) {
              await updateInspectionItem(id, {
                'status': originalStatus,
                'remark': inspectionItem.value?.remark ?? '',
              }).catchError((_) => null);
            }
            rethrow;
          }
        } else {
          if (targetStatus == 3) {
            notifyInspectionItemRejected(id).catchError((_) {});
          }
        }

        EasyLoading.showSuccess('验货完成');
        if (context.mounted) Navigator.pop(context);
      } on DioException catch (e) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['message']?.toString() ?? '提交失败，请重试')
            : (e.message ?? '提交失败，请重试');
        EasyLoading.showError(msg);
      } catch (_) {
        EasyLoading.showError('提交失败，请重试');
      } finally {
        isSubmitting.value = false;
      }
    }

    void showImagePreview(String imageUrl) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                _PreviewImagePage(
                  imageProvider: CachedNetworkImageProvider(imageUrl),
                ),
                Positioned(
                  top: 0,
                  right: 8,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('产品验货',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: const BackButton(color: Colors.black),
        ),
        body: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(12),
                  children: [
                    if (isLoading.value == true) ...[
                      SizedBox(
                        height: 158,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: MuProgressIndicator(
                                showText: true, text: '加载中...'),
                          ),
                        ),
                      ),
                    ] else ...[
                      _InfoCard(
                        colorScheme: colorScheme,
                        text: const Color(0xFF333333),
                        inspectionItem: inspectionItem.value,
                        isYunDianInspection: isYunDianInspection,
                        onBarcodeScanned: (code) {
                          HapticFeedback.mediumImpact();
                          if (inspectionItem.value != null) {
                            inspectionItem.value =
                                inspectionItem.value!.copyWith(
                              barcode: code,
                            );
                          }
                        },
                      ),
                    ],
                    if (inspectionItem.value != null &&
                        inspectionItem.value!.rounds != null &&
                        inspectionItem.value!.rounds!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _InspectionHistoryInline(
                        rounds: inspectionItem.value!.rounds!,
                        isExpanded: isHistoryExpanded.value,
                        onToggle: () =>
                            isHistoryExpanded.value = !isHistoryExpanded.value,
                        colorScheme: colorScheme,
                      ),
                    ],
                    if (isYunDianInspection) ...[
                      const SizedBox(height: 12),
                      InspectionBatchHistory(
                        itemId: id,
                        isExpanded: isBatchHistoryExpanded.value,
                        onToggle: () => isBatchHistoryExpanded.value =
                            !isBatchHistoryExpanded.value,
                        colorScheme: colorScheme,
                        photoCheckFields:
                            inspectionItem.value?.photoCheckFields,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (useNormalTemplate)
                      InspectionItemNormalPage(
                        id: id,
                        inspectionItem: inspectionItem.value,
                        mediaMap: mediaMap.value,
                        onMediaChanged: updateMedia,
                        photoCheckFields:
                            inspectionItem.value?.photoCheckFields,
                        departmentName:
                            detailState.inspection?.user?.department?.name,
                      )
                    else
                      InspectionItemDynamicPage(
                        isLoading: isLoading.value,
                        schema: DynamicTemplateSchema.extract(inspectionItem
                            .value?.inspectionDynamicTemplateJson),
                      ),
                    if (isYunDianInspection) ...[
                      const SizedBox(height: 12),
                      _BatchNoCard(
                        batchNo: batchNo.value,
                        controller: batchNoController,
                        colorScheme: colorScheme,
                        batchPhotos: getAllBatchPhotos(),
                        recognizedBatchNo1: recognizedBatchNo1.value,
                        recognizedBatchNo2: recognizedBatchNo2.value,
                        onSelectRecognized: (value) {
                          batchNo.value = value;
                          batchNoController.text = value;
                        },
                        onPreviewImage: showImagePreview,
                        onChanged: (value) {
                          batchNo.value = value;
                          batchNoController.text = value;
                        },
                        onScanned: (code) {
                          HapticFeedback.mediumImpact();
                          batchNo.value = code;
                          batchNoController.text = code;
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    InspectionRemark(
                      blue: colorScheme.primary,
                      text: colorScheme.onSurface,
                      controller: remarkController,
                      hasError: remarkHasError.value,
                    ),
                    const SizedBox(height: 12),
                    InspectionBottomButtons(
                      onPressed: useNormalTemplate
                          ? handleSubmitNormal
                          : handleSubmitDynamic,
                      isSubmitting: isSubmitting.value,
                      submittingStatus: submittingStatus.value,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class _InfoCard extends StatelessWidget {
  final InspectionItem? inspectionItem;
  final ColorScheme colorScheme;
  final Color text;
  final Function(String) onBarcodeScanned;
  final bool isYunDianInspection;
  static final Map<String, ImageProvider> _originalImageProviders =
      <String, ImageProvider>{};
  static final Set<String> _precachedImageUrls = <String>{};
  static final Set<String> _precachingImageUrls = <String>{};
  static const Color labelTextColor = Color.fromARGB(255, 34, 37, 43);

  const _InfoCard({
    required this.colorScheme,
    required this.text,
    this.inspectionItem,
    required this.onBarcodeScanned,
    this.isYunDianInspection = false,
  });

  static String _rawString(Map<String, dynamic>? raw, String key) {
    final value = raw?[key];
    if (value == null) return '';
    return value.toString().trim();
  }

  // 内部扫描逻辑
  void _openScanner(BuildContext context) async {
    final String? result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) => const _BarcodeScannerBottomSheet(),
    );

    if (result != null) {
      onBarcodeScanned(result);
    }
  }

  Widget _buildStatusTag(int? status) {
    final label =
        inspectionStatusLabelMap[status] ?? inspectionStatusPendingLabel;
    final color = {1: Colors.green, 2: Colors.orange, 3: Colors.red}[status] ??
        Colors.grey;

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
    );
  }

// 获取这个sku的原图，原图来自模板上传
  List<String> _getOriginalImageUrls() {
    final medias = inspectionItem?.media;
    final urls = <String>[];
    if (medias != null && medias.isNotEmpty) {
      for (final media in medias) {
        final collectionName = media.collectionName?.trim();
        final url = media.url?.trim();
        if (collectionName == 'original' && url != null && url.isNotEmpty) {
          urls.add(url);
        }
      }
    }
    return urls;
  }

  void _openPreviewImages(BuildContext context, List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      EasyLoading.showInfo('暂无图片可查看');
      return;
    }
    _precacheOriginalImagesNow(context, imageUrls);

    final currentIndex = ValueNotifier<int>(0);
    final pageController = PageController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                allowImplicitScrolling: true,
                itemCount: imageUrls.length,
                onPageChanged: (index) => currentIndex.value = index,
                itemBuilder: (context, index) {
                  final imageUrl = imageUrls[index];
                  return _PreviewImagePage(
                    key: ValueKey(imageUrl),
                    imageProvider: _originalImageProvider(imageUrl),
                  );
                },
              ),
              Positioned(
                top: 0,
                right: 8,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              if (imageUrls.length > 1)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 12,
                  child: Center(
                    child: ValueListenableBuilder<int>(
                      valueListenable: currentIndex,
                      builder: (context, index, _) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${index + 1}/${imageUrls.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      pageController.dispose();
      currentIndex.dispose();
    });
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  void _precacheOriginalImages(BuildContext context, List<String> imageUrls) {
    if (imageUrls.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheOriginalImagesNow(context, imageUrls);
    });
  }

  void _precacheOriginalImagesNow(
      BuildContext context, List<String> imageUrls) {
    if (imageUrls.isEmpty || !context.mounted) return;

    for (final imageUrl in imageUrls.take(6)) {
      if (_precachedImageUrls.contains(imageUrl) ||
          !_precachingImageUrls.add(imageUrl)) {
        continue;
      }

      precacheImage(_originalImageProvider(imageUrl), context).then((_) {
        _precachedImageUrls.add(imageUrl);
      }).catchError((_) {
        _precachedImageUrls.remove(imageUrl);
      }).whenComplete(() {
        _precachingImageUrls.remove(imageUrl);
      });
    }
  }

  ImageProvider _originalImageProvider(String imageUrl) {
    return _originalImageProviders.putIfAbsent(
      imageUrl,
      () => CachedNetworkImageProvider(imageUrl),
    );
  }

  Widget _originalImageEntry(BuildContext context, List<String> imageUrls) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          _precacheOriginalImagesNow(context, imageUrls);
          _openPreviewImages(context, imageUrls);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '产品样图: ',
              style: TextStyle(
                color: labelTextColor,
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 239, 239, 239),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              child: Row(
                children: [
                  const Icon(Icons.image_outlined,
                      color: wineRedColor, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    imageUrls.length > 1
                        ? '点击查看大图，共${imageUrls.length}张    '
                        : '点击查看大图  ',
                    style: const TextStyle(
                      color: labelTextColor,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: labelTextColor, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeScannerAction(BuildContext context) {
    final String? scannedBarcode = inspectionItem?.barcode;
    final bool recognized = _hasText(scannedBarcode);

    return GestureDetector(
      onTap: () => _openScanner(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            CustomScanIcon(
              size: 22,
              color: recognized ? greenColor : wineRedColor,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      recognized ? scannedBarcode!.trim() : '点击识别产品条码',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: recognized ? greenColor : labelTextColor,
                        fontSize: 12,
                        fontWeight:
                            recognized ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (recognized) ...[
                    const SizedBox(width: 6),
                    const Text(
                      '已识别',
                      style: TextStyle(
                        color: greenColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barcodeInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: labelTextColor,
            fontSize: 12,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 2),
        if (value.isEmpty)
          Text(
            '暂无数据',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              height: 1.2,
            ),
          )
        else
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: wineRedColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
      ],
    );
  }

  Widget _descriptionInfo(String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '产品描述: ',
          style: TextStyle(
            color: labelTextColor,
            fontSize: 12,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 12 * 1.3 * 4),
            child: SingleChildScrollView(
              child: Text(
                value,
                style: TextStyle(
                  color: text,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeScannerRow(
    String label,
    String value,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: labelTextColor,
            fontSize: 12,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Row(
            children: [
              if (value.isEmpty)
                const Text(
                  '暂无数据',
                  style: TextStyle(
                    color: labelTextColor,
                    fontSize: 12,
                    height: 1.2,
                  ),
                )
              else
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: wineRedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(child: _buildBarcodeScannerAction(context)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final originalImageUrls = _getOriginalImageUrls();
    final description = inspectionItem?.description?.trim();

    final stdBarcode = inspectionItem?.stdBarcode; // 产品条码 通用模板中的值
    final scanBarcode = inspectionItem?.scanBarcode; // 外箱条码 通用模板中的值

    final raw = inspectionItem?.raw;
    final innerBoxBarcode = _rawString(raw, '内盒条码号'); // 定制模板的值
    final outerBoxBarcode = _rawString(raw, '外箱条码号'); // 定制模板的值
    final productBarcode = _rawString(raw, '产品条码号');
    final yunDianBarcode = _rawString(raw, 'Barcode');
    final productDescription = _rawString(raw, '描述'); // 定制模板的值

    _precacheOriginalImages(context, originalImageUrls);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TitleRow(
                icon: Icons.inventory,
                title: '产品信息',
                color: colorScheme.primary,
                textColor: text,
              ),
              Text(
                '    (SKU ${inspectionItem?.itemNo})',
                style: const TextStyle(
                  color: accentTealDeepColor,
                  fontSize: 13,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildStatusTag(inspectionItem?.status),
            ],
          ),
          const SizedBox(height: 16),
          if (!isYunDianInspection)
            _buildQuantitySummaryRow(
              ctns: inspectionItem?.ctns ?? 0,
              unitPerCtn: inspectionItem?.unitPerCtn ?? 0,
              qty: inspectionItem?.qty ?? 0,
            ),
          const SizedBox(height: 8),
          Divider(height: 1, color: wineRedColor.withOpacity(0.12)),

          // const SizedBox(height: 10),
          // _barcodeInfo('      SKU', inspectionItem?.itemNo ?? ''),
          if (_hasText(scanBarcode)) ...[
            const SizedBox(height: 12),
            _barcodeInfo('外箱条码', scanBarcode!),
          ] else if (_hasText(outerBoxBarcode)) ...[
            const SizedBox(height: 12),
            _barcodeInfo('外箱条码', outerBoxBarcode),
          ],

          if (_hasText(innerBoxBarcode)) ...[
            const SizedBox(height: 12),
            _barcodeInfo('内盒条码', innerBoxBarcode),
          ],
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: _buildBarcodeScannerRow(
                  '产品条码:',
                  _hasText(stdBarcode)
                      ? stdBarcode!.trim()
                      : (isYunDianInspection ? yunDianBarcode : productBarcode),
                  context,
                ),
              ),
            ],
          ),
          if (_hasText(_rawString(raw, 'pp'))) ...[
            const SizedBox(height: 12),
            _barcodeInfo('品牌', _rawString(raw, 'pp')),
          ],
          if (isYunDianInspection && _hasText(inspectionItem?.user?.name)) ...[
            const SizedBox(height: 12),
            _barcodeInfo('业务员', inspectionItem!.user!.name!),
          ],
          if (originalImageUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            _originalImageEntry(context, originalImageUrls),
          ],
          if (isYunDianInspection) ...[
            const SizedBox(height: 12),
            _buildYunDianPackagingRow(raw),
          ],
          if (_hasText(description)) ...[
            const SizedBox(height: 12),
            _descriptionInfo(description ?? productDescription),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildYunDianPackagingRow(Map<String, dynamic>? raw) {
    final outerCapacity = _rawString(raw, 'OuterCapacity');
    final outerLength = _rawString(raw, 'OuterLength');
    final outerWidth = _rawString(raw, 'OuterWidth');
    final outerHeight = _rawString(raw, 'OuterHeight');
    final outerVolume = _rawString(raw, 'OuterVolume');
    final outerGrossWeight = _rawString(raw, 'OuterGrossWeight');

    final outerSize = (outerLength.isNotEmpty ||
            outerWidth.isNotEmpty ||
            outerHeight.isNotEmpty)
        ? '$outerLength * $outerWidth * $outerHeight'
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPackagingInfoRow(
                '外箱尺寸: ',
                outerSize,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(child: _buildPackagingInfoRow('外箱体积: ', outerVolume)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildPackagingInfoRow('装箱量: ', outerCapacity)),
            const SizedBox(width: 24),
            Expanded(child: _buildPackagingInfoRow('毛重: ', outerGrossWeight)),
          ],
        ),
      ],
    );
  }

  Widget _buildPackagingInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: labelTextColor,
            fontSize: 12,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: text,
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySummaryRow({
    required int ctns,
    required int unitPerCtn,
    required int qty,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _quantitySegment(
            label: '采购箱数',
            value: '$ctns',
          ),
          _quantitySeparator(),
          _quantitySegment(
            label: '装箱量',
            value: '$unitPerCtn',
          ),
          _quantitySeparator(),
          _quantitySegment(
            label: '总数',
            value: '$qty',
          ),
        ],
      ),
    );
  }

  Widget _quantitySegment({
    required String label,
    required String value,
  }) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          height: 1.2,
        ),
        children: [
          TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 34, 37, 43),
                height: 1.2,
                fontWeight: FontWeight.bold,
              )),
          TextSpan(
            text: ' $value',
            style: const TextStyle(
              color: wineRedColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantitySeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        '|',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 13,
          height: 1.2,
        ),
      ),
    );
  }
}

class _BatchNoCard extends StatefulWidget {
  final String batchNo;
  final TextEditingController controller;
  final ColorScheme colorScheme;
  final List<TemporaryMedia> batchPhotos;
  final String? recognizedBatchNo1;
  final String? recognizedBatchNo2;
  final ValueChanged<String>? onSelectRecognized;
  final void Function(String imageUrl) onPreviewImage;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onScanned;

  const _BatchNoCard({
    required this.batchNo,
    required this.controller,
    required this.colorScheme,
    required this.batchPhotos,
    this.recognizedBatchNo1,
    this.recognizedBatchNo2,
    this.onSelectRecognized,
    required this.onPreviewImage,
    required this.onChanged,
    required this.onScanned,
  });

  @override
  State<_BatchNoCard> createState() => _BatchNoCardState();
}

class _BatchNoCardState extends State<_BatchNoCard> {
  late final FocusNode _focusNode;

  bool get _recognized => widget.batchNo.trim().isNotEmpty;

  bool get _hasPhoto => widget.batchPhotos.isNotEmpty;

  bool get _bothRecognized =>
      widget.recognizedBatchNo1 != null && widget.recognizedBatchNo2 != null;

  bool get _bothMatch =>
      _bothRecognized && widget.recognizedBatchNo1 == widget.recognizedBatchNo2;

  void _openPhotoPreview(String imageUrl) {
    _focusNode.unfocus();
    widget.onPreviewImage(imageUrl);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openScanner() async {
    _focusNode.unfocus();
    final String? result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) => const _TextRecognitionBottomSheet(),
    );

    if (result != null) {
      widget.onScanned(result);
    }
  }

  Widget _buildBatchPhotoThumbnail({bool isMobile = false}) {
    final firstPhoto = widget.batchPhotos.first;
    final thumbUrl = firstPhoto.thumbUrl ?? firstPhoto.url;
    final originUrl = firstPhoto.url;

    return Padding(
      padding: isMobile ? EdgeInsets.zero : const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _openPhotoPreview(originUrl),
        child: Container(
          width: isMobile ? double.infinity : 160,
          height: isMobile ? 200 : 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            color: const Color.fromARGB(255, 239, 239, 239),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              thumbUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 28,
                  color: Color(0xFF999999),
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF999999),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecognitionRow(String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    final isMatch = _bothMatch;
    final canSelect = !isMatch && widget.onSelectRecognized != null;

    return GestureDetector(
      onTap: canSelect ? () => widget.onSelectRecognized!(value) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Color.fromARGB(255, 34, 37, 43),
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isMatch ? greenColor : wineRedColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
          if (canSelect)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.touch_app, size: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildMatchIndicator() {
    final isMatch = _bothMatch;
    return Row(
      children: [
        Icon(
          isMatch ? Icons.check_circle : Icons.warning_amber_rounded,
          size: 16,
          color: isMatch ? greenColor : Colors.red,
        ),
        const SizedBox(width: 4),
        Text(
          isMatch ? '识别结果一致' : '识别结果不一致，请点击选择',
          style: TextStyle(
            color: isMatch ? greenColor : Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleRow(
              icon: Icons.qr_code_2,
              title: '批次号',
              color: widget.colorScheme.primary,
              textColor: const Color(0xFF333333),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 420;
                final batchContent = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '批次号: ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 34, 37, 43),
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 36,
                            child: TextField(
                              focusNode: _focusNode,
                              onChanged: widget.onChanged,
                              controller: widget.controller,
                              style: TextStyle(
                                fontSize: 13,
                                color: _recognized ? wineRedColor : null,
                                fontWeight:
                                    _recognized ? FontWeight.w600 : null,
                              ),
                              decoration: InputDecoration(
                                hintText: '输入或扫描批次号',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: widget.colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _openScanner,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 239, 239, 239),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: CustomScanIcon(
                                size: 22,
                                color: _recognized ? greenColor : wineRedColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (widget.recognizedBatchNo1 != null ||
                        widget.recognizedBatchNo2 != null) ...[
                      _buildRecognitionRow('批次号1', widget.recognizedBatchNo1),
                      if (widget.recognizedBatchNo2 != null) ...[
                        const SizedBox(height: 4),
                        _buildRecognitionRow('批次号2', widget.recognizedBatchNo2),
                      ],
                      if (_bothRecognized) ...[
                        const SizedBox(height: 4),
                        _buildMatchIndicator(),
                      ],
                      const SizedBox(height: 6),
                    ],
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.info_outline,
                            size: 13,
                            color: Color(0xFF999999),
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '批次号通过上传批次号图片自动识别，识别错误可尝试扫描识别或手动输入',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );

                if (isMobile && _hasPhoto) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBatchPhotoThumbnail(isMobile: true),
                      const SizedBox(height: 12),
                      batchContent,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_hasPhoto) _buildBatchPhotoThumbnail(),
                    Expanded(child: batchContent),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewImagePage extends StatefulWidget {
  final ImageProvider imageProvider;

  const _PreviewImagePage({
    super.key,
    required this.imageProvider,
  });

  @override
  State<_PreviewImagePage> createState() => _PreviewImagePageState();
}

class _PreviewImagePageState extends State<_PreviewImagePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _loadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 2,
      child: Center(
        child: Image(
          image: widget.imageProvider,
          fit: BoxFit.contain,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) return child;
            return _loadingIndicator();
          },
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color textColor;
  const _TitleRow(
      {required this.icon,
      required this.title,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1)),
        ],
      );
}

/// 底部扫描页：Hook 管理 [MobileScannerController] 生命周期；Android 上提高分辨率并走新选择器，减轻放大后发糊。
class _BarcodeScannerBottomSheet extends HookWidget {
  const _BarcodeScannerBottomSheet();

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        // Android（含多数鸿蒙上的 Flutter 安装包）：默认分析分辨率很低，cover 全屏会糊；指定分辨率并走新选择器，在华为等机型上更稳。
        cameraResolution: Platform.isAndroid ? const Size(1920, 1080) : null,
        useNewCameraSelector: Platform.isAndroid,
      ),
    );

    useEffect(() {
      return controller.dispose;
    }, [controller]);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;
              final barcode = capture.barcodes.first;
              if (barcode.rawValue != null) {
                Navigator.pop(context, barcode.rawValue);
              }
            },
          ),
          Positioned.fill(
            child: Container(
              decoration: const ShapeDecoration(
                shape: ScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 5,
                  cutOutSize: 250,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              '请将条形码置于框内',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// 文字识别扫描器（OCR）—— 用于识别批次号数字
/// 通过相机实时预览画面，自动识别其中的数字字符并返回
class _TextRecognitionBottomSheet extends StatefulWidget {
  const _TextRecognitionBottomSheet();

  @override
  State<_TextRecognitionBottomSheet> createState() =>
      _TextRecognitionBottomSheetState();
}

class _TextRecognitionBottomSheetState
    extends State<_TextRecognitionBottomSheet> {
  CameraController? _cameraController;
  TextRecognizer? _textRecognizer;
  bool _isInitialized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _textRecognizer?.close();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty || !mounted) return;

      _textRecognizer = TextRecognizer();
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() => _isInitialized = true);
      await _cameraController!.startImageStream(_onImageStream);
    } catch (e) {
      if (mounted) {
        EasyLoading.showError('相机启动失败: $e');
        Navigator.pop(context);
      }
    }
  }

  void _onImageStream(CameraImage image) {
    if (_isProcessing || !mounted) return;
    _isProcessing = true;

    try {
      final inputImage = _buildInputImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return;
      }

      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      _textRecognizer!
          .processImage(inputImage)
          .then((RecognizedText recognizedText) {
        if (!mounted) return;

        final centerText = _extractCenterText(recognizedText, imageSize);
        final digits = centerText.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.isNotEmpty && digits.length >= 3) {
          _cameraController?.stopImageStream();
          Navigator.pop(context, digits);
          return;
        }
        _isProcessing = false;
      }).catchError((_) {
        _isProcessing = false;
      });
    } catch (e) {
      _isProcessing = false;
    }
  }

  String _extractCenterText(RecognizedText recognizedText, Size imageSize) {
    final double centerX = imageSize.width / 2;
    final double centerY = imageSize.height / 2;
    final double halfW = imageSize.width * 0.20;
    final double halfH = imageSize.height * 0.20;

    final StringBuffer sb = StringBuffer();
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          final box = element.boundingBox;
          final boxCenterX = (box.left + box.right) / 2;
          final boxCenterY = (box.top + box.bottom) / 2;
          if ((boxCenterX - centerX).abs() < halfW &&
              (boxCenterY - centerY).abs() < halfH) {
            sb.write(element.text);
          }
        }
      }
    }
    return sb.toString();
  }

  InputImage? _buildInputImage(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation rotation;

    if (Platform.isAndroid) {
      rotation = InputImageRotation.values.firstWhere(
        (r) => r.rawValue == sensorOrientation,
        orElse: () => InputImageRotation.rotation0deg,
      );
    } else {
      rotation = InputImageRotation.rotation0deg;
    }

    final int width = image.width;
    final int height = image.height;

    if (Platform.isAndroid) {
      final nv21 = _yuv420ToNv21(image);
      return InputImage.fromBytes(
        bytes: nv21,
        metadata: InputImageMetadata(
          size: Size(width.toDouble(), height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: width,
        ),
      );
    } else {
      final plane = image.planes[0];
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(width.toDouble(), height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.bgra8888,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    }
  }

  Uint8List _yuv420ToNv21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final Uint8List yPlane = image.planes[0].bytes;
    final Uint8List uPlane = image.planes[1].bytes;
    final Uint8List vPlane = image.planes[2].bytes;

    final int yRowStride = image.planes[0].bytesPerRow;
    final int yPixelStride = image.planes[0].bytesPerPixel ?? 1;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    final int nv21Size = width * height + (width * height) ~/ 2;
    final Uint8List nv21 = Uint8List(nv21Size);

    // 复制 Y 平面，剥离行填充（stride）
    for (int row = 0; row < height; row++) {
      final int srcOffset = row * yRowStride;
      final int dstOffset = row * width;
      for (int col = 0; col < width; col++) {
        nv21[dstOffset + col] = yPlane[srcOffset + col * yPixelStride];
      }
    }

    // 复制 UV 平面为 NV21 交错的 VU（V 在前，U 在后）
    final int uvHeight = height ~/ 2;
    final int uvWidth = width ~/ 2;
    final int uvDstOffset = width * height;

    for (int row = 0; row < uvHeight; row++) {
      final int srcRowOffset = row * uvRowStride;
      final int dstRowOffset = uvDstOffset + row * width;

      for (int col = 0; col < uvWidth; col++) {
        final int srcIndex = srcRowOffset + col * uvPixelStride;
        final int dstIndex = dstRowOffset + col * 2;
        nv21[dstIndex] = vPlane[srcIndex];
        nv21[dstIndex + 1] = uPlane[srcIndex];
      }
    }

    return nv21;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Stack(
        children: [
          if (_isInitialized && _cameraController != null)
            CameraPreview(_cameraController!)
          else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    '正在启动相机...',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),

          // 扫描框覆盖层（复用条码扫描框样式）
          Positioned.fill(
            child: Container(
              decoration: const ShapeDecoration(
                shape: ScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 5,
                  cutOutSize: 250,
                ),
              ),
            ),
          ),

          // 关闭按钮
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 提示文字
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              '请将批次号数字置于框内',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// 扫描框自定义形状组件
class ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final double cutOutSize;

  const ScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 10,
    this.borderLength = 40,
    this.borderRadius = 0,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path background = Path()..addRect(rect);
    Path cutOut = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: rect.center, width: cutOutSize, height: cutOutSize),
        Radius.circular(borderRadius),
      ));
    return Path.combine(PathOperation.difference, background, cutOut);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final center = rect.center;
    final halfSize = cutOutSize / 2;

    // 绘制四个角的边框 (简化逻辑)
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - halfSize, center.dy - halfSize + borderLength)
        ..lineTo(center.dx - halfSize, center.dy - halfSize)
        ..lineTo(center.dx - halfSize + borderLength, center.dy - halfSize),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + halfSize, center.dy - halfSize + borderLength)
        ..lineTo(center.dx + halfSize, center.dy - halfSize)
        ..lineTo(center.dx + halfSize - borderLength, center.dy - halfSize),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - halfSize, center.dy + halfSize - borderLength)
        ..lineTo(center.dx - halfSize, center.dy + halfSize)
        ..lineTo(center.dx - halfSize + borderLength, center.dy + halfSize),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + halfSize, center.dy + halfSize - borderLength)
        ..lineTo(center.dx + halfSize, center.dy + halfSize)
        ..lineTo(center.dx + halfSize - borderLength, center.dy + halfSize),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

/// 返工产品的历史验货记录内联组件，支持每个轮次独立展开/收起
/// 仅展示历史轮次的验货记录，不包含当前（返工中）轮次
/// 轮次按倒序排列（最近在前），默认展开最近一个轮次
class _InspectionHistoryInline extends StatefulWidget {
  const _InspectionHistoryInline({
    required this.rounds,
    required this.isExpanded,
    required this.onToggle,
    required this.colorScheme,
  });

  final List<InspectionRoundSnapshot> rounds;
  final bool isExpanded;
  final VoidCallback onToggle;
  final ColorScheme colorScheme;

  @override
  State<_InspectionHistoryInline> createState() =>
      _InspectionHistoryInlineState();
}

class _InspectionHistoryInlineState extends State<_InspectionHistoryInline> {
  final Set<int> _expandedRounds = {};

  @override
  void initState() {
    super.initState();
    if (widget.rounds.isNotEmpty) {
      _expandedRounds.add(0);
    }
  }

  void _toggleRound(int index) {
    setState(() {
      if (_expandedRounds.contains(index)) {
        _expandedRounds.remove(index);
      } else {
        _expandedRounds.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reversedRounds = widget.rounds.reversed.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                const Icon(Icons.history, size: 20, color: Color(0xFF1890FF)),
                const SizedBox(width: 8),
                const Text(
                  '历史验货记录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                Text(
                  '共 ${widget.rounds.length} 轮',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: widget.isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xFF666666),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isExpanded) ...[
            const SizedBox(height: 12),
            ...reversedRounds.asMap().entries.map((entry) {
              final index = entry.key;
              final round = entry.value;
              final roundNumber = round.round ?? widget.rounds.length - index;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: InspectionRoundCard(
                  roundLabel: '第 $roundNumber 轮',
                  status: round.status,
                  remark: round.remark,
                  createdAt: round.createdAt,
                  medias: round.mediaSnapshot ?? [],
                  isCurrent: false,
                  isExpanded: _expandedRounds.contains(index),
                  onToggle: () => _toggleRound(index),
                  colorScheme: widget.colorScheme,
                  onImageTap: (medias) {
                    final urls = medias
                        .map((m) => m.url)
                        .whereType<String>()
                        .where((u) => u.isNotEmpty)
                        .toList();
                    if (urls.isNotEmpty) {
                      showFlanImagePreview(context,
                          images: urls, startPosition: 0, loop: false);
                    }
                  },
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
