import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CrmContactPage extends HookConsumerWidget {
  final int companyId;
  const CrmContactPage({super.key, required this.companyId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('客户联系人列表页面');
  }
}
