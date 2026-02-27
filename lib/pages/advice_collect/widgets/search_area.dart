import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/advice_collect/provider/provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchArea extends HookConsumerWidget {
  const SearchArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adviceCollectProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final contentController = useTextEditingController();

    Future<void> doSend() async {
      final content = contentController.text.trim();
      if (content.isEmpty) return;
      try {
        await notifier.sendMyAdvice({
          'anonymous': false,
          'content': content,
        });
        EasyLoading.showSuccess('发送成功！');
        if (context.mounted) context.router.push(const MyAdviceRoute());
        contentController.clear();
      } catch (e) {
        EasyLoading.showError('发送失败');
      }
    }

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border:
            Border.all(color: colorScheme.primary.withOpacity(0.3), width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: contentController,
              maxLines: 1,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: '想说什么尽管说...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: notifier.setSearchKeyword,
              onSubmitted: (_) => doSend(),
              textInputAction: TextInputAction.send,
            ),
          ),
          TextButton(
            onPressed: doSend,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '发送',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
