import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/inspection/execute/widgets/dynamic_inspection.dart';
import 'package:cloud/pages/inspection/execute/widgets/dynamic_template_schema.dart';
import 'package:cloud/pages/inspection/execute/widgets/inspection_bottom_buttons.dart';
import 'package:cloud/pages/inspection/execute/widgets/inspection_remark.dart';
import 'package:cloud/pages/inspection/execute/widgets/normal_inspection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
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
import 'package:cloud/pages/inspection/const.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';

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

    void updateMedia(String key, List<TemporaryMedia> medias) {
      final newMap = Map<String, List<TemporaryMedia>>.from(mediaMap.value);
      newMap[key] = medias;
      mediaMap.value = newMap;
    }

    final remarkController = useTextEditingController();
    final scrollController = useScrollController();
    final remarkHasError = useState(false);

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
        if (data?.remark != null) {
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
          if (data?.media != null && data!.media!.isNotEmpty) {
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

      if ((targetStatus == 2 || targetStatus == 3) &&
          remarkController.text.trim().isEmpty) {
        EasyLoading.showInfo('微瑕或不合格必须填写验货备注');
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

      try {
        final Map<String, dynamic> submitData = {};

        mediaMap.value.forEach((key, medias) {
          if (medias.isNotEmpty) {
            submitData[key] = medias
                .map((e) => {
                      // Keep payload minimal to reduce submit size
                      // and avoid sending unnecessary fields.
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

      if ((targetStatus == 2 || targetStatus == 3) &&
          remarkController.text.trim().isEmpty) {
        EasyLoading.showInfo('微瑕或不合格必须填写验货备注');
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
        body: Column(
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
                      onBarcodeScanned: (code) {
                        HapticFeedback.mediumImpact();
                        if (inspectionItem.value != null) {
                          inspectionItem.value = inspectionItem.value!.copyWith(
                            barcode: code,
                          );
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (useNormalTemplate)
                    InspectionItemNormalPage(
                      id: id,
                      inspectionItem: inspectionItem.value,
                      mediaMap: mediaMap.value,
                      onMediaChanged: updateMedia,
                    )
                  else
                    InspectionItemDynamicPage(
                      isLoading: isLoading.value,
                      schema: DynamicTemplateSchema.extract(
                          inspectionItem.value?.inspectionDynamicTemplateJson),
                    ),
                  const SizedBox(height: 12),
                  InspectionRemark(
                    blue: colorScheme.primary,
                    text: colorScheme.onSurface,
                    controller: remarkController,
                    hasError: remarkHasError.value,
                  ),
                ],
              ),
            ),
            InspectionBottomButtons(
              onPressed:
                  useNormalTemplate ? handleSubmitNormal : handleSubmitDynamic,
              isSubmitting: isSubmitting.value,
              submittingStatus: submittingStatus.value,
            ),
          ],
        ));
  }
}

class _InfoCard extends StatelessWidget {
  final InspectionItem? inspectionItem;
  final ColorScheme colorScheme;
  final Color text;
  final Function(String) onBarcodeScanned;
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Text(
                  value,
                  style: const TextStyle(
                    color: wineRedColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              const SizedBox(height: 8),
              _buildBarcodeScannerAction(context),
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
    final productBarcode = _rawString(raw, '产品条码号'); // 定制模板的值
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
                  _hasText(stdBarcode) ? stdBarcode!.trim() : productBarcode,
                  context,
                ),
              ),
            ],
          ),
          if (_hasText(description)) ...[
            const SizedBox(height: 12),
            _descriptionInfo(description ?? productDescription),
          ],
          if (originalImageUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            _originalImageEntry(context, originalImageUrls),
          ],
          const SizedBox(height: 12),
        ],
      ),
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
