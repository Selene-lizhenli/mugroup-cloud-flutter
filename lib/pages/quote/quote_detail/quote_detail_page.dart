import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/baseInfo/base_info_section.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_by_time.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/quote_detail_actions.dart';
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
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度
    final colorScheme = Theme.of(context).colorScheme;
    useEffect(() {
      if (id > 0) {
        Future.microtask(() {
          quoteDetailNotifier.fetchQuoteDetail(id);
        });
      }

      return () {};
    }, [id]);

    if (quoteDetailState.productViewMode == ProductViewMode.supplier) {
      return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              '带客详情',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.transparent,
            actions: [
              QuoteDetailAppBarActions(id: id),
            ],
          ),
          body: NotificationListener<ScrollNotification>(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, // 起点：右上角
                        end: Alignment.bottomCenter, // 终点：左下角
                        colors: [
                          Color.lerp(
                            colorScheme.primary,
                            colorScheme.surface,
                            0.75,
                          )!,
                          colorScheme.surfaceTint,
                          colorScheme.surfaceTint,
                          colorScheme.surfaceTint,
                        ],
                        stops: const [0.0, 0.29, 0.32, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  left: 0,
                  right: 0,
                  top: paddingTop + appbarHeight,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            BaseInfoSectionByTime(
                              item: quoteDetailState.baseInfo,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                        ProductSectionByTime(quoteId: id),
                        const SizedBox(height: 20),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('带客详情'),
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        actions: [
          QuoteDetailAppBarActions(id: id),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    BaseInfoSection(
                      item: quoteDetailState.baseInfo,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
                ProductSection(quoteId: id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
