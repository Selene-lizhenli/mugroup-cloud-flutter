import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/pages/advice_collect/provider/provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/models/advice_collect/advice_collect_item.dart';
import 'package:cloud/pages/advice_collect/widgets/danmaku_area.dart';
import 'package:cloud/pages/advice_collect/widgets/search_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class AdviceCollectPage extends HookConsumerWidget {
  const AdviceCollectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adviceCollectProvider);
    final searchController =
        useTextEditingController(text: state.searchKeyword);
    final colorScheme = Theme.of(context).colorScheme;
    const double gradientAngleDegrees = 0;
    final headerColor = colorScheme.primary.withOpacity(0.2);
    final paddingTop = MediaQuery.of(context).padding.top;
    final notifier = ref.read(adviceCollectProvider.notifier);
    final bookListMyself = state.bookListMyself ?? [];

    useEffect(() {
      if (state.searchKeyword != searchController.text) {
        searchController.text = state.searchKeyword;
      }
      return null;
    }, [state.searchKeyword]);

    useEffect(() {
      // 首次进入时加载留言列表
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
                  const Icon(
                    FontAwesomeIcons.user,
                    size: 20,
                    color: Color.fromARGB(255, 119, 78, 47),
                  ),
                  if (bookListMyself.isNotEmpty)
                    Positioned(
                      left: -12,
                      top: -10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          bookListMyself.length > 99
                              ? '99+'
                              : '${bookListMyself.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            height: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              tooltip: '我的留言',
              onPressed: () {
                context.router.push(const MyAdviceRoute());
              },
            ),
          ],
        ),
        body: Stack(children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: const GradientRotation(
                    gradientAngleDegrees * math.pi / 180,
                  ),
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
          // 最底层：渐变铺满整页
          Positioned.fill(
            left: 0,
            right: 0,
            top: paddingTop + appbarHeight,
            bottom: 0,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child: _SearchResultBody(),
                )),
          ),
        ]));
  }
}

class _SearchResultBody extends ConsumerWidget {
  const _SearchResultBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adviceCollectProvider);
    final notifier = ref.read(adviceCollectProvider.notifier);
    final selectedBook = state.selectedBook;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 有选中项时：在弹幕下方展示该条消息及回复；整体区域可滚动
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DanmakuArea(
                              books: state.bookList,
                              onItemDoubleTap: (book) {
                                notifier.setSelectedBook(book);
                              },
                            ),
                            if (selectedBook != null) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.topCenter,
                                child: _SelectedMessageDetail(
                                  book: selectedBook,
                                  onClose: () => notifier.setSelectedBook(null),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        if (selectedBook == null) ...[
          const SizedBox(height: 12),
          Text('（双击查看留言详细内容）',
              style: TextStyle(fontSize: 11, color: colorScheme.outline)),
          const SizedBox(height: 12),
        ],
        const SearchArea(),
        const SizedBox(height: 35),
      ],
    );
  }
}

/// 在弹幕同位置展示选中的一条留言及回复，点击关闭返回弹幕
class _SelectedMessageDetail extends StatelessWidget {
  const _SelectedMessageDetail({
    required this.book,
    required this.onClose,
  });

  final AdviceCollectBook book;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = book.content ?? '';
    final reply = book.message;
    final hasReply = reply != null && reply.trim().isNotEmpty;
    final userName = book.user?.name?.trim();
    final handlerName = book.handler?.name?.trim();

    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  userName?.isNotEmpty == true ? '$userName' : '匿名',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 内容气泡（左侧，灰色）
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 26,
                  color: colorScheme.outline.withOpacity(0.7),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 12),
            if (handlerName?.isNotEmpty == true) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    handlerName?.isNotEmpty == true ? handlerName! : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            // 回复气泡（右侧，主题色）
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 48,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      hasReply ? reply : '暂无回复',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                hasReply
                    ? Icon(
                        Icons.account_circle,
                        size: 26,
                        color: colorScheme.outline.withOpacity(0.7),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '（点击任意区域关闭）',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
