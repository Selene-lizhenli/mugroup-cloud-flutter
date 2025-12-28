import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/pages/quote/quote_create/widgets/quote_base_info_step.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteCreatePage extends StatelessWidget {
  const QuoteCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增报价单'),
        backgroundColor: colorScheme.surface,
      ),
      body: const Column(
        children: [
          Expanded(child: QuoteBaseInfoStep()),
          QuoteCreateBottomBar(),
        ],
      ),
    );
  }
}

// class QuoteCreateStepView extends ConsumerWidget {
//   const QuoteCreateStepView({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(quoteCreateProvider);
//     switch (state.step) {
//       case QuoteCreateStep.baseInfo:
//         return const QuoteBaseInfoStep();
//       case QuoteCreateStep.products:
//         return const QuoteProductsPage();
//     }
//   }
// }

class _ReviewStep extends ConsumerWidget {
  const _ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteCreateProvider);
    return Center(
      child: Text('确认创建：${state.customer ?? '-'}'),
    );
  }
}

// class QuoteCreateBottomBar extends ConsumerWidget {
//   const QuoteCreateBottomBar({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(quoteCreateProvider);
//     final notifier = ref.read(quoteCreateProvider.notifier);
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             if (state.stepIndex > 0)
//               OutlinedButton(
//                 onPressed: notifier.previousStep,
//                 child: const Text('上一步'),
//               ),
//             const Spacer(),
//             if (state.step != QuoteCreateStep.review)
//               OutlinedButton(
//                 onPressed: () async {
//                   await notifier.saveDraft();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('草稿已保存')),
//                   );
//                 },
//                 child: state.savingDraft
//                     ? const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Text('保存草稿'),
//               ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: notifier.nextStep,
//               child: Text(
//                 state.step == QuoteCreateStep.review ? '完成' : '下一步',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class QuoteCreateBottomBar extends ConsumerWidget {
  const QuoteCreateBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final state = ref.watch(quoteCreateProvider);
    final notifier = ref.read(quoteCreateProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = state.savingDraft || state.submitting;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E6EB)),
          ),
        ),
        child: Row(
          children: [
            // ================= 草稿 =================
            // Expanded(
            //   child: OutlinedButton(
            //     onPressed: isLoading
            //         ? null
            //         : () async {
            //             await notifier.saveDraft();
            //             if (context.mounted) {
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(content: Text('草稿已保存')),
            //               );
            //             }
            //           },
            //     style: OutlinedButton.styleFrom(
            //       side: const BorderSide(color: Color(0xFFD0D5DD)),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: state.savingDraft
            //         ? const SizedBox(
            //             width: 18,
            //             height: 18,
            //             child: CircularProgressIndicator(strokeWidth: 2),
            //           )
            //         : const Text('草稿'),
            //   ),
            // ),

            const SizedBox(width: 12),

            // ================= 保存 =================
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        // await notifier.saveDraft();
                        if (context.mounted) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('保存成功')),
                          // );
                          final data = {
                            "sample_items": state.productList
                                .map((item) => {
                                      "sample_id": item.sample.id,
                                      "price": item.price,
                                      "qty": item.count
                                    })
                                .toList(),
                            "user_id": user?.id,
                            "curreny": state.currency,
                            "exchange": state.rate, //汇率
                            "contact_id": state.contact,
                            "commission_rate": state.addPercentage, //加点
                            "quote_at": state.quoteDate.toIso8601String()
                          };

                          // final res = await storeShowroomQuotation(data);
                          // if (res?.id != null && context.mounted) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('保存成功，正在跳转...')),
                          // );
                          // context.router.push(
                          //     QuoteDetailRoute(id: res!.id!, userId: 0));
                          context.router
                              .push(QuoteDetailRoute(id: 322, userId: 0));
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state.submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        '保存',
                        style: TextStyle(
                            fontSize: 16, color: colorScheme.onSecondary),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// @RoutePage()
// class QuoteCreatePage extends HookConsumerWidget {
//   const QuoteCreatePage({super.key});

//   static const String _draftKey = 'quote_draft';

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colorScheme = Theme.of(context).colorScheme;

//     /// -------------------------
//     /// 状态（Hook）
//     /// -------------------------
//     final pageController = usePageController();
//     final currentStep = useState<int>(0);

//     final selectedCustomer = useState<String?>(null);
//     final selectedProducts = useState<List<String>>([]);
//     final involvedSuppliers = useState<List<String>>([]);

//     final isSavingDraft = useState<bool>(false);

//     /// -------------------------
//     /// 初始化：加载草稿
//     /// -------------------------
//     useEffect(() {
//       Future<void> loadDraft() async {
//         final prefs = await SharedPreferences.getInstance();
//         final draftJson = prefs.getString(_draftKey);
//         if (draftJson != null) {
//           final data = jsonDecode(draftJson);
//           selectedCustomer.value = data['customer'];
//           selectedProducts.value = List<String>.from(data['products'] ?? []);
//           involvedSuppliers.value = List<String>.from(data['suppliers'] ?? []);
//         }
//       }

//       loadDraft();
//       return null;
//     }, []);

//     /// -------------------------
//     /// 行为函数
//     /// -------------------------
//     Future<void> saveDraft() async {
//       isSavingDraft.value = true;
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(
//         _draftKey,
//         jsonEncode({
//           'customer': selectedCustomer.value,
//           'products': selectedProducts.value,
//           'suppliers': involvedSuppliers.value,
//         }),
//       );
//       isSavingDraft.value = false;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('草稿已保存')),
//       );
//     }

//     void completeCreation() async {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('创建完成，正在跳转...')),
//       );

//       final prefs = await SharedPreferences.getInstance();
//       prefs.remove(_draftKey);

//       Timer(const Duration(seconds: 3), () {
//         // context.router.replace(
//         //   QuoteDetailRoute(quoteId: 123),
//         // );
//       });
//     }

//     void nextStep() {
//       if (currentStep.value < 2) {
//         currentStep.value++;
//         pageController.animateToPage(
//           currentStep.value,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.ease,
//         );
//       } else {
//         completeCreation();
//       }
//     }

//     void previousStep() {
//       if (currentStep.value > 0) {
//         currentStep.value--;
//         pageController.animateToPage(
//           currentStep.value,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.ease,
//         );
//       }
//     }

//     /// -------------------------
//     /// Step Widgets
//     /// -------------------------

//     Widget buildProductStep() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('导入产品', style: TextStyle(fontSize: 18)),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               selectedProducts.value = [
//                 ...selectedProducts.value,
//                 '产品${selectedProducts.value.length + 1}',
//               ];
//             },
//             child: const Text('从列表导入产品'),
//           ),
//           const SizedBox(height: 12),
//           ...selectedProducts.value.map(Text.new),
//           const SizedBox(height: 12),
//           ElevatedButton(
//             onPressed: () {
//               involvedSuppliers.value = [
//                 ...involvedSuppliers.value,
//                 '供应商${involvedSuppliers.value.length + 1}',
//               ];
//             },
//             child: const Text('添加供应商'),
//           ),
//         ],
//       );
//     }

//     Widget buildReviewStep() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('创建完成', style: TextStyle(fontSize: 18)),
//           const SizedBox(height: 16),
//           Text('客户：${selectedCustomer.value ?? '-'}'),
//           Text('产品数量：${selectedProducts.value.length}'),
//           Text('供应商数量：${involvedSuppliers.value.length}'),
//           const SizedBox(height: 16),
//           const Text('3 秒后自动跳转到报价单详情页'),
//         ],
//       );
//     }

//     /// -------------------------
//     /// UI
//     /// -------------------------
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text('创建报价单'), backgroundColor: colorScheme.surface),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: PageView(
//                 controller: pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   QuoteBaseInfoStep(
//                     selectedCustomer: selectedCustomer.value,
//                     onSelectCustomer: () {
//                       showModalBottomSheet(
//                         context: context,
//                         isScrollControlled: true,
//                         backgroundColor: Colors.transparent,
//                         builder: (_) => const SelectCustomerSheet(),
//                       );
//                     },
//                     onSelectContact: () {},
//                     onSelectLanguage: () {},
//                     onSelectCurrency: () {},
//                   ),
//                   buildProductStep(),
//                   buildReviewStep(),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 if (currentStep.value > 0)
//                   OutlinedButton(
//                     onPressed: previousStep,
//                     child: const Text('上一步'),
//                   ),
//                 const Spacer(),
//                 if (currentStep.value < 2)
//                   OutlinedButton(
//                     onPressed: saveDraft,
//                     child: isSavingDraft.value
//                         ? const SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Text('保存草稿'),
//                   ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: nextStep,
//                   child: Text(currentStep.value == 2 ? '完成' : '下一步'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }
