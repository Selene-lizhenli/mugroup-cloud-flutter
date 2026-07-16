import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/samples/widgets/home_media.dart';
import 'package:cloud/widgets/common_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

 
class HomeAppBar extends HookConsumerWidget {
  final TextEditingController controller;
  final void Function(String search)? onSearchText;
  final void Function(TemporaryMedia temporaryMedia)? onSearchMedia;
  final void Function(TemporaryMedia temporaryMedia)? onDeleteMedia;

  const HomeAppBar({
    super.key,
    required this.controller,
    this.onSearchText,
    this.onSearchMedia,
    this.onDeleteMedia,
  });
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
