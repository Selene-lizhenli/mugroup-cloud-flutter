import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/field_selector.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/providers/field_config_provider.dart';
import 'package:cloud/services/inspection.dart';
import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/services/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InspectionItemConfirmPage extends HookConsumerWidget {
  final int id;
  const InspectionItemConfirmPage({super.key, required this.id});

  static const _cBlue = Color(0xFF3B68D8);
  static const _cBg = Color(0xFFF5F6FA);
  static const _cText = Color(0xFF333333);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionItem = useState<InspectionItem?>(null);
    final isLoading = useState(true);

    final mediaMap = useState<Map<String, List<TemporaryMedia>>>({});
    void updateMedia(String key, List<TemporaryMedia> medias) {
      final newMap = Map<String, List<TemporaryMedia>>.from(mediaMap.value);
      newMap[key] = medias;
      mediaMap.value = newMap;
    }

    final remarkController = useTextEditingController();

    Future loadInspection() async {
      try {
        final data = await showInspectionItem(id);
        inspectionItem.value = data;

        if (data?.remark != null) {
          remarkController.text = data!.remark!;
        }

        if (data?.media != null && data!.media!.isNotEmpty) {
          final Map<String, List<TemporaryMedia>> initMap = {};

          for (var item in data.media!) {
            if (item.id == null || item.url == null) {
              continue;
            }
            final String key = item.collectionName ?? 'details';

            final tempMedia = TemporaryMedia(
              id: item.id!,
              url: item.url!,
              thumbUrl: item.thumbUrl ?? item.url,
              uuid: null,
            );

            if (!initMap.containsKey(key)) {
              initMap[key] = [];
            }
            initMap[key]!.add(tempMedia);
          }
          mediaMap.value = initMap;
        }
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadInspection();
      return null;
    }, []);

    Future<void> handleSubmit() async {
      final Map<String, dynamic> submitData = {};

      mediaMap.value.forEach((key, medias) {
        if (medias.isNotEmpty) {
          submitData[key] = medias
              .map((e) => {
                    'id': e.id,
                    'url': e.url,
                    'thumb_url': e.thumbUrl,
                    if (e.uuid != null) 'uuid': e.uuid,
                  })
              .toList();
        }
      });

      submitData['remark'] = remarkController.text;
      submitData['status'] = 1;

      await updateInspectionItem(id, submitData);

      EasyLoading.showSuccess('验货完成');
      if (context.mounted) Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: _cBg,
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
              padding: const EdgeInsets.all(12),
              children: [
                _InfoCard(
                  blue: _cBlue,
                  text: _cText,
                  inspectionItem: inspectionItem.value,
                ),
                const SizedBox(height: 12),
                _PhotoCard(
                  blue: _cBlue,
                  text: _cText,
                  mediaMap: mediaMap.value,
                  onMediaChanged: updateMedia,
                ),
                const SizedBox(height: 12),
                _NoteCard(
                  blue: _cBlue,
                  text: _cText,
                  controller: remarkController,
                ),
              ],
            ),
          ),
          _buildBottomBtn(onPressed: handleSubmit),
        ],
      ),
    );
  }

  Widget _buildBottomBtn({VoidCallback? onPressed}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _cBlue,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('完成验货',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ),
      );
}

class _InfoCard extends StatelessWidget {
  final InspectionItem? inspectionItem;
  final Color blue;
  final Color text;
  const _InfoCard(
      {required this.blue, required this.text, this.inspectionItem});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TitleRow(
                  icon: Icons.store_mall_directory_outlined,
                  title: '产品验货',
                  color: blue,
                  textColor: text),
              Text('SKU: ${inspectionItem?.itemNo}',
                  style: TextStyle(color: blue, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _item('采购箱数', '${inspectionItem?.ctns ?? 0}', false),
              const SizedBox(width: 8),
              _item('装箱量', '${inspectionItem?.unitPerCtn ?? 0}', false),
              const SizedBox(width: 8),
              _item('总数量', '${inspectionItem?.qty ?? 0}', true),
            ],
          )
        ],
      ),
    );
  }

  Widget _item(String k, String v, bool active) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? blue : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$k: ',
                  style: TextStyle(
                      fontSize: 12,
                      color: active ? Colors.white : Colors.grey[600])),
              Text(v,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : Colors.black)),
            ],
          ),
        ),
      );
}

class _PhotoCard extends HookConsumerWidget {
  final Color blue;
  final Color text;
  final Map<String, List<TemporaryMedia>> mediaMap;
  final void Function(String key, List<TemporaryMedia> list) onMediaChanged;

  const _PhotoCard({
    required this.blue,
    required this.text,
    required this.mediaMap,
    required this.onMediaChanged,
  });

