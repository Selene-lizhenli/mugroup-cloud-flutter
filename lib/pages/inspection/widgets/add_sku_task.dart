import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud/models/inspection/inspection_import_template.dart';
import 'package:cloud/pages/inspection/models/add_sku_submit_data.dart';
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/inspection.dart';

class AddSkuTask extends HookConsumerWidget {
  const AddSkuTask({
    super.key,
    this.onSubmit,
    this.showSubmitButton = true,
    this.fromAddPage,
    this.controlBtnIsEnabledInOuter,
  });

  static const _bgGrey = Color(0xFFF2F4F7);
  static const _contentHeight = 220.0;
  final Future<void> Function(AddSkuSubmitData data)? onSubmit;

  /// 为 `false` 时不展示底部提交按钮，数据写入 [inspectionDetailProvider] 的 addSkuDraft。
  final bool showSubmitButton;
  final bool? fromAddPage;
  final bool? controlBtnIsEnabledInOuter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final controller = useTextEditingController();
    final selectedFile = useState<PlatformFile?>(null);
    final isLoading = useState(false);
    final importTemplates = useState<List<InspectionImportTemplate>>([]);
    final selectedImportTemplates = useState<InspectionImportTemplate?>(null);

    useListenable(controller);

    useEffect(() {
      Future<void> loadImportTemplates() async {
        try {
          final templates = await getInspectionImportTemplates();
          if (context.mounted) {
            importTemplates.value = templates;
          }
        } catch (_) {}
      }

      loadImportTemplates();
      return null;
    }, const []);

    final isButtonEnabled = controlBtnIsEnabledInOuter ??
        (tabIndex.value == 1
            ? controller.text.trim().isNotEmpty
            : selectedFile.value != null);

    void writeDraftToProvider() {
      if (showSubmitButton) return;
      final draft = ref.read(inspectionDetailProvider.notifier);
      if (tabIndex.value == 1) {
        final skuList = controller.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (skuList.isEmpty) {
          draft.setAddSkuDraft(null);
        } else {
          draft.setAddSkuDraft(AddSkuSubmitData.manual(skuList));
        }
      } else {
        final file = selectedFile.value;
        if (file == null || file.path == null) {
          draft.setAddSkuDraft(null);
        } else {
          draft.setAddSkuDraft(AddSkuSubmitData.upload(
            file,
            templateKey: selectedImportTemplates.value?.value,
          ));
        }
      }
    }

    useEffect(() {
      if (showSubmitButton) return null;
      // 不得在 build / hook 同步阶段改 provider，须排到帧后。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        writeDraftToProvider();
      });
      return null;
    }, [
      showSubmitButton,
      tabIndex.value,
      selectedFile.value,
      selectedImportTemplates.value,
      controller.text,
    ]);

    final buttonText = fromAddPage == true
        ? '新建验货记录'
        : tabIndex.value == 0
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

    Future<void> handleUploadTap() async {
      final templates = importTemplates.value;
      if (templates.isEmpty) {
        await pickFile();
        return;
      }

      final selected = await _ImportTemplatePickerSheet.show(
        context,
        templates: templates,
      );
      if (!context.mounted || selected == null) return;

      selectedImportTemplates.value = selected;
      await pickFile();
    }

    Future<void> handleSubmit() async {
      FocusScope.of(context).unfocus();
      if (!isButtonEnabled || isLoading.value) return;

      isLoading.value = true;
      try {
        if (tabIndex.value == 1) {
          final skuList = controller.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          if (skuList.isEmpty) return;
          final data = AddSkuSubmitData.manual(skuList);
          ref.read(inspectionDetailProvider.notifier).setAddSkuDraft(data);
          if (showSubmitButton && onSubmit != null) {
            await onSubmit!(data);
          }
        } else {
          final file = selectedFile.value;
          if (file == null || file.path == null) return;
          final data = AddSkuSubmitData.upload(
            file,
            templateKey: selectedImportTemplates.value?.value,
          );
          ref.read(inspectionDetailProvider.notifier).setAddSkuDraft(data);
          if (showSubmitButton && onSubmit != null) {
            await onSubmit!(data);
          }
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
        const SizedBox(height: 6),
        SizedBox(
          height: _contentHeight,
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: tabIndex.value == 0
                  ? _UploadContent(
                      key: const ValueKey('upload'),
                      selectedFile: selectedFile.value,
                      onTap: handleUploadTap,
                      onClearFile: () {
                        selectedFile.value = null;
                        selectedImportTemplates.value = null;
                      },
                    )
                  : _ManualInput(
                      key: const ValueKey('manual'),
                      controller: controller,
                    )),
        ),
        if (showSubmitButton)
          SafeArea(
            child: Padding(
              padding: btnPadding,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (isButtonEnabled && !isLoading.value)
                      ? handleSubmit
                      : null,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  text: '上传表格',
                  selected: index == 0,
                  onTap: () => onChanged(0),
                ),
                _TabItem(
                  text: '手动输入',
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
      margin: const EdgeInsets.symmetric(horizontal: 12),
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
  final Future<void> Function() onTap;
  final VoidCallback onClearFile;

  const _UploadContent({
    super.key,
    this.selectedFile,
    required this.onTap,
    required this.onClearFile,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(),
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

class _ImportTemplatePickerSheet extends StatelessWidget {
  const _ImportTemplatePickerSheet({required this.templates});

  final List<InspectionImportTemplate> templates;

  static Future<InspectionImportTemplate?> show(
    BuildContext context, {
    required List<InspectionImportTemplate> templates,
  }) {
    final maxHeight = MediaQuery.of(context).size.height * 0.5;
    final sheetHeight = (templates.length * 56.0 + 72).clamp(180.0, maxHeight);

    return showModalBottomSheet<InspectionImportTemplate>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      builder: (_) => SizedBox(
        height: sheetHeight,
        child: _ImportTemplatePickerSheet(templates: templates),
      ),
    );
  }

  String _label(InspectionImportTemplate template) {
    final name = template.label?.trim();
    if (name != null && name.isNotEmpty) return name;
    final key = template.value?.trim();
    if (key != null && key.isNotEmpty) return key;
    return '未命名模板';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '选择导入模板',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: templates.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final template = templates[index];
                return ListTile(
                  title: Text(
                    _label(template),
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Navigator.pop(context, template),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
