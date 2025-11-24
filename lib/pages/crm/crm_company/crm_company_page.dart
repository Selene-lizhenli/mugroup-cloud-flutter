import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/crm/views/company_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyPage extends HookConsumerWidget {
  const CrmCompanyPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('客户列表'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CompanyView(),
          ),
        ],
      ),
    );
  }
}
