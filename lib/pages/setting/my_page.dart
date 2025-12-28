import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/dashboard/widgets/home_user_header.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_charts/flutter_charts.dart'; // 导入flutter_charts
import 'package:flutter/material.dart';
// import 'package:flutter_charts/flutter_charts.dart'; // 引入折线图包
import 'package:fl_chart/fl_chart.dart'; // 使用 fl_chart

// @RoutePage()
// class SettingPage extends HookConsumerWidget {
//   const SettingPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider).user;
//     final cloud = ref.watch(coreProvider).value!;
//     final cart = ref.read(cartProvider.notifier);
//     final tenant = cloud.currentTenant;
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('设置应用'),
//         backgroundColor: colorScheme.surface,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: () {
//               // 完成按钮的操作
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: ListView(children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Column(
//               children: [
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [SectionTitle(title: '用户信息')],
//                 ),
//                 // Container(
//                 //   height: 100,
//                 //   child: Row(
//                 //     children: [HomeUserHeader()],
//                 //   ),
//                 // ),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 // 我的应用部分
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [SectionTitle(title: '数据看板')],
//                 ),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     childAspectRatio: 1.5,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: 4,
//                   itemBuilder: (context, index) {
//                     return ServiceTile(index: index);
//                   },
//                 ),
//                 const Divider(),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [SectionTitle(title: '集团资讯')],
//                 ),
//                 const NewsBoard(),
//                 const Divider(),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [SectionTitle(title: '汇率波动')],
//                 ),
//                 const LineChartDemo(),
//               ],
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(),
      ),
    );
  }
}

class AppTile extends StatelessWidget {
  final int index;

  const AppTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.apps,
          color: Colors.teal,
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final int index;

  const ServiceTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.help_outline,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class VacationTile extends StatelessWidget {
  final int index;

  const VacationTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.beach_access,
          color: Colors.orange,
        ),
      ),
    );
  }
}
