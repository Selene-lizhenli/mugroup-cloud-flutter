import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/advice_collect/provider/provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchArea extends HookConsumerWidget {
  const SearchArea({super.key});

  static const int _minLines = 2;
  static const int _maxLines = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adviceCollectProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final lineCount = useState(_minLines);
    final contentController = useTextEditingController();
    Widget getInputArea() {
      return Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                minLines: lineCount.value,
                maxLines: lineCount.value,
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: '发送你的建议...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  alignLabelWithHint: true,
                ),
                onChanged: notifier.setSearchKeyword,
                onSubmitted: (_) async {
                  final content = contentController.text.trim();
                  if (content.isEmpty) return;
                  try {
                    await notifier.sendMyAdvice({
                      'anonymous': false,
                      'content': content,
                    });
                    EasyLoading.showSuccess('提交成功！');
                    context.router.push(const MyAdviceRoute());
                    contentController.clear();
                  } catch (e) {
                    EasyLoading.showError('提交失败');
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(
                lineCount.value > _minLines
                    ? Icons.close_fullscreen
                    : Icons.open_in_full,
                size: 20,
                color: Colors.grey.shade600,
              ),
              tooltip: lineCount.value > _minLines ? '缩小' : '放大',
              onPressed: () {
                lineCount.value =
                    lineCount.value > _minLines ? _minLines : _maxLines;
              },
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(36, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: colorScheme.primary, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [getInputArea()]),
        ],
      ),
    );
  }
}
