import 'dart:io';

import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ProductUploadZone extends HookConsumerWidget {
  final Function(File file) onFileSelected;
  final double width;
  final double height;

  const ProductUploadZone({
    super.key,
    required this.onFileSelected,
    this.width = 90,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _showPickerMenu(context),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_rounded, color: Color(0xFF999999), size: 28),
          ],
        ),
      ),
    );
  }

  /// 弹出选择菜单
  void _showPickerMenu(BuildContext context) {
    showFlanActionSheet(
      context,
      cancelText: "取消",
      actions: [
        FlanActionSheetAction(
          name: "拍摄照片",
          callback: (_) async {
            Navigator.pop(context);
            final entity = await CameraPicker.pickFromCamera(context);
            final file = await entity?.file;
            if (file != null) onFileSelected(file);
          },
        ),
        FlanActionSheetAction(
          name: "连拍模式",
          callback: (_) async {
            Navigator.pop(context);
            _handleContinuous(context);
          },
        ),
        FlanActionSheetAction(
          name: "从相册选择",
          callback: (_) async {
            Navigator.pop(context);
            final result = await AssetPicker.pickAssets(
              context,
              pickerConfig: const AssetPickerConfig(
                  maxAssets: 50, requestType: RequestType.image),
            );
            if (result != null) {
              for (var e in result) {
                final f = await e.file;
                if (f != null) onFileSelected(f);
              }
            }
          },
        ),
      ],
    );
  }

  /// 连拍跳转逻辑
  Future<void> _handleContinuous(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final List<XFile>? result = await Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
          builder: (context) => ContinuousCameraPage(cameras: cameras)),
    );

    if (result != null) {
      for (var xFile in result) {
        onFileSelected(File(xFile.path));
      }
    }
  }
}
