import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/inspection/widgets/add_sku_task.dart';
import 'package:cloud/router/router.gr.dart';
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
    const Color labelColor = Color(0xFF333333);
    final Color borderColor = Colors.grey[300]!;
    const Color hintColor = Color(0xFF999999);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    final titleController = useTextEditingController();
    final titleValue = useState('');

    final isSubmitting = useState(false);

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
                              text: '*',
                              style: TextStyle(color: redColor, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: ' 任务标题',
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
                          TextFormField(
                            onChanged: (value) => titleValue.value = value,
                            controller: titleController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '请输入任务标题';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: '示例：某某客户验货、某某订单号或者以及其他标识',
                              hintStyle: const TextStyle(
                                  color: hintColor, fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: redColor),
                              ),
                              isDense: true,
                            ),
                            style: const TextStyle(
                                fontSize: 14, color: labelColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '',
                              style: TextStyle(color: redColor, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: '   添加SKU',
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
                            controlBtnIsEnabledInOuter:
                                titleValue.value.isNotEmpty,
                            onSubmit: (data) async {
                              if (isSubmitting.value) return;
                              if (!formKey.currentState!.validate()) return;

                              isSubmitting.value = true;
                              try {
                                final inspection = await storeInspection(
                                  {'name': titleController.text.trim()},
                                );
                                final taskId = inspection?.id;
                                if (taskId == null) {
                                  EasyLoading.showError('创建失败');
                                  return;
                                }

                                if (data.tabIndex == 0) {
                                  final skuList = data.skuList;
                                  if (skuList == null || skuList.isEmpty) {
                                    return;
                                  }
                                  await addInspectionItems(
                                      taskId, {'item_nos': skuList});
                                } else {
                                  final file = data.selectedFile;
                                  if (file == null || file.path == null) return;

                                  final formData = FormData.fromMap({
                                    'file': await MultipartFile.fromFile(
                                      file.path!,
                                      filename: file.name,
                                    ),
                                  });
                                  await importInspectionItems(taskId, formData);
                                }

                                if (context.mounted) {
                                  EasyLoading.showSuccess('创建成功');
                                  context.router.replace(
                                      InspectionDetailRoute(id: taskId));
                                }
                              } catch (e) {
                                EasyLoading.showError('操作失败: $e');
                              } finally {
                                if (context.mounted) {
                                  isSubmitting.value = false;
                                }
                              }
                            },
                          ),
                        ],
                      ))
                ],
              )),
        ),
 
      ),
    );
  }
}
