import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showAdviceEditSheet({
  required BuildContext context,
  String? replyToName,
  required Function(String content, List<File> images) onSend,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AdviceEditSheet(
      replyToName: replyToName,
      onSend: onSend,
    ),
  );
}

class _AdviceEditSheet extends StatefulWidget {
  final String? replyToName;
  final Function(String content, List<File> images) onSend;

  const _AdviceEditSheet({this.replyToName, required this.onSend});

  @override
  State<_AdviceEditSheet> createState() => _AdviceEditSheetState();
}

class _AdviceEditSheetState extends State<_AdviceEditSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<File> _images = [];
  static const int _maxImageCount = 9;

  bool get _canSend => _controller.text.trim().isNotEmpty || _images.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePickAssets() async {
    final int remainingQuota = _maxImageCount - _images.length;

    if (remainingQuota <= 0) {
      EasyLoading.showToast('最多只能上传$_maxImageCount张图片');
      return;
    }

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: remainingQuota,
        requestType: RequestType.image,
        themeColor: Theme.of(context).primaryColor,
      ),
    );

    if (result != null && result.isNotEmpty) {
      EasyLoading.show(status: '加载中...');
      try {
        final List<File> newFiles = [];
        for (final entity in result) {
          final f = await entity.file;
          if (f != null) newFiles.add(f);
        }
        setState(() {
          _images.addAll(newFiles);
        });
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 输入区域：灰色圆角矩形
          _buildInputArea(),

          // 2. 图片预览回显区
          if (_images.isNotEmpty) _buildImageGallery(),

          // 3. 底部操作栏：图片图标 + 发送按钮
          _buildBottomToolbar(colorScheme),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 5,
        minLines: 3,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: widget.replyToName != null
              ? '回复 @${widget.replyToName}...'
              : '说点什么...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // 如果图片未满，末尾显示一个追加按钮
        itemCount: _images.length < _maxImageCount
            ? _images.length + 1
            : _images.length,
        itemBuilder: (context, index) {
          if (index < _images.length) {
            return _buildImagePreviewItem(index);
          } else {
            return _buildAppendButton();
          }
        },
      ),
    );
  }

  Widget _buildImagePreviewItem(int index) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(_images[index],
                width: 70, height: 70, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () => setState(() => _images.removeAt(index)),
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppendButton() {
    return GestureDetector(
      onTap: _handlePickAssets,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(top: 8, right: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }

  Widget _buildBottomToolbar(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: _handlePickAssets,
            icon: const Icon(Icons.image_outlined,
                color: Colors.black54, size: 28),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _canSend
                ? () {
                    widget.onSend(_controller.text, _images);
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              // 关键：根据状态切换深浅色
              backgroundColor: _canSend
                  ? colorScheme.primary
                  : colorScheme.primary.withOpacity(0.3),
              foregroundColor: Colors.white,
              disabledBackgroundColor: colorScheme.primary.withOpacity(0.3),
              disabledForegroundColor: Colors.white.withOpacity(0.7),
              elevation: 0,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child:
                const Text('发送', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
