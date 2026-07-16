import 'dart:io';

import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/helper/camera_capture.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// Shared top search bar with optional image-search entry.
///
/// Feature modules can wrap this widget and render their own bottom area
/// (e.g. different `HomeMedia` implementations).
Future<void> showHomeImageUploadSheet(
  BuildContext context, {
  void Function(TemporaryMedia temporaryMedia)? onSearchMedia,
}) async {
  final l10n = context.l10n;
  await showFlanActionSheet(
    context,
    cancelText: l10n.cancel,
    actions: [
      FlanActionSheetAction(
        name: l10n.samplesCapture,
        callback: (_) async {
          try {
            final File? file = await captureSinglePhotoFile();
            if (context.mounted) Navigator.of(context).maybePop();
            if (file == null) return;

            final TemporaryMedia temporaryMedia = await upload(file: file);
            onSearchMedia?.call(temporaryMedia);
          } catch (e) {
            if (context.mounted) {
              EasyLoading.showError(l10n.samplesCameraOpenFailed(e.toString()));
            }
          }
        },
      ),
      FlanActionSheetAction(
        name: l10n.samplesPickFromGallery,
        callback: (_) async {
          final List<AssetEntity>? result = await AssetPicker.pickAssets(
            context,
            pickerConfig:
                const AssetPickerConfig(requestType: RequestType.image),
          );

          if (context.mounted) Navigator.of(context).maybePop();
          if (result == null || result.isEmpty) return;

          for (final entity in result) {
            final file = await entity.file;
            if (file == null) continue;
            final TemporaryMedia temporaryMedia = await upload(file: file);
            onSearchMedia?.call(temporaryMedia);
          }
        },
      ),
    ],
  );
}

class CommonHomeAppBar extends HookWidget {
  final TextEditingController controller;
  final void Function(String search)? onSearchText;
  final void Function(TemporaryMedia temporaryMedia)? onSearchMedia;

  final bool enableImageSearch;
  final Color? fillColor;
  final EdgeInsetsGeometry margin;
  final double height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Color? cameraIconColor;

  final Widget? bottom;
  final VoidCallback? onTapUpload;

  const CommonHomeAppBar({
    super.key,
    required this.controller,
    this.onSearchText,
    this.onSearchMedia,
    this.enableImageSearch = true,
    this.fillColor,
    this.margin = const EdgeInsets.only(left: 16, right: 16, bottom: 8),
    this.height = 36,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    this.contentPadding = const EdgeInsets.only(left: 12, right: 0),
    this.cameraIconColor,
    this.bottom,
    this.onTapUpload,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final focusNode = useFocusNode();
    final colorScheme = Theme.of(context).colorScheme;

    final bar = Container(
      width: double.infinity,
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: height,
              padding: contentPadding,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 1),
                borderRadius: borderRadius,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: false,
                      controller: controller,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      style: const TextStyle(fontSize: 14),
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: '',
                        filled: true,
                        fillColor: fillColor ?? Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 8),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) => onSearchText?.call(value),
                    ),
                  ),
                  if (enableImageSearch)
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.camera,
                          size: 25,
                          color: cameraIconColor ?? colorScheme.outline,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onTapUpload ??
                        
                            () => showHomeImageUploadSheet(
                                  context,
                                  onSearchMedia: onSearchMedia,
                                ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: height,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            bottomLeft: Radius.circular(0),
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () => onSearchText?.call(controller.text),
                      child: Text(
                        l10n.search,
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
        ],
      ),
    );

    if (bottom == null) return bar;
    return Column(children: [bar, bottom!]);
  }
}
