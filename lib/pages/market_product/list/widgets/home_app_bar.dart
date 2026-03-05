import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/pages/market_product/list/widgets/home_media.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class HomeAppBarItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final bool active;

  const HomeAppBarItem({
    super.key,
    required this.onTap,
    required this.text,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DefaultTextStyle(
        style: active
            ? const TextStyle(fontSize: 18, color: Colors.white)
            : const TextStyle(fontSize: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text),
        ),
      ),
    );
  }
}

class HomeAppBar extends HookConsumerWidget {
  final TextEditingController controller;
  final void Function(String search)? onSearchText;
  final void Function(TemporaryMedia temporaryMedia)? onSearchMedia;
  final void Function(TemporaryMedia temporaryMedia)? onDeleteMedia;

  final bool enableImageSearch;

  final Color? fillColor;

  const HomeAppBar({
    super.key,
    required this.controller,
    this.onSearchText,
    this.onSearchMedia,
    this.onDeleteMedia,
    this.enableImageSearch = true,
    this.fillColor,
  });

  get transparent => null;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final focusNode = useFocusNode();
    final colorScheme = Theme.of(context).colorScheme;

    handleUploadMedia() async {
      await showFlanActionSheet(
        context,
        cancelText: "取消",
        actions: [
          FlanActionSheetAction(
            name: "拍摄",
            callback: (action) async {
              final AssetEntity? entity =
                  await CameraPicker.pickFromCamera(context);

              if (context.mounted) {
                Navigator.of(context).maybePop();
              }

              if (entity == null) {
                return;
              }

              final file = await entity.file;

              final temporaryMedia = await upload(file: file!);

              onSearchMedia?.call(temporaryMedia);
            },
          ),
          FlanActionSheetAction(
            name: "从手机相册选择",
            callback: (action) async {
              final List<AssetEntity>? result =
                  await AssetPicker.pickAssets(context);

              if (context.mounted) {
                Navigator.of(context).maybePop();
              }

              if (result == null) {
                return;
              }

              for (var entity in result) {
                final file = await entity.file;

                final temporaryMedia = await upload(file: file!);

                onSearchMedia?.call(temporaryMedia);
              }
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: '',
                          filled: true,
                          fillColor: fillColor ?? Colors.transparent,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          onSearchText?.call(value);
                        },
                      ),
                    ),
                    if (enableImageSearch)
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          icon: const Icon(
                            CupertinoIcons.camera,
                            size: 28,
                            color: Colors.grey,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: handleUploadMedia,
                        ),
                      ),
                    Container(
                      color: Colors.grey,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 0,
                      height: 0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 0, bottom: 0, left: 0, right: 0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          onSearchText?.call(controller.text);
                        },
                        child: Text(
                          "搜索",
                          style: TextStyle(
                            fontSize: 15,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
       
            // IconButton(
            //   icon: Stack(
            //     clipBehavior: Clip.none,
            //     children: [
            //       const MuThemeIcon(
            //         iconType: 'filter',
            //         iconSize: 24,
            //       ),
            //       // if (hasActiveFilters)
            //       Positioned(
            //         right: -1,
            //         top: -1,
            //         child: Container(
            //           width: 8,
            //           height: 8,
            //           decoration: BoxDecoration(
            //             color: Colors.red,
            //             shape: BoxShape.circle,
            //             border: Border.all(color: Colors.white, width: 1),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            //   tooltip: '筛选',
            //   padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            //   constraints: const BoxConstraints(),
            //   style: IconButton.styleFrom(
            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   ),
            //   onPressed: () {
            //     // showModalBottomSheet(
            //     //   context: context,
            //     //   isScrollControlled: true,
            //     //   backgroundColor: Colors.transparent,
            //     //   constraints: BoxConstraints(
            //     //     maxWidth:
            //     //         MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
            //     //   ),
            //     //   builder: (sheetContext) => GestureDetector(
            //     //     behavior: HitTestBehavior.opaque,
            //     //     onTap: () => Navigator.of(context).pop(),
            //     //     child: Padding(
            //     //       padding: EdgeInsets.only(
            //     //         bottom: math.max(
            //     //           MediaQuery.of(sheetContext).viewInsets.bottom,
            //     //           0,
            //     //         ),
            //     //       ),
            //     //       child: DraggableScrollableSheet(
            //     //         initialChildSize: 0.6,
            //     //         minChildSize: 0.6,
            //     //         maxChildSize: 0.85,
            //     //         builder: (context, scrollController) => Container(
            //     //           decoration: BoxDecoration(
            //     //             color: Theme.of(context).colorScheme.surface,
            //     //             borderRadius:
            //     //                 const BorderRadius.vertical(top: Radius.circular(12)),
            //     //           ),
            //     //           child: FilterContent(scrollController: scrollController),
            //     //         ),
            //     //       ),
            //     //     ),
            //     //   ),
            //     // );
            //   },
            // ),
       
          ],
        ),
        if (home.currentMediaId != null)
          HomeMedia(
            media: home.media,
            onTapUplod: handleUploadMedia,
            currentMediaId: home.currentMediaId!,
            onTapMedia: onSearchMedia,
            onDeleteMedia: onDeleteMedia,
          ),
      ],
    );
  }
}
