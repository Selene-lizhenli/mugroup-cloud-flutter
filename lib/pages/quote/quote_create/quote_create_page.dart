// import 'dart:async';
// import 'dart:convert';
// import 'package:auto_route/auto_route.dart';
// import 'package:cloud/pages/quote/quote_create/widgets/drop_down_with_search.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// @RoutePage()
// class QuoteCreatePage extends StatefulWidget {
//   const QuoteCreatePage({super.key});

//   @override
//   State<QuoteCreatePage> createState() => _CreateQuotePageState();
// }

// class _CreateQuotePageState extends State<QuoteCreatePage>
//     with AutomaticKeepAliveClientMixin {
//   final PageController _pageController = PageController();
//   int _currentStep = 0;

//   // --- 状态存储 ---
//   String? selectedCustomer;
//   List<String> selectedProducts = [];
//   List<String> involvedSuppliers = [];

//   bool isSavingDraft = false;

//   // --- SharedPreferences key ---
//   final String _draftKey = 'quote_draft';

//   @override
//   void initState() {
//     super.initState();
//     _loadDraft(); // 页面初始化加载草稿
//   }

//   // --- 加载草稿 ---
//   Future<void> _loadDraft() async {
//     final prefs = await SharedPreferences.getInstance();
//     final draftJson = prefs.getString(_draftKey);
//     if (draftJson != null) {
//       final Map<String, dynamic> data = jsonDecode(draftJson);
//       setState(() {
//         selectedCustomer = data['customer'];
//         selectedProducts = List<String>.from(data['products'] ?? <String>[]);
//         involvedSuppliers = List<String>.from(data['suppliers'] ?? <String>[]);
//       });
//     }
//   }

//   // --- 保存草稿 ---
//   Future<void> _saveDraft() async {
//     setState(() => isSavingDraft = true);
//     final prefs = await SharedPreferences.getInstance();
//     final draftData = jsonEncode({
//       'customer': selectedCustomer,
//       'products': selectedProducts,
//       'suppliers': involvedSuppliers,
//     });
//     await prefs.setString(_draftKey, draftData);
//     setState(() => isSavingDraft = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('草稿已保存')),
//     );
//   }

//   // --- 下一步 ---
//   void _nextStep() {
//     if (_currentStep < 2) {
//       setState(() => _currentStep++);
//       _pageController.animateToPage(
//         _currentStep,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//     } else {
//       _completeCreation();
//     }
//   }

//   // --- 上一步 ---
//   void _previousStep() {
//     if (_currentStep > 0) {
//       setState(() => _currentStep--);
//       _pageController.animateToPage(
//         _currentStep,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//     }
//   }

//   // --- 完成创建 ---
//   void _completeCreation() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('创建完成，正在跳转...')),
//     );
//     // 删除草稿
//     SharedPreferences.getInstance().then((prefs) {
//       prefs.remove(_draftKey);
//     });

//     // 模拟 3 秒后跳转
//     Timer(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (_) => QuoteDetailPage(quoteId: 123),
//         ),
//       );
//     });
//   }

//   Widget _buildStepContent() {
//     switch (_currentStep) {
//       case 0:
//         return _buildCustomerStep();
//       case 1:
//         return _buildProductStep();
//       case 2:
//         return _buildReviewStep();
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildCustomerStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('选择客户或新建客户', style: TextStyle(fontSize: 18)),
//         const SizedBox(height: 16),
//         CustomerBottomSheet(
//           customers: ['客户A', '客户B', '客户C'],
//           selectedCustomer: selectedCustomer,
//           onChanged: (val) => setState(() => selectedCustomer = val),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             // TODO:  跳转到创建页面，创建成功后返回到当前页面
//           },
//           child: const Text('新建客户'),
//         ),
//       ],
//     );
//   }

//   Widget _buildProductStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('导入产品', style: TextStyle(fontSize: 18)),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: () {
//             setState(
//                 () => selectedProducts.add('产品${selectedProducts.length + 1}'));
//           },
//           child: const Text('从列表导入产品'),
//         ),
//         const SizedBox(height: 16),
//         const Text('已导入产品:'),
//         ...selectedProducts.map((p) => Text(p)).toList(),
//         const SizedBox(height: 16),
//         const Text('涉及供应商:'),
//         ...involvedSuppliers.map((s) => Text(s)).toList(),
//         ElevatedButton(
//           onPressed: () {
//             setState(() =>
//                 involvedSuppliers.add('供应商${involvedSuppliers.length + 1}'));
//           },
//           child: const Text('添加供应商'),
//         ),
//       ],
//     );
//   }

//   Widget _buildReviewStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('创建完成', style: TextStyle(fontSize: 18)),
//         const SizedBox(height: 16),
//         Text('客户: ${selectedCustomer ?? '-'}'),
//         Text('产品数量: ${selectedProducts.length}'),
//         Text('供应商数量: ${involvedSuppliers.length}'),
//         const SizedBox(height: 16),
//         const Text('3s 后自动跳转到报价单详情页面'),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final colorScheme = Theme.of(context).colorScheme;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('创建报价单'),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//       ),

// // body: SafeArea(
// //   child: Padding(
// //     padding: const EdgeInsets.all(16.0),
// //     child: Column(
// //       children: [
// //         // Expanded(
// //         //   child: PageView(
// //         //     controller: _pageController,
// //         //     physics: const NeverScrollableScrollPhysics(),
// //         //     children: List.generate(3, (_) => _buildStepContent()),
// //         //   ),
// //         // ),
// //         // Row(
// //         //   children: [
// //         //     if (_currentStep > 0)
// //         //       OutlinedButton(
// //         //         onPressed: _previousStep,
// //         //         child: const Text('上一步'),
// //         //       ),
// //         //     const Spacer(),
// //         //     ElevatedButton(
// //         //       onPressed: _nextStep,
// //         //       child: Text(_currentStep == 2 ? '完成' : '下一步'),
// //         //     ),
// //         //     const SizedBox(width: 8),
// //         //     if (_currentStep < 2)
// //         //       OutlinedButton(
// //         //         onPressed: _saveDraft,
// //         //         child: isSavingDraft
// //         //             ? const SizedBox(
// //         //                 width: 16,
// //         //                 height: 16,
// //         //                 child: CircularProgressIndicator(strokeWidth: 2),
// //         //               )
// //         //             : const Text('保存草稿'),
// //         //       ),
// //         //   ],
// //         // ),
// //       ],
// //     ),
// //   ),
// // ),
// //   );
// // }

// // @override
// // bool get wantKeepAlive => true;
// // }

// class QuoteDetailPage extends StatelessWidget {
//   final int quoteId;
//   const QuoteDetailPage({super.key, required this.quoteId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('报价单详情')),
//       body: Center(child: Text('报价单ID: $quoteId')),
//     );
//   }
// }

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteCreatePage extends HookConsumerWidget {
  const QuoteCreatePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text("报价单创建"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/coming.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            Text(
              '敬请期待',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
