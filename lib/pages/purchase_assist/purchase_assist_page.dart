import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/core.dart';
import 'package:cloud/constants/search_platform_l10n_helper.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/widgets/assist_product_card.dart';
import 'package:cloud/pages/purchase_assist/widgets/filter_content.dart';
import 'package:cloud/pages/purchase_assist/widgets/search_area.dart';
import 'package:cloud/pages/purchase_assist/widgets/upload_images_row.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/theme_icon.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/pages/widgets/tag_list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:cloud/services/media.dart';
import 'package:url_launcher/url_launcher.dart';

/// 打开相册选择图片并上传，加入搜索图片列表（供 SearchArea 与 _UploadedImagesRow 共用）
Future<void> openGalleryForPurchaseAssist(
    BuildContext context, WidgetRef ref) async {
  final notifier = ref.read(purchaseAssistProvider.notifier);
  final List<AssetEntity>? result = await AssetPicker.pickAssets(
    context,
    pickerConfig: const AssetPickerConfig(
      maxAssets: 10,
      requestType: RequestType.image,
    ),
  );
  if (result == null || result.isEmpty || !context.mounted) return;
  for (var entity in result) {
    final file = await entity.file;
    if (file == null || !context.mounted) continue;
    final temporaryMedia = await upload(file: file);
    if (!context.mounted) return;
    notifier.addSearchMedia(temporaryMedia);
  }
  final currentMedia = ref.read(purchaseAssistProvider).searchMedia;
  if (context.mounted && currentMedia != null) {
    await notifier.loadProducts(params: {"media_id": currentMedia.id});
  }
}

void onProductTap(
  dynamic item,
  String selectedPlatform,
  BuildContext context,
) async {
  if (!context.mounted) return;
  if (selectedPlatform == searchPlatform[0].value) {
    context.router.push(ShowroomSampleDetailRoute(id: item.id!));
  } else {
    final url = item.productUrl;
    if (url != null && url.isNotEmpty) {
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}

@RoutePage()
class PurchaseAssistPage extends HookConsumerWidget {
  const PurchaseAssistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final searchController =
        useTextEditingController(text: state.searchKeyword);
    final colorScheme = Theme.of(context).colorScheme;
    // 渐变可调参数：角度（度，0=上→下，90=左→右）、颜色分界位置（0~1）
    const double gradientAngleDegrees = 0;
    final headerColor = colorScheme.primary.withOpacity(0.2); // 渐变颜色
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final l10n = context.l10n;
    useEffect(() {
      if (state.searchKeyword != searchController.text) {
        searchController.text = state.searchKeyword;
      }
      return null;
    }, [state.searchKeyword]);

    useEffect(() {
      // 首次进入时加载当前询盘的样品明细
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.loadTaskList();
      });
      return null;
    }, const []);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(l10n.featurePurchaseAssist),
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    FontAwesomeIcons.listCheck,
                    size: 20,
                    color: Color.fromARGB(255, 119, 78, 47),
                  ),
                  if (state.taskList.isNotEmpty)
                    Positioned(
                      left: -6,
                      top: -10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          state.taskList.length > 99
                              ? '99+'
                              : '${state.taskList.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            height: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              tooltip: '任务管理',
              onPressed: () {
                context.router.push(const BatchImageSearchResultRoute());
              },
            ),
          ],
        ),
        body: Stack(children: [
          // 最底层：渐变铺满整页
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: const GradientRotation(
                    gradientAngleDegrees * math.pi / 180,
                  ),
                  colors: [
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.7,
                    )!,
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.85,
                    )!,
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.92,
                    )!,
                    Color.lerp(
                      colorScheme.surface,
                      colorScheme.surfaceTint,
                      0.6,
                    )!,
                    Color.lerp(
                      colorScheme.surface,
                      colorScheme.surfaceTint,
                      0.9,
                    )!,
                    colorScheme.surfaceTint,
                    colorScheme.surfaceTint,
                    colorScheme.surfaceTint,
                  ],
                  stops: const [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // 中间层：背景图
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/element/benbenshopping.png',
              fit: BoxFit.contain,
              width: 200,
            ),
          ),
          Positioned.fill(
            left: 0,
            right: 0,
            top: paddingTop + appbarHeight,
            bottom: 0,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: _SearchResultBody(),
            ),
          ),
        ]));
  }
}

