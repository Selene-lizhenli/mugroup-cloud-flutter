import 'dart:io';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud/pages/widgets/muShowModalBottomSheet.dart';

void showAdviceEditSheet({
  required BuildContext context,
  String? replyToName,
  bool isReply = false,
  required Function(
          String content, List<TemporaryMedia> medias, bool isAnonymous)
      onSend,
}) {
  muShowModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AdviceEditSheet(
      replyToName: replyToName,
      isReply: isReply,
      onSend: onSend,
    ),
  );
}

class _AdviceEditSheet extends StatefulWidget {
  final bool isReply;
  final String? replyToName;
  final Function(String content, List<TemporaryMedia> medias, bool isAnonymous)
      onSend;

  const _AdviceEditSheet(
      {this.replyToName, this.isReply = false, required this.onSend});

  @override
  State<_AdviceEditSheet> createState() => _AdviceEditSheetState();
}

class _AdviceEditSheetState extends State<_AdviceEditSheet> {
  final TextEditingController _controller = TextEditingController();

  final List<TemporaryMedia> _uploadedMedias = [];
  static const int _maxImageCount = 9;

  bool _isAnonymous = false;

  bool get _canSend =>
      _controller.text.trim().isNotEmpty || _uploadedMedias.isNotEmpty;

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
    final int remainingQuota = _maxImageCount - _uploadedMedias.length;

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
      EasyLoading.show(status: '上传中...');
      try {
        for (final entity in result) {
          final File? f = await entity.file;
          if (f != null) {
            final TemporaryMedia temporaryMedia = await upload(file: f);
            setState(() {
              _uploadedMedias.add(temporaryMedia);
            });
          }
        }
      } catch (e) {
        EasyLoading.showError('图片上传失败');
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
          _buildInputArea(colorScheme),
          if (_uploadedMedias.isNotEmpty) _buildImageGallery(),
          _buildBottomToolbar(colorScheme),
        ],
      ),
    );
  }

  Widget _buildInputArea(colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
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
        itemCount: _uploadedMedias.length < _maxImageCount
            ? _uploadedMedias.length + 1
            : _uploadedMedias.length,
        itemBuilder: (context, index) {
          if (index < _uploadedMedias.length) {
            return _buildImagePreviewItem(index);
          } else {
            return _buildAppendButton();
          }
        },
      ),
    );
  }

  Widget _buildImagePreviewItem(int index) {
    final media = _uploadedMedias[index];
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 8),
          child: GestureDetector(
            onTap: () {
              showFlanImagePreview(
                context,
                images: _uploadedMedias.map((item) => item.url).toList(),
                startPosition: index,
                loop: false,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                media.url,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () => setState(() => _uploadedMedias.removeAt(index)),
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
          if (widget.isReply)
            GestureDetector(
              onTap: () => setState(() => _isAnonymous = !_isAnonymous),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _isAnonymous,
                    activeColor: colorScheme.primary,
                    visualDensity: VisualDensity.compact,
                    onChanged: (val) {
                      setState(() => _isAnonymous = val ?? false);
                    },
                  ),
                  const Text('匿名',
                      style: TextStyle(color: Colors.black54, fontSize: 14)),
                ],
              ),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: _canSend
                ? () {
                    widget.onSend(
                        _controller.text, _uploadedMedias, _isAnonymous);
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
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
