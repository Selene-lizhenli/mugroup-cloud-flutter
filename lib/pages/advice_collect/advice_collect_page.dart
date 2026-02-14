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
      // 首次进入时加载意见列表
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
          title: const Text('云链里'),
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
              tooltip: '我的意见',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 有选中项时：同位置展示该条消息及回复；否则展示弹幕
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : selectedBook != null
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: _SelectedMessageDetail(
                        book: selectedBook,
                        onClose: () => notifier.setSelectedBook(null),
                      ),
                    )
                  : DanmakuArea(
                      books: state.bookList,
                      onItemDoubleTap: (book) {
                        notifier.setSelectedBook(book);
                      },
                    ),
        ),
        const SearchArea(),
        const SizedBox(height: 35),
      ],
    );
  }
}

/// 在弹幕同位置展示选中的一条意见及回复，点击关闭返回弹幕
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

    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '意见内容',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '回复',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  hasReply ? reply : '暂无回复',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '（点击任意区域关闭）',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
