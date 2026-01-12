import 'package:cloud/services/inspection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InspectionAddSku extends HookConsumerWidget {
  final int id;
  const InspectionAddSku({super.key, required this.id});

  static const _bgGrey = Color(0xFFF2F4F7);

  static const _contentHeight = 220.0;
  static const _radius = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final controller = useTextEditingController();
    final primaryColor = Theme.of(context).colorScheme.primary;
    useListenable(controller);

    final selectedFile = useState<PlatformFile?>(null);
    final isLoading = useState(false);

    final isButtonEnabled = tabIndex.value == 0
        ? controller.text.trim().isNotEmpty
        : selectedFile.value != null;

    Future<void> pickFile() async {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls'],
        );

        if (result != null) {
          selectedFile.value = result.files.single;
        }
      } catch (e) {
        EasyLoading.showError('选择文件失败');
      }
    }

    Future<void> handleSubmit() async {
      FocusScope.of(context).unfocus();
      isLoading.value = true;

      try {
        if (tabIndex.value == 0) {
          final text = controller.text;
          final List<String> skuList = text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

          if (skuList.isEmpty) return;
          await addInspectionItems(id, {'item_nos': skuList});
        } else {
          final file = selectedFile.value;
          if (file == null || file.path == null) return;

          final formData = FormData.fromMap({
            'file':
                await MultipartFile.fromFile(file.path!, filename: file.name),
          });

          await importInspectionItems(id, formData);
        }

        EasyLoading.showSuccess('添加成功');
        if (context.mounted) Navigator.pop(context);
      } catch (e) {
        EasyLoading.showError('操作失败: $e');
      } finally {
        isLoading.value = false;
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
              child: tabIndex.value == 0
                  ? _ManualInput(
                      key: const ValueKey('manual'),
                      controller: controller,
                    )
                  : _UploadContent(
                      key: const ValueKey('upload'),
                      selectedFile: selectedFile.value,
                      onPickFile: pickFile,
                      onClearFile: () => selectedFile.value = null,
                    ),
            ),
          ),
          _buildBottomButton(
            context,
            isButtonEnabled,
            isLoading.value,
            handleSubmit,
            tabIndex.value == 1,
            primaryColor,
          ),
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
          const Text('添加 SKU',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.grey[100], shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 18, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, bool enabled, bool isLoading,
      VoidCallback onPressed, bool isUploadMode, Color primaryColor) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (enabled && !isLoading) ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              disabledBackgroundColor: Colors.grey[200],
              disabledForegroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_radius)),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white))
                : Text(
                    isUploadMode ? '上传并解析' : '确认添加',
                    style: const TextStyle(
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

  const _SegmentedTab({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
            color: InspectionAddSku._bgGrey,
            borderRadius: BorderRadius.circular(12)),
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
                        offset: const Offset(0, 2))
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _TabItem(
                    text: '手动输入',
                    selected: index == 0,
                    onTap: () => onChanged(0)),
                _TabItem(
                    text: '上传表格',
                    selected: index == 1,
                    onTap: () => onChanged(1)),
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

  const _TabItem(
      {required this.text, required this.selected, required this.onTap});

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
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        expands: true,
        maxLines: null,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入 SKU 编号，每行一个',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ),
    );
  }
}

class _UploadContent extends StatelessWidget {
  final PlatformFile? selectedFile;
  final VoidCallback onPickFile;
  final VoidCallback onClearFile;

  const _UploadContent({
    super.key,
    this.selectedFile,
    required this.onPickFile,
    required this.onClearFile,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onPickFile,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey[300]!, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        size: 32, color: primaryColor),
                    const SizedBox(height: 8),
                    const Text('点击选择表格文件',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333))),
                    const SizedBox(height: 4),
                    const Text('支持 Excel (.xlsx, .xls) 格式',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                  ],
                ),
              ),
            ),
          ),
          if (selectedFile != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: InspectionAddSku._bgGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedFile!.name,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF333333)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onClearFile,
                    child:
                        const Icon(Icons.cancel, color: Colors.grey, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
