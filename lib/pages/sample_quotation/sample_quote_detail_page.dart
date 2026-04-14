import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/sample_quotation/providers/provider.dart';
import 'package:cloud/pages/sample_quotation/widgets/basic_info_tab.dart';
import 'package:cloud/pages/sample_quotation/widgets/share_drawer.dart';
import 'package:cloud/pages/sample_quotation/widgets/station_samples_tab.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SampleQuoteDetailPage extends HookConsumerWidget {
  const SampleQuoteDetailPage({
    super.key,
    this.item,
    this.id, // 接收传入的ID
  });

  final QuotationList? item;
  final int? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final tabController = useTabController(initialLength: 2);

    final notifier = ref.read(sampleQuotationProvider.notifier);
    final state = ref.watch(sampleQuotationProvider);
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度
    final dynamicTemplates = state.dynamicTemplates;
    final permissions = ref.watch(userProvider).permissions ?? const <String>[];

    // 当路由只传 `id`（如从 `cart_page.dart` 跳转）时，`item` 可能为 null；
    // 当路由只传 `item`（如从列表页跳转）时，`id` 可能为 null，因此需要兜底取两者。
    final effectiveId = id ?? item?.id;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (effectiveId != null) {
          notifier.loadDetail(params: {"id": effectiveId});
        }

        // 仅当路由显式传了 `id` 时才加载 baseDetail（保持原有行为）。
        if (id != null) {
          notifier.loadBaseDetail(params: {"id": id});
        }
      });
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {});
    }, [effectiveId, id]);

    final data = id != null ? state.baseInfo : item;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('报价单'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/icons/share.png",
              width: 19,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
            padding: EdgeInsets.zero,
            onPressed: () => showQuotationDownloadSheet(
              context: context,
              item: data!,
              dynamicTemplates: dynamicTemplates,
              permissions: permissions,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Stack(clipBehavior: Clip.none, children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Image.asset(
            'assets/photo/quote_back_pink.png',
            fit: BoxFit.cover,
            alignment: Alignment.topRight,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: paddingTop + appbarHeight,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TabBar(
                  controller: tabController,
                  tabs: [
                    const Tab(text: '基本信息'),
                    Tab(text: '样品明细 (${state.productsList.length})'),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BasicInfoTab(item: data),
                      const StationSamplesTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