  static const Set<String> _photoKeys = {
    'shipping_mark_front',
    'shipping_mark_side',
    'unboxing',
    'barcode_label',
    'weight_proof',
    'cover',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'inspection_item_confirm_v1',
          defaultFields: inspectionDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));
    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    // 状态：是否直接拍照 (默认为 true)
    final isDirectCamera = useState(true);

    Future<void> handleAutoDistribute(List<File> files) async {
      if (files.isEmpty) return;

      try {
        EasyLoading.show(status: '正在智能分发...');

        // 1. 找出所有需要在网格显示的字段（按顺序）
        final gridFields = fieldConfigs
            .where((f) => f.isVisible && _photoKeys.contains(f.name))
            .toList();

        int fileIndex = 0;

        // 2. 遍历网格，填空
        for (final field in gridFields) {
          if (fileIndex >= files.length) break; // 照片分完了

          final key = field.name;
          final currentImages = mediaMap[key] ?? [];

          // 策略：如果该格子是空的，就填进去；如果有图了，就跳过（保留原图）
          if (currentImages.isEmpty) {
            final file = files[fileIndex];
            // 上传
            final media = await upload(file: file);
            // 更新状态
            onMediaChanged(key, [media]);
            fileIndex++;
          }
        }

        // 3. 剩下的照片 -> 全部堆到 details
        if (fileIndex < files.length) {
          final remainingFiles = files.sublist(fileIndex);
          final List<TemporaryMedia> newDetails = [];

          for (var file in remainingFiles) {
            final media = await upload(file: file);
            newDetails.add(media);
          }

          // 获取当前的 details 并追加
          final currentDetails = mediaMap['details'] ?? [];
          onMediaChanged('details', [...currentDetails, ...newDetails]);
        }

        EasyLoading.showSuccess('分发完成');
      } catch (e) {
        EasyLoading.showError('处理失败');
        debugPrint(e.toString());
      } finally {
        EasyLoading.dismiss();
      }
    }

    return _BaseCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          const double spacing = 12.0;
          final double itemSize =
              ((totalWidth - (spacing * 2)) / 3).floorToDouble();

          final detailsList = mediaMap['details'] ?? [];

          return Column(
            children: [
              // 顶部行：标题 + (切换按钮 & 字段设置)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧：标题
                  _TitleRow(
                    icon: Icons.camera_alt_outlined,
                    title: '验货图片',
                    color: blue,
                    textColor: text,
                  ),

                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildToggleItem(
                                label: '拍照',
                                isActive: isDirectCamera.value,
                                icon: Icons.check,
                                color: blue,
                                onTap: () => isDirectCamera.value = true,
                              ),
                              _buildToggleItem(
                                label: '相册',
                                isActive: !isDirectCamera.value,
                                icon: Icons.radio_button_unchecked,
                                color: blue,
                                onTap: () => isDirectCamera.value = false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) {
                                return FieldSelector(
                                  fields: fieldConfigs,
                                  defaultFields: inspectionDefaultFields,
                                  onConfigChanged:
                                      (List<FieldConfig> newConfigs) {
                                    notifier.updateConfigs(newConfigs);
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.settings,
                                  size: 16,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                "设置",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: spacing,
                runSpacing: 16.0,
                children: fieldConfigs
                    .where((field) =>
                        field.isVisible && _photoKeys.contains(field.name))
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  final int index = entry.key;
                  final FieldConfig field = entry.value;

                  return _buildGridItem(
                    apiKey: field.name,
                    label: field.label,
                    width: itemSize,
                    isDirectCamera: isDirectCamera.value,
                    mediaMap: mediaMap,
                    onMediaChanged: onMediaChanged,
                    // 3. 判断逻辑：只有索引为 0 (第一个) 时开启连拍 并且没有图片
                    enableContinuous: index == 0,
                    onContinuousCapture:
                        index == 0 ? handleAutoDistribute : null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('其他验货图片',
                          style: TextStyle(
                              color: text, fontWeight: FontWeight.w500)),
                      Text('${detailsList.length}/50张',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ImageUploader(
                    label: null,
                    maxCount: 50,
                    value: detailsList,
                    directCamera: isDirectCamera.value,
                    enableContinuous: false,
                    onChanged: (list) => onMediaChanged('details', list),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggleItem({
    required String label,
    required bool isActive,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 4), // 减小padding防止过宽
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            if (isActive) ...[
              Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11, // 稍微调小字体
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required String apiKey,
    required String label,
    required double width,
    required bool isDirectCamera,
    required bool enableContinuous,
    required Map<String, List<TemporaryMedia>> mediaMap,
    required void Function(String key, List<TemporaryMedia> list)
        onMediaChanged,
    void Function(List<File>)? onContinuousCapture,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label图片',
            style: TextStyle(
              fontSize: 13,
              color: text,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ImageUploader(
                label: null,
                maxCount: 1,
                value: mediaMap[apiKey] ?? [],
                directCamera: isDirectCamera,
                enableContinuous: enableContinuous,
                onChanged: (list) => onMediaChanged(apiKey, list),
                onContinuousCapture: onContinuousCapture,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends HookWidget {
  final Color blue;
  final Color text;
  final TextEditingController controller;

  const _NoteCard({
    required this.blue,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          _TitleRow(
            icon: Icons.edit_note,
            title: '验货备注',
            color: blue,
            textColor: text,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '请输入验货备注信息（选填）',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: blue)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: child,
      );
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
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      );
}
