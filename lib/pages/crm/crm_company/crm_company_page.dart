import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()

class CrmCompanyPage extends HookConsumerWidget {
  const CrmCompanyPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: AppBar(
      title: const Text('客户列表'),
    ));
  }
}
