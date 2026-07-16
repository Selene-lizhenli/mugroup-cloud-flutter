import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/export/export_pick_drawer.dart';
import 'package:cloud/pages/sample_quotation/widgets/share_drawer.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuoteDetailAppBarActions extends ConsumerWidget {
  final int id;

  const QuoteDetailAppBarActions({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteDetailState = ref.watch(quoteDetailProvider);
    final quoteDetailNotifier = ref.read(quoteDetailProvider.notifier);
    final permissions = ref.watch(userProvider).permissions ?? const <String>[];

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              final quoteId = quoteDetailState.baseInfo?.id ?? id;
              showDialog(
                context: context,
                builder: (_) => ExportShareSheet(
                  quoteId: quoteId,
                  channel: ExportChannel.wework,
                ),
              );
            },
            icon: Image.asset(
              "assets/icons/share.png",
              width: 18,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
          ),
          const SizedBox(width: 13),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            onPressed: () => showQuotationDownloadSheet(
              context: context,
              item: quoteDetailState.baseInfo!,
              dynamicTemplates: quoteDetailState.dynamicTemplates,
              permissions: permissions,
              from: 'market',
            ),
            icon: Image.asset(
              "assets/icons/download.png",
              width: 18,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
          ),
          const SizedBox(width: 13),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
            ),
            onPressed: () {
              final quoteId = quoteDetailState.baseInfo?.id ?? id;
              if (quoteId > 0) {
                quoteDetailNotifier.fetchQuoteDetail(quoteId);
              }
            },
            icon: Image.asset(
              "assets/icons/refresh.png",
              width: 16,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
          ),
          const SizedBox(width: 13),
          InkWell(
            onTap: quoteDetailNotifier.toggleProductViewMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/exchange.png',
                  width: 13,
                  height: 13,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 2),
                Text(
                  '切换视角',
                  style: TextStyle(
                    fontSize: 6,
                    height: 1,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
