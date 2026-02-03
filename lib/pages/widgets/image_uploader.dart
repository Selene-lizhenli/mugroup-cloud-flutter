import 'dart:io';
import 'dart:ui';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
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

  /// 新增参数：直接打开相册
  final bool directGallery;

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
    this.directGallery = false,
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
      } else if (directGallery) {
        // 优先级 2：直接进相册 (新增逻辑)
        print(directGallery);
        await openGallery();
      } else {
        // 模式二：弹窗选择 (相册 + 相机)
        await showFlanActionSheet(
          context,
          cancelText: "取消",
          actions: [
            FlanActionSheetAction(
              name: "拍摄",
              callback: (action) async {
                Navigator.pop(context);
                await openStandardCamera();
              },
            ),
            FlanActionSheetAction(
              name: "从手机相册选择",
              callback: (action) async {
                Navigator.pop(context);
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
                padding: const EdgeInsets.only(top: 8.0, left: 12),
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
          color: const Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: hasError ? Colors.red : const Color(0x00FFFFFF),
            width: hasError ? 1.2 : 1.0,
          ),
        ),
        child: Icon(customIcon ?? Icons.add,
            color: const Color(0xFF999999), size: 28),
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
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late CameraController _controller;

  final List<XFile?> _capturedImages = [];

  int? _replaceIndex;

  final ScrollController _scrollController = ScrollController();
  bool _isReady = false;

  late AnimationController _shutterAnimController;
  late Animation<double> _shutterScaleAnim;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _shutterAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _shutterScaleAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
        CurvedAnimation(
            parent: _shutterAnimController, curve: Curves.easeInOut));

    _initCamera();
  }

  Future<void> _initCamera() async {
    if (widget.cameras.isEmpty) return;

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

      await _controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
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
    _shutterAnimController.dispose();
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

    _shutterAnimController
        .forward()
        .then((_) => _shutterAnimController.reverse());
    HapticFeedback.lightImpact();

    try {
      final file = await _controller.takePicture();

      setState(() {
        if (_replaceIndex != null) {
          if (_replaceIndex! < _capturedImages.length) {
            _capturedImages[_replaceIndex!] = file;
          }
          _replaceIndex = null;
        } else {
          _capturedImages.add(file);

          Future.delayed(const Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuart,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Take photo error: $e");
    }
  }

  void _deleteAndRetake(int index) {
    setState(() {
      _capturedImages[index] = null;
      _replaceIndex = index;
    });
  }

  void _showImagePreview(int index) {
    XFile? file = _capturedImages[index];
    if (file == null) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Preview",
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: InteractiveViewer(
                    child: Image.file(File(file.path), fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        Text("${index + 1}/${_capturedImages.length}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        _deleteAndRetake(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2C),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh_rounded,
                                color: Colors.amber, size: 20),
                            SizedBox(width: 8),
                            Text("重拍此页",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: MuProgressIndicator(barWidth: 2)),
      );
    }

    final int validCount = _capturedImages.where((e) => e != null).length;
    final bool isRetakeMode = _replaceIndex != null;

    const Color primaryColor = Color(0xFF007AFF);
    const Color warningColor = Color(0xFFFF9500);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(child: CameraPreview(_controller)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const Spacer(),
                      if (isRetakeMode)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: warningColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text("正在重拍第 ${_replaceIndex! + 1} 张",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_capturedImages.isNotEmpty)
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 90,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.3),
                        alignment: Alignment.centerLeft,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: _capturedImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, index) =>
                              _buildThumbnailItem(index, isRetakeMode),
                        ),
                      ),
                    ),
                  ),
                Container(
                  color: Colors.black.withOpacity(0.6),
                  padding: const EdgeInsets.only(top: 24, bottom: 48),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 80,
                            child: Center(
                              child: Text("已拍 $validCount",
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12)),
                            )),
                        GestureDetector(
                          onTap: _takePhoto,
                          child: ScaleTransition(
                            scale: _shutterScaleAnim,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isRetakeMode
                                      ? warningColor
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                final result =
                                    _capturedImages.whereType<XFile>().toList();
                                Navigator.pop(context, result);
                              },
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: validCount > 0 ? 1.0 : 0.5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text("完成",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailItem(int index, bool isGlobalRetakeMode) {
    final XFile? file = _capturedImages[index];
    final bool isTarget = _replaceIndex == index;

    return GestureDetector(
      onTap: () {
        if (file == null) {
          setState(() => _replaceIndex = index);
        } else {
          _showImagePreview(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 76,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: isTarget
              ? Border.all(color: const Color(0xFFFF9500), width: 2)
              : Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          color: Colors.white.withOpacity(0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (file != null)
                Image.file(File(file.path), fit: BoxFit.cover)
              else
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white38, size: 20),
                  ),
                ),
              if (isGlobalRetakeMode && !isTarget)
                Container(color: Colors.black54),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  color: isTarget ? const Color(0xFFFF9500) : Colors.black54,
                  child: Text(
                    "${index + 1}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (file == null && isTarget)
                const Center(
                    child: Text("补拍",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      ),
    );
  }
}
