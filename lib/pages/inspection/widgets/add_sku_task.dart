import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';

class AddSkuSubmitData {
  const AddSkuSubmitData._({
    required this.tabIndex,
    this.skuList,
    this.selectedFile,
  });

  factory AddSkuSubmitData.manual(List<String> skuList) => AddSkuSubmitData._(
        tabIndex: 0,
        skuList: skuList,
      );

  factory AddSkuSubmitData.upload(PlatformFile selectedFile) =>
      AddSkuSubmitData._(
        tabIndex: 1,
        selectedFile: selectedFile,
      );

  final int tabIndex;
  final List<String>? skuList;
  final PlatformFile? selectedFile;
}

class AddSkuTask extends HookWidget {
  const AddSkuTask({
    super.key,
    required this.onSubmit,
    this.fromAddPage,
    this.controlBtnIsEnabledInOuter,
  });

  static const _bgGrey = Color(0xFFF2F4F7);
  static const _contentHeight = 220.0;
  final Future<void> Function(AddSkuSubmitData data) onSubmit;
  final bool? fromAddPage;
  final bool? controlBtnIsEnabledInOuter;

  @override
  Widget build(BuildContext context) {
    final tabIndex = useState(1);
    final controller = useTextEditingController();
    final selectedFile = useState<PlatformFile?>(null);
    final isLoading = useState(false);

    useListenable(controller);

    final isButtonEnabled = controlBtnIsEnabledInOuter ??
        (tabIndex.value == 0
            ? controller.text.trim().isNotEmpty
            : selectedFile.value != null);

    final buttonText = fromAddPage == true
        ? '新建验货记录'
        : tabIndex.value == 1
            ? '上传并解析'
            : '确认添加';
    final btnPadding = fromAddPage == true
        ? const EdgeInsets.fromLTRB(0, 12, 0, 16)
        : const EdgeInsets.fromLTRB(16, 12, 16, 16);

    Future<void> pickFile() async {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls'],
        );

        if (result != null) {
          selectedFile.value = result.files.single;
        }
      } catch (_) {
        EasyLoading.showError('选择文件失败');
      }
    }

    Future<void> handleSubmit() async {
      FocusScope.of(context).unfocus();
      if (!isButtonEnabled || isLoading.value) return;

      isLoading.value = true;
      try {
        if (tabIndex.value == 0) {
          final skuList = controller.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          if (skuList.isEmpty) return;
          await onSubmit(AddSkuSubmitData.manual(skuList));
        } else {
          final file = selectedFile.value;
          if (file == null || file.path == null) return;
          await onSubmit(AddSkuSubmitData.upload(file));
        }
      } finally {
        isLoading.value = false;
      }
    }

    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        _SegmentedTab(
          index: tabIndex.value,
          onChanged: (index) => tabIndex.value = index,
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
        SafeArea(
          child: Padding(
            padding: btnPadding,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    (isButtonEnabled && !isLoading.value) ? handleSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: Colors.grey[200],
                  disabledForegroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: isLoading.value
                    ? const MuProgressIndicator()
                    : Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
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
          color: AddSkuTask._bgGrey,
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
                    ),
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
        color: AddSkuTask._bgGrey,
        borderRadius: BorderRadius.circular(12),
      ),
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
                    color: colorScheme.outline.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 32,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '点击选择表格文件',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '支持 Excel (.xlsx, .xls) 格式',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                      // Positioned(
                      //   top: 8,
                      //   right: 12,
                      //   child: Text(
                      //     '下载通用模板',
                      //     style: TextStyle(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //       color: colorScheme.outline,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ),
          ),
          if (selectedFile != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AddSkuTask._bgGrey,
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
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
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
