import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InspectionDetailPage extends HookConsumerWidget {
  final int id;
  const InspectionDetailPage({super.key, required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('验货详情');
  }
}
