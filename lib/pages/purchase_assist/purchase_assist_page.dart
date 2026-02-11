import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/core.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/widgets/assist_product_card.dart';
import 'package:cloud/pages/purchase_assist/widgets/filter_content.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/pages/widgets/tag_list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:cloud/services/media.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

/// 打开相册选择图片并上传，加入搜索图片列表（供 SearchArea 与 _UploadedImagesRow 共用）
Future<void> _openGalleryForPurchaseAssist(
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

    useEffect(() {
      if (state.searchKeyword != searchController.text) {
        searchController.text = state.searchKeyword;
      }
      return null;
    }, [state.searchKeyword]);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('比价助手'),
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.listCheck,
                size: 20,
                color: Colors.red,
              ),
              tooltip: '任务管理',
              onPressed: () {
                context.router.push(const BatchImageSearchResultRoute());
              },
            ),
          ],
        ),
        body: Stack(children: [
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
                    colorScheme.surface,
                  ],
                  stops: null,
                ),
              ),
            ),
          ),
          // 最底层：渐变铺满整页
          Positioned.fill(
            left: 0,
            right: 0,
            top: state.hasSearched ? paddingTop - 15 + kToolbarHeight : 0,
            bottom: 0,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: _SearchResultBody(),
                )),
          ),
        ]));
  }
}

class SearchArea extends HookConsumerWidget {
  const SearchArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 白色圆角输入框 + 盒外阴影，右侧相机 + 加号
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final currentMedia = ref.read(purchaseAssistProvider).searchMedia;

    /// 打开相册，选择照片后上传并加入搜索图片列表
    Future<void> openGallery() async {
      await _openGalleryForPurchaseAssist(context, ref);
    }

    /// 打开相机，拍一张后把文件路径加入搜索图片列表
    Future<void> openCamera() async {
      final entity = await CameraPicker.pickFromCamera(context,
          pickerConfig: const CameraPickerConfig(enableRecording: false));

      if (entity == null || !context.mounted) return;

      final file = await entity.file;
      if (file == null || !context.mounted) return;
      final temporaryMedia = await upload(file: file);
      notifier.addSearchMedia(temporaryMedia);

      if (context.mounted && currentMedia != null) {
        await notifier.loadProducts(params: {"media_id": temporaryMedia.id});
      }
    }

    Widget getTnputArea() {
      return Expanded(
        child: TextField(
          decoration: const InputDecoration(
            hintText: '请输入关键字...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          onChanged: notifier.setSearchKeyword,
          onSubmitted: (_) => notifier.loadProducts(),
        ),
      );
    }

    Widget getFilterBtn() {
      return IconButton(
        icon: Icon(Icons.filter_alt_outlined,
            color: state.hasSearched == true
                ? colorScheme.primary
                : Colors.black87),
        tooltip: '筛选',
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
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              builder: (context, scrollController) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const FilterContent(),
              ),
            ),
          );
        },
      );
    }

    Widget getPicBtn() {
      return IconButton(
        icon: const Icon(Icons.add_outlined, color: Colors.black87, size: 27),
        tooltip: '从相册选择',
        onPressed: () => openGallery(),
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        constraints: const BoxConstraints(),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    Widget getcaremaBtn() {
      return IconButton(
        icon: const Icon(Icons.camera_alt_outlined,
            color: Colors.black87, size: 27),
        tooltip: '拍照',
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        constraints: const BoxConstraints(),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => openCamera(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (state.hasSearched == false) ...[
            Row(children: [getTnputArea()]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getFilterBtn(),
                const Spacer(),
                getcaremaBtn(),
                getPicBtn(),
              ],
            )
          ] else ...[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getTnputArea(),
                  getFilterBtn(),
                  getcaremaBtn(),
                  getPicBtn(),
                ]),
          ]
        ],
      ),
    );
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

    useEffect(() {
      if (state.searchKeyword != searchController.text) {
        searchController.text = state.searchKeyword;
      }
      return null;
    }, [state.searchKeyword]);

    onTap(item) async {
      if (!context.mounted) return;
      if (state.selectedPlatform == searchPlatform[0].value) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 平台标签：横向滑动
        MuTagList(
          items: searchPlatform,
          selectedValue: state.selectedPlatform,
          onSelected: (value) => {
            notifier.setSelectedPlatform(value),
            notifier.loadProducts(refresh: true, params: {"platform": value})
          },
          spacing: 8,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          fontSize: 12,
          chipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),

        // 顶部收缩的搜索框
        const SearchArea(),
        const Divider(height: 1),

        // 已上传的搜索图片展示
        if (state.searchMediaList.isNotEmpty) _UploadedImagesRow(),

        state.hasSearched
            ? Expanded(
                child: MuListView<PurchaseAssistSearchProduct>(
                  state: state,
                  list: state.productList,
                  onRefresh: () => notifier.loadProducts(refresh: true),
                  onLoadMore: () => notifier.loadProducts(refresh: false),
                  refreshOnStart: false,
                  isAdapColumn: true,
                  itemBuilder: (context, item) => AssistProductCard(
                    sample: item,
                    onTap: () => onTap(item),
                  ),
                ),
              )
            : const SizedBox(height: 20),
      ],
    );
  }
}

/// 已上传的搜索图片横向列表（首项为加号，点击执行 openGallery）
class _UploadedImagesRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final list = state.searchMediaList;
    if (list.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withOpacity(0.3),
      child: SizedBox(
        height: 72,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: list.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            // 第一项：加号，点击打开相册
            if (index == list.length) {
              return GestureDetector(
                onTap: () => _openGalleryForPurchaseAssist(context, ref),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.5),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withOpacity(0.5),
                  ),
                ),
              );
            }
            final media = list[index];
            final imageUrl = media.thumbUrl ?? media.url;
            final isSelected = state.searchMedia?.id == media.id;
            return GestureDetector(
              onTap: () {
                notifier.setSearchMedia(media);
                notifier.loadProducts(params: {"media_id": media.id});
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: GestureDetector(
                      onTap: () => notifier.removeSearchMedia(index - 1),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: const Icon(Icons.close,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
