import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/inspection.dart';
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
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
                        children: const [
                          TextSpan(
                            text: ' 任务标题',
                            style: TextStyle(color: labelColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
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
                      style: const TextStyle(fontSize: 14, color: labelColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -1),
                blurRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting.value
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          isSubmitting.value = true;
                          try {
                            await storeInspection(
                                {'name': titleController.text.trim()});

                            if (context.mounted) {
                              EasyLoading.showSuccess('创建成功');
                              Navigator.pop(context, true);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              EasyLoading.showError('创建失败');
                            }
                          } finally {
                            if (context.mounted) {
                              isSubmitting.value = false;
                            }
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: primaryColor.withOpacity(0.6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: MuProgressIndicator(
                          barWidth: 4,
                        ),
                      )
                    : const Text(
                        '创建验货任务',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
