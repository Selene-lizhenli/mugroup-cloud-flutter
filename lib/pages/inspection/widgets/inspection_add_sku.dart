import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InspectionAddSku extends HookConsumerWidget {
  const InspectionAddSku({super.key});

  static const _primaryColor = Color(0xFF3B66F5);
  static const _bgGrey = Color(0xFFF2F4F7);
  static const _contentHeight = 180.0;
  static const _radius = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final controller = useTextEditingController();
    useListenable(controller);

    final isButtonEnabled =
        controller.text.trim().isNotEmpty && tabIndex.value == 0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          _SegmentedTab(
            index: tabIndex.value,
            onChanged: (i) {
              FocusScope.of(context).unfocus();
              tabIndex.value = i;
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: _contentHeight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeOutCubic,
              child: tabIndex.value == 0
                  ? _ManualInput(
                      key: const ValueKey('manual'),
                      controller: controller,
                    )
                  : const _UploadContent(
                      key: ValueKey('upload'),
                    ),
            ),
          ),
          _buildBottomButton(context, isButtonEnabled),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '添加 SKU',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, bool enabled) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: enabled ? () => Navigator.pop(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              disabledBackgroundColor: Colors.grey[200],
              disabledForegroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
            ),
            child: const Text(
              '确认添加',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedTab extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _SegmentedTab({
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: InspectionAddSku._bgGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment:
                  index == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: (MediaQuery.of(context).size.width - 32) / 2 - 4,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _TabItem(
                  text: '手动输入',
                  selected: index == 0,
                  onTap: () => onChanged(0),
                ),
                _TabItem(
                  text: '上传表格',
                  selected: index == 1,
                  onTap: () => onChanged(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}

class _ManualInput extends StatelessWidget {
  final TextEditingController controller;

  const _ManualInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: InspectionAddSku._bgGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              expands: true,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入 SKU 编号，支持换行输入多个\n例如：\nSKU-001\nSKU-002',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text('每行输入一个 SKU',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          )
        ],
      ),
    );
  }
}

class _UploadContent extends StatelessWidget {
  const _UploadContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: InspectionAddSku._bgGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_rounded,
              size: 36, color: InspectionAddSku._primaryColor),
          SizedBox(height: 12),
          Text('点击上传 Excel / CSV 文件',
              style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 4),
          Text('支持 .xlsx, .csv 格式',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