/// 已搜索时：顶部搜索栏 + 下方商品列表
class _SearchResultBody extends HookConsumerWidget {
  const _SearchResultBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final searchController =
        useTextEditingController(text: state.searchKeyword);
    final colorScheme = Theme.of(context).colorScheme;
    final selectedPlatform = state.selectedPlatform;
    final l10n = context.l10n;

    const List<SearchPlatformItem> amazonCountries = [
      SearchPlatformItem(label: '加拿大', value: 'CA'),
      SearchPlatformItem(label: '墨西哥', value: 'MX'),
    ];

    useEffect(() {
      if (state.searchKeyword != searchController.text) {
        searchController.text = state.searchKeyword;
      }
      return null;
    }, [state.searchKeyword]);

    Widget getFilterBtn() {
      final hasActiveFilters = (state.sortOrder != 'default' &&
              state.sortOrder != null &&
              state.sortOrder!.isNotEmpty) ||
          (state.priceMin != null && state.priceMin!.isNotEmpty) ||
          (state.priceMax != null && state.priceMax!.isNotEmpty);
      return IconButton(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const MuThemeIcon(
              iconType: 'filter',
              iconSize: 24,
            ),
            if (hasActiveFilters)
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
          ],
        ),
        tooltip: l10n.filter,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        constraints: const BoxConstraints(),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            builder: (sheetContext) {
              final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(sheetContext).pop(),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight:
                              MediaQuery.sizeOf(sheetContext).height * 0.85,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(sheetContext).colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: const FilterContent(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 平台标签与筛选同一行，超出时仅 MuTagList 横向滚动
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: MuTagList(
                items: localizedSearchPlatform(l10n),
                selectedValue: selectedPlatform,
                onSelected: (value) {
                  if (state.searchMediaList.isEmpty &&
                      value == 'alibabaglobal') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${l10n.searchPlatformAlibabaglobal} ${l10n.notSupportKeywordSearch}')),
                    );
                    return;
                  }
                  if (state.searchMediaList.isEmpty && value == 'amazon') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${l10n.searchPlatformAmazon} ${l10n.notSupportKeywordSearch}')),
                    );
                    return;
                  }
                  notifier.setSelectedPlatform(value);
                  notifier
                      .loadProducts(refresh: true, params: {"platform": value});
                },
                backgroundColor: colorScheme.surface.withOpacity(0.3),
                spacing: 8,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                fontSize: 12,
                chipPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
            getFilterBtn(),
            const SizedBox(width: 4),
          ],
        ),
        if (selectedPlatform == 'amazon')
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
            child: Row(
              children: [
                Text("国家站点：",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: MuTagList(
                    items: amazonCountries,
                    selectedValue: state.selectedCountry ?? 'CA',
                    onSelected: (countryValue) {
                      notifier.setSelectedCountry(countryValue);
                      notifier.loadProducts(
                        refresh: true,
                        params: {
                          "platform": 'amazon',
                          "country": countryValue,
                        },
                      );
                    },
                    fontSize: 11,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                    chipPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ],
            ),
          ),
        // 顶部收缩的搜索框
        const SearchArea(),

        // 已上传的搜索图片展示
        if (state.searchMediaList.isNotEmpty) ...[
          const SizedBox(height: 5),
          const UploadedImagesRow(),
        ],
        if (state.hasSearched) ...[
          if (state.isLoading)
            const Expanded(
              child: Center(
                child: MuProgressIndicator(),
              ),
            )
          else ...[
            const SizedBox(height: 8),
            Expanded(
              child: MuListView<PurchaseAssistSearchProduct>(
                state: state,
                list: state.productList,
                onRefresh: () => notifier.loadProducts(refresh: true),
                onLoadMore: () => notifier.loadProducts(refresh: false),
                refreshOnStart: false,
                isAdapColumn: true,
                itemBuilder: (context, item) => AssistProductCard(
                  sample: item,
                  platformType: selectedPlatform,
                  onTap: () => onProductTap(item, selectedPlatform, context),
                ),
              ),
            ),
          ]
        ] else ...[
          const SizedBox(height: 40)
        ],
      ],
    );
  }
}
