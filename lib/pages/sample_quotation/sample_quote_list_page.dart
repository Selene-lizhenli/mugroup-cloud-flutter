import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/sample_quotation/providers/provider.dart';
import 'package:cloud/pages/sample_quotation/widgets/quotation_card.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/pages/widgets/search_bar.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SampleQuoteListPage extends HookConsumerWidget {
  const SampleQuoteListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final searchController = useTextEditingController();
    final notifier = ref.read(sampleQuotationProvider.notifier);
    final state = ref.watch(sampleQuotationProvider);
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度
    final permissions = ref.watch(userProvider).permissions ?? const <String>[];
    final dynamicTemplates = state.dynamicTemplates;
    final themeType = ref.watch(appThemeProvider);
    final l10n = context.l10n;
    final themeImage = themeType == ThemeType.pink
        ? 'assets/photo/quote_back_pink.png'
        : 'assets/photo/quote_back_blue.png';

    // final refreshController = useMemoized(
    //   () => EasyRefreshController(
    //     controlFinishRefresh: true,
    //     controlFinishLoad: true,
    //   ),
    // );

    // useEffect(() {
    //   return () =>
    //       {refreshController.dispose(), Notifier.cleanSearchKeyWord};
    // }, const []);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.load();
        notifier.loadExportTemplate();
      });
      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            // Notifier.cleanStationInquiriesMessages();
          });
    }, const []);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(clipBehavior: Clip.none, children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Image.asset(
            themeImage,
            fit: BoxFit.cover,
            alignment: Alignment.topRight,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: paddingTop + 10,
          bottom: 0,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.router.maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color.fromARGB(255, 85, 10, 142),
                      size: 21,
                    ),
                  ),
                  Expanded(
                    child: MuSearchBar(
                      controller: searchController,
                      hintText: l10n.quoteSearchHint,
                      buttonText: l10n.search,
                      left: 0,
                      right: 14,
                      onSearch: (search) {
                        final keyword = search ?? searchController.text;
                        notifier.setSearch(keyword);
                        notifier.load(params: {'search': keyword});
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: state.isLoading
                    ? Center(
                        child: MuProgressIndicator(
                          showText: true,
                          text: l10n.loading,
                        ),
                      )
                    : MuListView(
                        state: state,
                        list: state.list,
                        onRefresh: () async {
                          await notifier.load();
                        },
                        onLoadMore: () async {
                          await notifier.load(refresh: false);
                        },
                        refreshOnStart: false,
                        itemBuilder: (context, item) => SampleQuotationCard(
                          item: item,
                          dynamicTemplates: dynamicTemplates,
                          permissions: permissions,
                          onTap: () => { 
                            context.router
                                .push(SampleQuoteDetailRoute(item: item))
                          },
                        ),
                        hPadding: 16,
                      ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
