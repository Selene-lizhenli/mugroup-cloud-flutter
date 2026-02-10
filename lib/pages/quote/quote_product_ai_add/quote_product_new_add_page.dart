import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_page.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_adaptive_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_ai_add_floor_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_ai_add_notepad_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/quote_product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteProductNewAddPage extends HookConsumerWidget {
  final int initialTabIndex;
  final int? quoteId;
  final String? supplierId;

  // 1. 新增：是否为嵌入模式
  final bool isEmbedded;

  const QuoteProductNewAddPage({
    super.key,
    this.initialTabIndex = 1,
    this.quoteId,
    this.supplierId,
    this.isEmbedded = false, // 默认为 false，即独立页面
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final tabController =
        useTabController(initialLength: 3, initialIndex: initialTabIndex);

    final tabBar = TabBar(
      controller: tabController,
      labelColor: colorScheme.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Tab(text: "手动录入"),
        Tab(text: "白板识别"),
        Tab(text: "记录本识别"),
      ],
    );

    final tabBarView = TabBarView(
      controller: tabController,
      physics: isEmbedded ? const NeverScrollableScrollPhysics() : null,
      children: [
        KeepAliveWrapper(
          child: QuoteProductAddAdaptivePage(
            initialMode: 0,
            quoteId: quoteId,
            supplierId: supplierId,
          ),
        ),
        KeepAliveWrapper(
          child: QuoteProductAiAddFloorPage(
            quoteId: quoteId,
            supplierId: supplierId,
          ),
        ),
        KeepAliveWrapper(
          child: QuoteProductAiAddNotepadPage(
            quoteId: quoteId,
            supplierId: supplierId,
          ),
        ),
      ],
    );

    if (isEmbedded) {
      return Column(
        children: [
          Container(
            color: Colors.white,
            child: tabBar,
          ),
          Expanded(child: tabBarView),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('添加报价产品'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          bottom: tabBar,
        ),
        body: PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              // 当用户通过侧滑手势或系统返回键退出时，也发送刷新信号
              ref
                  .read(quotePageRefreshTrigger.notifier)
                  .update((state) => state + 1);

              ref
                  .read(quotePageProductRefresh.notifier)
                  .update((state) => state + 1);
            }
          },
          child: tabBarView,
        ),
      );
    }
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
