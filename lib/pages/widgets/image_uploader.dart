import 'dart:io';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ImageUploader extends HookConsumerWidget {
  final String? label;
  final int? maxCount;
  final List<TemporaryMedia>? value;
  final ValueChanged<List<TemporaryMedia>>? onChanged;

  // 智能识别相关
  final bool showRecognizeButton;
  final Future<dynamic> Function(Map<String, dynamic>)? recognizeApi;
  final ValueChanged<dynamic>? onRecognizeResult;
  final String? errorText;

  /// 智能识别按钮位置：
  /// false => 顶部（默认）、true => 底部左对齐
  final bool recognizeAtBottom;

  // --- 核心控制参数 ---
  /// 模式控制：
  /// true  => 单击直接进入普通相机
  /// false => 单击弹出菜单（包含“拍摄”和“相册”）
  final bool directCamera;

  /// 连拍开关：
  /// true  => 允许长按进入连拍模式
  /// false => 长按无效果
  final bool enableContinuous;

  final IconData? customIcon;

  final void Function(List<File> files)? onContinuousCapture;

  const ImageUploader({
    super.key,
    this.label,
    this.maxCount,
    this.value,
    this.onChanged,
    this.showRecognizeButton = false,
    this.recognizeApi,
    this.onRecognizeResult,
    this.errorText,
    this.recognizeAtBottom = false,
    // 默认设置：保留弹窗，关闭连拍
    this.directCamera = false,
    this.enableContinuous = false,
    this.onContinuousCapture,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImages = value ?? [];
    final int remainingCount = (maxCount == null || maxCount! <= 0)
        ? 999
        : maxCount! - currentImages.length;

    final bool hasError =
        (errorText?.isNotEmpty ?? false) && currentImages.isEmpty;

    // --- 内部方法：上传文件 (用于连拍/普通拍摄) ---
    Future<void> uploadFiles(List<File> files) async {
      final List<TemporaryMedia> uploadedMedias = [];
      try {
        EasyLoading.show(status: '上传中...');
        for (final file in files) {
          final TemporaryMedia temporaryMedia = await upload(file: file);
          uploadedMedias.add(temporaryMedia);
        }
      } finally {
        EasyLoading.dismiss();
      }

      if (uploadedMedias.isNotEmpty) {
        onChanged?.call([...currentImages, ...uploadedMedias]);
      }
    }

    // --- 内部方法：上传实体 (用于相册选择) ---
    Future<void> uploadEntities(List<AssetEntity> entities) async {
      final List<File> files = [];
      for (final entity in entities) {
        final f = await entity.file;
        if (f != null) files.add(f);
      }
      if (files.isNotEmpty) await uploadFiles(files);
    }

    // --- 动作 1：打开普通相机 ---
    Future<void> openStandardCamera() async {
      final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
      if (entity != null) {
        // CameraPicker 返回的是 AssetEntity，转换一下
        final f = await entity.file;
        if (f != null) await uploadFiles([f]);
      }
    }

    // --- 动作 2：打开相册 ---
    Future<void> openGallery() async {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: remainingCount,
          requestType: RequestType.image,
        ),
      );
      if (result != null && result.isNotEmpty) {
        await uploadEntities(result);
      }
    }

    // --- 动作 3：打开连拍 (长按触发) ---
    Future<void> openContinuousCamera() async {
      try {
        final cameras = await availableCameras();
        if (cameras.isEmpty) {
          EasyLoading.showError('未检测到相机');
          return;
        }
        if (context.mounted) {
          final List<XFile>? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContinuousCameraPage(cameras: cameras),
            ),
          );
          if (result != null && result.isNotEmpty) {
            final List<File> files = result.map((e) => File(e.path)).toList();

            if (onContinuousCapture != null) {
              onContinuousCapture!(files); // 交给父组件处理分发
            } else {
              await uploadFiles(files);
            }
          }
        }
      } catch (e) {
        EasyLoading.showError('无法打开相机: $e');
      }
    }

    // --- 点击处理逻辑 ---
    Future<void> handleTap() async {
      if (remainingCount <= 0) return;

      if (directCamera) {
        // 模式一：直接进相机
        await openStandardCamera();
      } else {
        // 模式二：弹窗选择 (相册 + 相机)
        await showFlanActionSheet(
          context,
          cancelText: "取消",
          actions: [
            FlanActionSheetAction(
              name: "拍摄",
              callback: (action) async {
                if (context.mounted) Navigator.of(context).maybePop();
                await openStandardCamera();
              },
            ),
            FlanActionSheetAction(
              name: "从手机相册选择",
              callback: (action) async {
                if (context.mounted) Navigator.of(context).maybePop();
                await openGallery();
              },
            ),
          ],
        );
      }
    }

    // --- 长按处理逻辑 ---
    Future<void> handleLongPress() async {
      if (remainingCount <= 0 || !enableContinuous) return;
      HapticFeedback.mediumImpact();
      await openContinuousCamera();
    }

    void handleDelete(int index) async {
      final bool confirm = await ConfirmDialog.show(
        context,
        content: '确定要移除这张图片吗？',
      );
      if (!confirm) return;
      final newImageList = [...currentImages];
      var item = newImageList[index];
      if (item.uuid == null) {
        await deleteMedia(item.id, {});
      }
      newImageList.removeAt(index);
      onChanged?.call(newImageList);
    }

    Future<void> handleSmartRecognize() async {
      // 1. 校验是否有图片
      if (currentImages.isEmpty) {
        EasyLoading.showInfo("请先上传图片");
        return;
      }

      if (recognizeApi == null) {
        debugPrint('ImageUploader: recognizeApi is null');
        return;
      }

      await EasyLoading.show(
          status: '智能识别中...', maskType: EasyLoadingMaskType.clear);

      final result = await recognizeApi!({'image': currentImages});

      // 5. 回调结果
      if (result != null && onRecognizeResult != null) {
        EasyLoading.showSuccess("识别成功");
        onRecognizeResult!(result);
      } else {
        EasyLoading.dismiss();
      }
    }

    final bool showTopBar =
        label != null || (showRecognizeButton && !recognizeAtBottom);
    final bool showBottomRecognize = showRecognizeButton && recognizeAtBottom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopBar) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(label!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold))
              else
                const SizedBox(),
              if (showRecognizeButton && !recognizeAtBottom)
                GestureDetector(
                  onTap: handleSmartRecognize,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.center_focus_weak,
                            size: 16, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 4),
                        Text("智能识别",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...List.generate(currentImages.length, (index) {
                  return _buildImageItem(context, index,
                      currentImages[index].thumbUrl ?? currentImages[index].url,
                      onRemove: () => handleDelete(index));
                }),
                if (remainingCount > 0)
                  _buildAddButton(
                    onTap: handleTap,
                    // 只有开启了连拍，才绑定长按事件
                    onLongPress: enableContinuous ? handleLongPress : null,
                    hasError: hasError,
                  ),
              ],
            ),
            if (showBottomRecognize)
              Padding(
                padding: const EdgeInsets.only(top: 8.0,left: 12),
                child: GestureDetector(
                  onTap: handleSmartRecognize,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.center_focus_weak,
                          size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 4),
                      Text("智能识别",
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 2.0),
            child: Text(errorText!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildImageItem(BuildContext context, int index, String? url,
      {required VoidCallback onRemove}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            showFlanImagePreview(
              context,
              images: value!.map((e) => e.url).toList(),
              startPosition: index,
              loop: false,
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: url != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(url, fit: BoxFit.cover))
                : const Icon(Icons.image, color: Colors.grey),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)]),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(
      {required VoidCallback onTap,
      VoidCallback? onLongPress,
      bool hasError = false}) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: hasError ? Colors.red : const Color(0xFFD9D9D9),
            width: hasError ? 1.2 : 1.0,
          ),
        ),
        child:   Icon(customIcon ?? Icons.add, color: Color(0xFF999999), size: 28),
      ),
    );
  }
}

class ContinuousCameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ContinuousCameraPage({super.key, required this.cameras});

  @override
  State<ContinuousCameraPage> createState() => _ContinuousCameraPageState();
}

class _ContinuousCameraPageState extends State<ContinuousCameraPage>
    with WidgetsBindingObserver {
  late CameraController _controller;
  final List<XFile> _capturedImages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isReady = false;
  bool _isFlashing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.jpeg
          : ImageFormatGroup.bgra8888,
    );
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() => _isReady = true);
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _takePhoto() async {
    if (!_controller.value.isInitialized) return;
    setState(() => _isFlashing = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _isFlashing = false);
    });
    HapticFeedback.mediumImpact();

    try {
      final file = await _controller.takePicture();
      setState(() => _capturedImages.add(file));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      debugPrint("Take photo error: $e");
    }
  }

  void _showImagePreview(XFile file) {
    showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: Colors.black,
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Center(
                  child: Image.file(File(file.path), fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(ctx),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _capturedImages.remove(file);
                      });
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: CameraPreview(_controller)),
          if (_isFlashing)
            Positioned.fill(
                child: Container(color: Colors.white.withOpacity(0.5))),
          if (_capturedImages.isNotEmpty)
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                color: Colors.black26,
                child: ListView.separated(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: _capturedImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    return _buildThumbnailItem(
                        _capturedImages[index], index + 1);
                  },
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent]),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 32),
                        onPressed: () => Navigator.pop(context)),
                    GestureDetector(
                      onTap: _takePhoto,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.shade400, width: 4)),
                        child: const Icon(Icons.camera_alt,
                            size: 32, color: Colors.black54),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, _capturedImages),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: _capturedImages.isEmpty
                                ? Colors.white24
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                            _capturedImages.isEmpty
                                ? '完成'
                                : '完成(${_capturedImages.length})',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailItem(XFile file, int number) {
    return GestureDetector(
      onTap: () => _showImagePreview(file),
      child: Stack(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(4)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.file(File(file.path), fit: BoxFit.cover)),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(2)),
              child: Text("$number",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
