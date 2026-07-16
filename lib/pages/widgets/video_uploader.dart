import 'dart:io';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_compress_plus/video_compress_plus.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/services/media.dart';

class VideoUploader extends StatelessWidget {
  final List<TemporaryMedia> value;
  final int maxCount;
  final Function(List<TemporaryMedia>) onChanged;
  final String? label;

  const VideoUploader({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxCount = 1,
    this.label,
  });

  Future<void> _handleTap(BuildContext context) async {
    if (value.length >= maxCount) return;

    await showFlanActionSheet(
      context,
      cancelText: "取消",
      actions: [
        FlanActionSheetAction(
          name: "拍摄视频",
          callback: (action) async {
            Navigator.pop(context);
            await _handleCamera(context);
          },
        ),
        FlanActionSheetAction(
          name: "从手机相册选择",
          callback: (action) async {
            Navigator.pop(context);
            await _handlePickVideo(context);
          },
        ),
      ],
    );
  }

  bool _isFileSizeValid(File file) {
    const int maxSizeBytes = 50 * 1024 * 1024;
    final int fileSize = file.lengthSync();

    if (fileSize > maxSizeBytes) {
      final double sizeInMb = fileSize / (1024 * 1024);
      EasyLoading.showError(
          '视频文件过大 (${sizeInMb.toStringAsFixed(1)}MB)，请限制在 50MB 以内');
      return false;
    }
    return true;
  }

  Future<void> _handlePickVideo(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.video,
      ),
    );

    if (assets == null || assets.isEmpty) return;
    final File? file = await assets.first.originFile;
    if (file == null) return;

    if (!_isFileSizeValid(file)) return;
    _uploadFile(file);
  }

  Future<void> _handleCamera(BuildContext context) async {
    final AssetEntity? asset = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(
        enableRecording: true,
        onlyEnableRecording: true,
        maximumRecordingDuration: Duration(seconds: 30),
      ),
    );

    if (asset == null) return;
    final File? file = await asset.originFile;
    if (file == null) return;

    if (!_isFileSizeValid(file)) return;
    _uploadFile(file);
  }

  Future<void> _uploadFile(File file) async {
    try {
      EasyLoading.show(status: '正在压缩视频...');

      await VideoCompress.cancelCompression();
      await Future.delayed(const Duration(milliseconds: 200));

      MediaInfo? info = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      File fileToUpload =
          (info != null && info.file != null) ? info.file! : file;

      EasyLoading.show(status: '正在上传视频...');
      final media = await upload(file: fileToUpload);

      final newList = List<TemporaryMedia>.from(value);
      newList.add(media);
      onChanged(newList);

      EasyLoading.showSuccess('上传完成');

      // 清理缓存
      await VideoCompress.deleteAllCache();
    } catch (e, stack) {
      debugPrint('视频压缩错误详情: $e');
      debugPrint('堆栈信息: $stack');

      try {
        debugPrint('压缩失败，尝试直接上传原文件...');
        final media = await upload(file: file);
        final newList = List<TemporaryMedia>.from(value);
        newList.add(media);
        onChanged(newList);
        EasyLoading.showSuccess('上传完成(未压缩)');
      } catch (uploadError) {
        EasyLoading.showError('上传失败');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _removeVideo(BuildContext context, int index,
      {bool isPreview = false}) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: '删除视频',
      content: '确定要删除这段验货视频吗？',
      confirmText: '确定',
      cancelText: '取消',
    );

    if (confirmed == true) {
      if (isPreview) {
        Navigator.of(context).pop();
      }

      final item = value[index];

      try {
        if (item.uuid == null) {
          EasyLoading.show(status: '正在删除文件...');
          final mediaId = item.idAsInt;
          if (mediaId != null) {
            await deleteMedia(mediaId, {});
          }
        }

        final newList = List<TemporaryMedia>.from(value);
        newList.removeAt(index);
        onChanged(newList);

        EasyLoading.showSuccess('已删除');
      } catch (e) {
        debugPrint('删除媒体失败: $e');
        EasyLoading.showError('服务端删除失败');
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  void _showPreview(BuildContext context, String url, int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      pageBuilder: (ctx, anim1, anim2) => _VideoFullscreenPage(
        url: url,
        onDelete: () => _removeVideo(context, index, isPreview: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333))),
          const SizedBox(height: 10),
        ],
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...value.asMap().entries.map((entry) => _VideoPreviewItem(
                  media: entry.value,
                  onDelete: () => _removeVideo(context, entry.key),
                  onPreview: () =>
                      _showPreview(context, entry.value.url, entry.key),
                )),
            if (value.length < maxCount) _buildAddBtn(context),
          ],
        ),
      ],
    );
  }

  Widget _buildAddBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_call_rounded, color: Colors.grey, size: 32),
            SizedBox(height: 4),
            Text('添加视频', style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _VideoPreviewItem extends StatelessWidget {
  final TemporaryMedia media;
  final VoidCallback onDelete;
  final VoidCallback onPreview;

  const _VideoPreviewItem(
      {required this.media, required this.onDelete, required this.onPreview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPreview,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                media.thumbUrl ?? media.url,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                    color: const Color(0xFFEEEEEE),
                    child: const Icon(Icons.video_library, color: Colors.grey)),
              ),
            ),
            Positioned.fill(child: Container(color: Colors.black26)),
            const Center(
                child: Icon(Icons.play_circle_outline,
                    color: Colors.white, size: 32)),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(8)),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoFullscreenPage extends StatefulWidget {
  final String url;
  final VoidCallback onDelete;
  const _VideoFullscreenPage({required this.url, required this.onDelete});

  @override
  State<_VideoFullscreenPage> createState() => _VideoFullscreenPageState();
}

class _VideoFullscreenPageState extends State<_VideoFullscreenPage> {
  late VideoPlayerController _controller;
  bool _isInit = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() => _isInit = true);
        _controller.play();
        _controller.setLooping(true);
      });
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isInit)
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                else
                  const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                if (_isInit && !_controller.value.isPlaying)
                  IgnorePointer(
                      child: Icon(Icons.play_arrow_rounded,
                          color: Colors.white.withOpacity(0.5), size: 80)),
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      _buildHeader(context),
                      const Spacer(),
                      if (_isInit) _buildFooter(context),
                    ],
                  ),
                ),
                if (_isInit)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => setState(() => _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play()),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                if (_showControls)
                  Positioned(
                      top: 0, left: 0, right: 0, child: _buildHeader(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.top + 56,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Colors.white, size: 26),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black54, Colors.transparent]),
      ),
      child: Row(
        children: [
          Text(_formatDuration(_controller.value.position),
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          Expanded(
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.white10),
            ),
          ),
          Text(_formatDuration(_controller.value.duration),
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
