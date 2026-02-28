import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/pages/advice_collect/provider/provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/models/advice_collect/advice_collect_item.dart';
import 'package:cloud/pages/advice_collect/widgets/search_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/show_advice_edit_sheet.dart';

@RoutePage()
class AdviceCollectPage extends HookConsumerWidget {
  const AdviceCollectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adviceCollectProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final headerColor = colorScheme.primary.withOpacity(0.2);
    final paddingTop = MediaQuery.of(context).padding.top;
    final notifier = ref.read(adviceCollectProvider.notifier);
    final bookListMyself = state.bookListMyself ?? [];

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.loadBooks();
        notifier.loadBooksMyself();
      });
      return null;
    }, const []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('留言板'),
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(FontAwesomeIcons.user,
                    size: 20, color: Color.fromARGB(255, 119, 78, 47)),
                if (bookListMyself.isNotEmpty)
                  Positioned(
                      left: -12,
                      top: -10,
                      child: _buildBadge(bookListMyself.length)),
              ],
            ),
            onPressed: () => context.router.push(const MyAdviceRoute()),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.7,
                    )!,
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.85,
                    )!,
                    Color.lerp(
                      headerColor,
                      colorScheme.surface,
                      0.92,
                    )!,
                    Color.lerp(
                      colorScheme.surface,
                      colorScheme.surfaceTint,
                      0.6,
                    )!,
                    Color.lerp(
                      colorScheme.surface,
                      colorScheme.surfaceTint,
                      0.9,
                    )!,
                    colorScheme.surfaceTint,
                    colorScheme.surfaceTint,
                    colorScheme.surface,
                  ],
                  stops: null,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: paddingTop + appbarHeight,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: _SearchResultBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1)),
      alignment: Alignment.center,
      child: Text(count > 99 ? '99+' : '$count',
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

class _SearchResultBody extends ConsumerWidget {
  const _SearchResultBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adviceCollectProvider);

    return Column(
      children: [
        const SizedBox(height: 6),
        const SearchArea(),
        const SizedBox(height: 12),
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100), // 为底部留出空间
                  itemCount: state.bookList.length,
                  itemBuilder: (context, index) =>
                      _CommentGroup(book: state.bookList[index]),
                ),
        ),
      ],
    );
  }
}

class _CommentGroup extends ConsumerWidget {
  final AdviceCollectBook book;
  const _CommentGroup({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasReply = book.message != null && book.message!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主留言：点击触发弹窗
        _CommentItem(
          userName: book.user?.name ?? '匿名',
          content: book.content ?? '',
          isReply: false,
          onTap: () {
            showAdviceEditSheet(
              context: context,
              replyToName: book.user?.name ?? '匿名',
              onSend: (content, images) {
                // 调用 notifier 发送回复
                ref.read(adviceCollectProvider.notifier).sendMyAdvice({
                  'parent_id': book.id,
                  'content': content,
                  // 'images': images, // 如果后端支持
                });
              },
            );
          },
        ),
        // 管理员回复
        if (hasReply)
          Padding(
            padding: const EdgeInsets.only(left: 44, top: 4),
            child: Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.5),
                          width: 2))),
              child: _CommentItem(
                userName: book.handler?.name ?? '管理员',
                content: book.message!,
                isReply: true,
                onTap: () {}, // 管理员回复暂不点击或点击查看详情
              ),
            ),
          ),
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  final String userName;
  final String content;
  final bool isReply;
  final VoidCallback onTap;

  const _CommentItem(
      {required this.userName,
      required this.content,
      required this.isReply,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isReply ? 12 : 16,
              backgroundColor: isReply
                  ? colorScheme.secondaryContainer
                  : colorScheme.primaryContainer,
              child: Icon(isReply ? Icons.auto_awesome : Icons.person,
                  size: isReply ? 14 : 18,
                  color: isReply
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(userName,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.outline)),
                      if (!isReply) ...[
                        const SizedBox(width: 8),
                        Text('回复',
                            style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.primary.withOpacity(0.7))),
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isReply
                          ? colorScheme.primaryContainer.withOpacity(0.2)
                          : colorScheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12).copyWith(
                          topLeft: isReply ? null : const Radius.circular(2)),
                    ),
                    child: Text(content,
                        style: const TextStyle(fontSize: 14, height: 1.4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
