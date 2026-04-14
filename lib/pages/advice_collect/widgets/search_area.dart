import 'package:cloud/pages/advice_collect/provider/provider.dart';
import 'package:cloud/pages/advice_collect/widgets/show_advice_edit_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchArea extends HookConsumerWidget {
  const SearchArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adviceCollectProvider.notifier);

    return GestureDetector(
      onTap: () => showAdviceEditSheet(
        context: context,
        isReply: true,
        onSend: (content, images, isAnonymous) {
          notifier.sendMyAdvice({
            'anonymous': isAnonymous,
            'content': content,
            'attachments': images
          });

          ref.read(adviceCollectProvider.notifier).loadBooks();
        },
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Text('想说什么尽管说...',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            Spacer(),
            Icon(Icons.image_outlined, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
