import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart'; 
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/export/export_pick_drawer.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/quote_detail_body.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
  

@RoutePage()
class QuoteDetailPage extends HookConsumerWidget { 
  final int id;

  const QuoteDetailPage({
    super.key, 
    @pathParam required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {  

    final quoteDetailState = ref.watch(quoteDetailProvider);
    final quoteDetailNotifier = ref.read(quoteDetailProvider.notifier);
 
 
    useEffect(() {
      if (id > 0) {
        Future.microtask(() {
          quoteDetailNotifier.fetchQuoteDetail(id);
        });
      }

      return () {
        // quoteDetailNotifier.clear();
      };
    }, [id]);
 

    return Scaffold(
      appBar: AppBar(
        title: const Text('报价单详情'),
        backgroundColor: Theme.of(context).colorScheme.surfaceTint, 
        actions: [
          IconButton(
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
            icon: const Icon(Icons.share_outlined, size: 21),
          ),
          IconButton(
            onPressed: () { 
              final quoteId = quoteDetailState.baseInfo?.id ?? id;
              if (quoteId > 0) {
                quoteDetailNotifier.fetchQuoteDetail(quoteId);
              }
            },
            icon: const Icon(Icons.refresh, size: 20),
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: QuoteDetailBody(
                    item: quoteDetailState.baseInfo,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
