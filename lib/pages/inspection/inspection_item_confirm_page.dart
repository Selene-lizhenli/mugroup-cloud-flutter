import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/services/inspection.dart';
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
        remarkController.text = data?.remark ?? '';
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
          submitData[key] = medias.map((e) => e.toJson()).toList();
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

class _PhotoCard extends StatelessWidget {
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

  static const Map<String, String> _gridConfig = {
    'shipping_mark_front': '正唛',
    'shipping_mark_side': '侧唛',
    'unboxing': '开箱',
    'barcode_label': '条码标签',
    'weight_proof': '产品重量',
    'cover': '产品主图',
  };

  @override
  Widget build(BuildContext context) {
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
              _TitleRow(
                  icon: Icons.camera_alt_outlined,
                  title: '验货图片',
                  color: blue,
                  textColor: text),
              const SizedBox(height: 16),
              Wrap(
                spacing: spacing,
                runSpacing: 16.0,
                children: _gridConfig.entries.map((entry) {
                  return _buildGridItem(
                    apiKey: entry.key,
                    label: entry.value,
                    width: itemSize,
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

  Widget _buildGridItem({
    required String apiKey,
    required String label,
    required double width,
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
                onChanged: (list) => onMediaChanged(apiKey, list),
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
