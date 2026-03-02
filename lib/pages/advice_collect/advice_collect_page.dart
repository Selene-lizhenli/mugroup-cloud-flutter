import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/advice_collect/provider/provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/models/advice_collect/advice_collect_item.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/pages/advice_collect/widgets/search_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flant/flant.dart';
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
                    Color.lerp(headerColor, colorScheme.surface, 0.7)!,
                    Color.lerp(headerColor, colorScheme.surface, 0.85)!,
                    Color.lerp(headerColor, colorScheme.surface, 0.92)!,
                    Color.lerp(
                        colorScheme.surface, colorScheme.surfaceTint, 0.6)!,
                    Color.lerp(
                        colorScheme.surface, colorScheme.surfaceTint, 0.9)!,
                    colorScheme.surfaceTint,
                    colorScheme.surfaceTint,
                    colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: paddingTop + kToolbarHeight,
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
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: state.bookList.length,
                  itemBuilder: (context, index) =>
                      _CommentGroup(book: state.bookList[index]),
                ),
        ),
      ],
    );
  }
}

class _CommentGroup extends HookConsumerWidget {
  final AdviceCollectBook book;
  const _CommentGroup({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = useState(false);
    final comments = book.comments ?? [];

    final allComments = book.comments ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 主留言
        _CommentItem(
          userName: book.user?.name ?? '匿名',
          content: book.content ?? '',
          isReply: false,
          onTap: () {
            showAdviceEditSheet(
              context: context,
              replyToName: book.user?.name ?? '匿名',
              onSend: (content, images) {
                ref
                    .read(adviceCollectProvider.notifier)
                    .sendMyComments(book.id!, {
                  'comment': content,
                });

                ref.read(adviceCollectProvider.notifier).loadBooks();
              },
            );
          },
        ),

        // 2. 回复列表 (已去掉管理员回复逻辑)
        if (comments.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero, // 消除 ListView 默认边距
            physics: const NeverScrollableScrollPhysics(),
            itemCount: isExpanded.value ? comments.length : 1,
            itemBuilder: (context, index) {
              final comment = comments[index];

              String? replyTo;
              if (comment.parentId != null) {
                replyTo = allComments
                    .where((c) => c.id == comment.parentId)
                    .firstOrNull
                    ?.user
                    ?.name;
              }
              return _ReplyWrapper(
                child: _CommentItem(
                  userName: comment.user?.name ?? '用户',
                  replyToName: replyTo,
                  content: comment.comment ?? '',
                  attachments: comment.attachments,
                  isReply: true,
                  onTap: () {
                    showAdviceEditSheet(
                      context: context,
                      replyToName: comment.user?.name ?? '匿名',
                      onSend: (content, images) {
                        ref
                            .read(adviceCollectProvider.notifier)
                            .sendMyCommentsComment(comment.id!, {
                          'comment': content,
                        });

                        ref.read(adviceCollectProvider.notifier).loadBooks();
                      },
                    );
                  },
                ),
              );
            },
          ),

          // 3. 展开收起按钮
          if (comments.length > 1)
            Padding(
              padding:
                  const EdgeInsets.only(left: 50, top: 4, bottom: 4), // 紧贴回复
              child: GestureDetector(
                onTap: () => isExpanded.value = !isExpanded.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpanded.value
                          ? '收起回复'
                          : '展开更多 ${comments.length - 1} 条回复',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      isExpanded.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: const Color(0xFFE91E63),
                    ),
                  ],
                ),
              ),
            ),
        ],
        const SizedBox(height: 12), // 每组评论间的间距
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  final String userName;
  final String? replyToName;
  final String content;
  final List<Media>? attachments;
  final bool isReply;
  final VoidCallback onTap;

  const _CommentItem({
    required this.userName,
    this.replyToName,
    required this.content,
    this.attachments,
    required this.isReply,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0), // 再次缩小垂直边距
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像尺寸缩小
            CircleAvatar(
              radius: isReply ? 13 : 15,
              backgroundColor:
                  isReply ? colorScheme.secondary : colorScheme.primary,
              child: Icon(
                isReply ? Icons.person_outline : Icons.person,
                size: isReply ? 15 : 17,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8), // 缩小头像和文字间的距离
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (replyToName != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '回复',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          replyToName!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 1), // 缩小用户名和气泡间的距离
                  // 气泡重新加入，但大幅压缩边距
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      color: isReply
                          ? colorScheme.primary.withOpacity(0.12)
                          : colorScheme.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10).copyWith(
                          topLeft: isReply ? null : const Radius.circular(2)),
                    ),
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14, // 稍微缩小字号
                        height: 1.3,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // 图片展示
                  if (attachments != null && attachments!.isNotEmpty)
                    _ImageGrid(attachments: attachments!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<Media> attachments;
  const _ImageGrid({required this.attachments});

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    final int totalCount = attachments.length;
    final int displayCount = totalCount > 3 ? 3 : totalCount;
    final int remaining = totalCount - 3;
    final List<String> imageUrls = attachments.map((e) => e.url ?? '').toList();

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2), // 调整图片上下间距
      child: LayoutBuilder(builder: (context, constraints) {
        const double spacing = 4.0;
        final double itemSize = (constraints.maxWidth - (spacing * 2)) / 3;

        return Row(
          children: List.generate(displayCount, (index) {
            final isLast = index == 2 && remaining > 0;

            return GestureDetector(
              onTap: () {
                showFlanImagePreview(
                  context,
                  images: imageUrls,
                  startPosition: index,
                  loop: false,
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                    right: index == displayCount - 1 ? 0 : spacing),
                width: itemSize,
                height: itemSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[200]),
                      ),
                      if (isLast)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          alignment: Alignment.center,
                          child: Text(
                            '+${remaining + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

class _ReplyWrapper extends StatelessWidget {
  final Widget child;
  const _ReplyWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 左侧缩进对齐，消除垂直外边距以减小回复间距
      padding: const EdgeInsets.only(left: 38, top: 4, bottom: 0),
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.grey.withOpacity(0.12),
              width: 1.0,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
