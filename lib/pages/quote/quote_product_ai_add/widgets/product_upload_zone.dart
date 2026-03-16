import 'dart:io';

import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ProductUploadZone extends HookConsumerWidget {
  final Function(List<File> files)? onContinuousSelected;
  final Function(File file) onFileSelected;
  final double width;
  final double height;

  const ProductUploadZone({
    super.key,
    required this.onFileSelected,
    this.onContinuousSelected,
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
    final List<FlanActionSheetAction> menuActions = [
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
    ];

    if (onContinuousSelected != null) {
      menuActions.insert(
          1,
          FlanActionSheetAction(
            name: "单个产品连拍",
            callback: (_) async {
              Navigator.pop(context);
              final files = await _getContinuousFiles(context);
              if (files != null && files.isNotEmpty) {
                onContinuousSelected!(files);
              }
            },
          ));

      menuActions.insert(
        2,
        FlanActionSheetAction(
          name: "单个产品相册选择",
          callback: (_) async {
            Navigator.pop(context);
            final result = await AssetPicker.pickAssets(
              context,
              pickerConfig: const AssetPickerConfig(
                  maxAssets: 50, requestType: RequestType.image),
            );

            if (result != null && result.isNotEmpty) {
              List<File> files = [];
              for (var e in result) {
                final f = await e.file;
                if (f != null) files.add(f);
              }

              if (files.isNotEmpty) {
                onContinuousSelected!(files);
              }
            }
          },
        ),
      );
    }

    showFlanActionSheet(
      context,
      cancelText: "取消",
      actions: menuActions, // 使用动态生成的列表
    );
  }

  Future<List<File>?> _getContinuousFiles(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return null;

    final List<XFile>? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContinuousCameraPage(cameras: cameras)),
    );

    return result?.map((x) => File(x.path)).toList();
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
