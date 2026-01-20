import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteProductNewAddPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductNewAddPage({super.key, this.quoteId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
