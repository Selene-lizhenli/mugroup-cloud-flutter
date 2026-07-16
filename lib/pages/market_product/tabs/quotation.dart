import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MarketProductQuotationPage extends HookConsumerWidget {
  const MarketProductQuotationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('报价单');
  }
}
