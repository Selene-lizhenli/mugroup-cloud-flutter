import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/inspection/const.dart';
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:cloud/pages/inspection/widgets/add_sku_task.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/services/inspection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; 

@RoutePage()
class InspectionAddPage extends HookConsumerWidget {
  const InspectionAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color primaryColor = colorScheme.primary;
    final redColor = colorScheme.error;

    const Color backgroundColor = Color(0xFFF5F7FA);
    const Color labelColor = Color.fromARGB(255, 62, 62, 62);
    final Color borderColor = Colors.grey[300]!;
    const Color hintColor = Color(0xFF999999);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    final titleController = useTextEditingController();
    final titleValue = useState('');

    final attachmentImages = useState<List<TemporaryMedia>>([]);
    final isSubmitting = useState(false);
    // final templateLoading = useState(false);
    // final templateLoadError = useState<String?>(null);
    // final templateKeys = useState<List<Map<String, dynamic>>>([]);
    final selectedTemplateKey = useState<String>('0');
    final onlyRequired = useState(true); // 是否只显示必填项

    // 须 watch，否则 autoDispose 在无监听时销毁，AddSkuTask 写入的草稿会丢失。
    final skuDraft = ref.watch(
      inspectionDetailProvider.select((s) => s.addSkuDraft),
    );
    final templateKeys = ref.watch(
      inspectionDetailProvider.select((s) => s.templateKeys),
    );
    final templateLoading = ref.watch(
      inspectionDetailProvider.select((s) => s.templateLoading),
    );
    final templateLoadError = ref.watch(
      inspectionDetailProvider.select((s) => s.templateLoadError),
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(inspectionDetailProvider.notifier).loadTemplateKeys();
      });

      return null;
    }, const []);

    //    useEffect(() {
    //   Future<void> loadTemplateKeys() async {
    //     templateLoading.value = true;
    //     templateLoadError.value = null;
    //     try {
    //       final keys = await getInspectionTemplateKeys();
    //       templateKeys.value = keys;
    //     } catch (e) {
    //       templateLoadError.value = '模板加载失败！';
    //     } finally {
    //       if (context.mounted) {
    //         templateLoading.value = false;
    //       }
    //     }
    //   }

    //   loadTemplateKeys();
    //   return null;
    // }, const []);

    //只显示必填项时 的 提交
    Future<void> createInspectionTaskOnlyRequired() async {
      if (!formKey.currentState!.validate()) return;

      isSubmitting.value = true;

      try {
        final payload = <String, dynamic>{
          'name': titleController.text.trim(),
        };
        final inspection = await storeInspection(payload);
        final taskId = inspection?.id;
        if (taskId == null) {
          EasyLoading.showError('创建失败');
          return;
        }
        if (context.mounted) {
          EasyLoading.showSuccess('创建成功');
          context.router.maybePop(true);
        }
      } catch (e) {
        EasyLoading.showError('操作失败: $e');
      } finally {
        if (context.mounted) {
          isSubmitting.value = false;
        }
      }
    }

    Future<void> createInspectionTask() async {
      if (!formKey.currentState!.validate()) return;

      final data = skuDraft;
      isSubmitting.value = true;

      try {
        final payload = <String, dynamic>{
          'name': titleController.text.trim(),
        };
        if (selectedTemplateKey.value.isNotEmpty) {
          payload['inspection_dynamic_template_id'] = selectedTemplateKey.value;
        }

        final imgs = attachmentImages.value;
        if (imgs.isNotEmpty) {
          payload['images'] = imgs;
        }

        final inspection = await storeInspection(payload);

        final taskId = inspection?.id;
        if (taskId == null) {
          EasyLoading.showError('创建失败');
          return;
        }
        if (data != null) {
          // tabIndex: 0=手动输入, 1=上传表格（见 AddSkuSubmitData）
          if (data.tabIndex == 0) {
            final skuList = data.skuList;
            if (skuList != null && skuList.isNotEmpty) {
              await addInspectionItems(taskId, {'item_nos': skuList});
            }
          } else {
            final file = data.selectedFile;
            if (file != null && file.path != null) {
              final formData = FormData.fromMap({
                'file': await MultipartFile.fromFile(
                  file.path!,
                  filename: file.name,
                ),
                if (data.templateKey != null) 'template_key': data.templateKey,
              });
              await importInspectionItems(taskId, formData);
            }
          }

          ref.read(inspectionDetailProvider.notifier).clearAddSkuDraft();
        }

        if (context.mounted) {
          EasyLoading.showSuccess('创建成功');
          context.router.maybePop(true);
        }
      } catch (e) {
        EasyLoading.showError('操作失败: $e');
      } finally {
        if (context.mounted) {
          isSubmitting.value = false;
        }
      }
    }

    createInspectionTaskhandle() {
      if (onlyRequired.value == true) {
        //只显示必填项
        createInspectionTaskOnlyRequired();
      } else {
        createInspectionTask();
      }
    }

    Widget buildTemplateOptionRow({
      required String label,
      required String value,
      double left = 0,
      FontWeight fontWeight = FontWeight.w400,
      bool radioLeading = false,
    }) {
      final selected = selectedTemplateKey.value == value;
      return InkWell(
        onTap: () => selectedTemplateKey.value = value,
        child: Padding(
          padding: EdgeInsets.only(left: left, right: 2, top: 6, bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (radioLeading) ...[
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: selected ? primaryColor : hintColor,
                ),
                if (label.isNotEmpty) const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: fontWeight,
                ),
              ),
              if (!radioLeading) ...[
                const SizedBox(width: 6),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: selected ? primaryColor : hintColor,
                ),
              ],
            ],
          ),
        ),
      );
    }

    Widget buildBottomActionBar() {
      return SafeArea(
        top: false,
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      side: BorderSide(
                        color: colorScheme.outline,
                        width: 1.5,
                      ),
                      value: onlyRequired.value,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        onlyRequired.value = value ?? false;
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '只看必填项',
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        isSubmitting.value ? null : createInspectionTaskhandle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSubmitting.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '创建验货任务',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: labelColor, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            '新增验货任务',
            style: TextStyle(
              color: labelColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: buildBottomActionBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '任务标题 ',
                            style: const TextStyle(
                              color: labelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                    color: redColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.fontSize ??
                                        15),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) => titleValue.value = value,
                          controller: titleController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '请输入任务标题';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: '示例：某某客户验货、某某订单号或者以及其他标识',
                            hintStyle:
                                const TextStyle(color: hintColor, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            filled: true,
                            fillColor: colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: redColor),
                            ),
                            isDense: true,
                          ),
                          style:
                              const TextStyle(fontSize: 14, color: labelColor),
                        ),
                      ],
                    ),
                  ),
                ),
                if (onlyRequired.value == false) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' 验货模板   ',
                              style: TextStyle(
                                color: labelColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.fontSize ??
                                    15,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  buildTemplateOptionRow(
                                    label: inspectionGroupBasicTemplate['name']
                                        as String,
                                    value: inspectionGroupBasicTemplate['value']
                                        .toString(),
                                    radioLeading: true,
                                  ), 
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (templateLoading)
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          child: SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 1),
                                          ),
                                        )
                                      else if (templateLoadError != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: Text(
                                            templateLoadError!,
                                            style: TextStyle(
                                                color: redColor, fontSize: 12),
                                          ),
                                        )
                                      else if (templateKeys.isNotEmpty)
                                        ...templateKeys.map(
                                          (key) => buildTemplateOptionRow(
                                            label: (key['name'] ?? ''),
                                            value: (key['id'] ?? ''),
                                            radioLeading: true,
                                          ),
                                        )
                                      else
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            '暂无定制模板',
                                            style: TextStyle(
                                              color: hintColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 0.0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' 备注图片   ',
                              style: TextStyle(
                                color: labelColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.fontSize ??
                                    15,
                              ),
                            ),
                            Text(
                              '${attachmentImages.value.length}/3张',
                              style: const TextStyle(
                                color: hintColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            child: ImageUploader(
                              label: null,
                              maxCount: 3,
                              width: 80,
                              height: 80,
                              value: attachmentImages.value,
                              onChanged: (list) =>
                                  attachmentImages.value = list,
                              customIcon: Icons.camera_alt,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12)),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 0.0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: TextStyle(color: redColor, fontSize: 14),
                            children: [
                              TextSpan(
                                text: ' 添加SKU',
                                style: TextStyle(
                                    color: labelColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.fontSize ??
                                        15),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        AddSkuTask(
                          fromAddPage: true,
                          showSubmitButton: false,
                          controlBtnIsEnabledInOuter:
                              titleValue.value.isNotEmpty,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
