import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/market_product/providers/home_provider.dart';
import 'package:cloud/pages/market_product/list/widgets/home_media.dart';
import 'package:cloud/widgets/common_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
 

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
    handleUploadMedia() => showHomeImageUploadSheet(
          context,
          onSearchMedia: onSearchMedia,
        );

    return CommonHomeAppBar(
      controller: controller,
      onSearchText: onSearchText,
      onSearchMedia: onSearchMedia,
      enableImageSearch: enableImageSearch,
      fillColor: fillColor,
      margin: EdgeInsets.zero,
      height: 35,
      borderRadius: BorderRadius.circular(8),
      contentPadding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      cameraIconColor: Colors.grey,
      onTapUpload: handleUploadMedia,
      bottom: home.currentMediaId != null
          ? HomeMedia(
              media: home.media,
              onTapUplod: handleUploadMedia,
              currentMediaId: home.currentMediaId!,
              onTapMedia: onSearchMedia,
              onDeleteMedia: onDeleteMedia,
            )
          : null,
    );
  }
}
