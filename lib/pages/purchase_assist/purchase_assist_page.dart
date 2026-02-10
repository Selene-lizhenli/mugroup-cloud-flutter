import 'dart:io';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/core.dart';
import 'package:cloud/constants/theme_color_config.dart';
import 'package:cloud/models/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/pages/widgets/tag_list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

@RoutePage()
class PurchaseAssistPage extends HookConsumerWidget {
  const PurchaseAssistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
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
            top: paddingTop + kToolbarHeight,
            bottom: 0,
            child: state.hasSearched
                ? _SearchResultBody(
                    state: state,
                    notifier: notifier,
                    searchController: searchController,
                  )
                : _BigSearchBody(notifier: notifier, state: state),
          ),
        ]));
  }
}

/// 未搜索时：中间大输入框（发消息样式 + 相机/相册），整体盒外阴影
class _BigSearchBody extends StatelessWidget {
  const _BigSearchBody({required this.notifier, required this.state});

  final PurchaseAssist notifier;
  final PurchaseAssistState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 平台标签：横向排列，超出可左右滑动
            TagList(
              items: searchPlatform,
              selectedValue: state.selectedPlatform,
              onSelected: notifier.setSelectedPlatform,
            ),
            const SizedBox(height: 8),
            const SearchArea(),
            if (state.searchImagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.searchImagePaths.map((path) {
                  return Chip(
                    label: Text(
                      path.split(Platform.pathSeparator).last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onDeleted: () {
                      notifier.setSearchImagePaths(
                        state.searchImagePaths.where((p) => p != path).toList(),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SearchArea extends HookConsumerWidget {
  const SearchArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 白色圆角输入框 + 盒外阴影，右侧相机 + 加号
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);

    /// 打开相册，选择照片后把文件路径加入搜索图片列表
    Future<void> openGallery() async {
      final result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 9,
          requestType: RequestType.image,
        ),
      );
      if (result == null || result.isEmpty || !context.mounted) return;
      final paths = <String>[];
      for (final e in result) {
        final file = await e.file;
        if (file != null) paths.add(file.path);
      }
      if (paths.isNotEmpty) {
        notifier.setSearchImagePaths([...state.searchImagePaths, ...paths]);
        // 图片选择成功后自动搜索
        await notifier.doSearch();
      }
    }

    /// 打开相机，拍一张后把文件路径加入搜索图片列表
    Future<void> openCamera() async {
      final entity = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: const CameraPickerConfig(enableRecording: false),
      );
      if (entity == null || !context.mounted) return;
      final file = await entity.file;
      if (file != null) {
        final path = file.path;
        notifier.setSearchImagePaths([...state.searchImagePaths, path]);
        // 拍照成功后自动搜索
        await notifier.doSearch();
      }
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '请输入关键字...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: notifier.setSearchKeyword,
                  onSubmitted: (_) => notifier.doSearch(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined,
                    color: Colors.black87),
                tooltip: '筛选',
                onPressed: () => openCamera(),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined,
                    color: Colors.black87, size: 28),
                tooltip: '拍照',
                onPressed: () => openCamera(),
              ),
              IconButton(
                icon: const Icon(Icons.add_photo_alternate_outlined,
                    color: Colors.black87, size: 25),
                tooltip: '从相册选择',
                onPressed: () => openGallery(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// 已搜索时：顶部搜索栏 + 下方商品列表
class _SearchResultBody extends StatelessWidget {
  const _SearchResultBody({
    required this.state,
    required this.notifier,
    required this.searchController,
  });

  final PurchaseAssistState state;
  final PurchaseAssist notifier;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 平台标签：横向滑动
        Material(
          color: theme.colorScheme.surface,
          child: TagList(
            items: searchPlatform,
            selectedValue: state.selectedPlatform,
            onSelected: notifier.setSelectedPlatform,
            spacing: 8,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            fontSize: 12,
            chipPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
        ),
        // 顶部收缩的搜索框
        Material(
          color: theme.colorScheme.surface,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: '关键词或图片',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: notifier.setSearchKeyword,
                    onSubmitted: (_) => notifier.loadProducts(refresh: true),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  tooltip: '添加图片',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => notifier.loadProducts(refresh: true),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: MuListView<PurchaseAssistSearchProduct>(
            state: state,
            list: state.productList,
            onRefresh: () => notifier.loadProducts(refresh: true),
            onLoadMore: () => notifier.loadProducts(refresh: false),
            refreshOnStart: false,
            itemBuilder: (context, item) => ListTile(
              title: Text(item.name ?? ''),
              subtitle: item.id != null ? Text('ID: ${item.id}') : null,
            ),
          ),
        ),
      ],
    );
  }
}
