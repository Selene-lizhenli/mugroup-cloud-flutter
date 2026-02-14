import 'package:cloud/models/advice_collect/advice_collect_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 第 1～4 条消息加载后距离左侧的初始位置（复用轨道时按 i%4 取）
double _initialLeftForIndex(int index, double startX, double screenWidth) {
  switch (index) {
    case 0:
      return startX;
    case 1:
      return startX + (screenWidth - startX) * 0.5;
    case 2:
      return startX + (screenWidth - startX) * 0.75;
    case 3:
      return startX + (screenWidth - startX) * 1;
    default:
      return startX;
  }
}

/// 每条消息可用的淡色透明背景（按索引轮换）
final List<Color> _danmakuBgColors = [
  Colors.blue.withOpacity(0.18),
  Colors.green.withOpacity(0.18),
  Colors.orange.withOpacity(0.18),
  Colors.purple.withOpacity(0.18),
  Colors.teal.withOpacity(0.18),
  Colors.amber.withOpacity(0.18),
  Colors.indigo.withOpacity(0.18),
  Colors.cyan.withOpacity(0.18),
];

/// 意见列表弹幕区域：单击暂停，双击执行外部回调
class DanmakuArea extends HookWidget {
  final List<AdviceCollectBook> books;
  final int laneCount;
  final Duration duration;
  final TextStyle? textStyle;
  final int maxLines;
  final double startPosition;
  /// 双击某条消息时回调，外部可在此设置 provider 的 selectedBook 等
  final void Function(AdviceCollectBook book)? onItemDoubleTap;

  const DanmakuArea({
    super.key,
    required this.books,
    this.laneCount = 4,
    this.duration = const Duration(seconds: 50),
    this.textStyle,
    this.maxLines = 4,
    this.startPosition = 0.5,
    this.onItemDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final ticker = useSingleTickerProvider();
    final controller = useAnimationController(
      duration: duration,
      vsync: ticker,
    );
    final isPaused = useState(false);

    useEffect(() {
      if (isPaused.value) {
        controller.stop();
      } else {
        controller.repeat();
      }
      return null;
    }, [isPaused.value]);

    final style = textStyle ??
        TextStyle(
          color: Colors.black87.withOpacity(0.75),
          fontSize: 13,
          height: 1.4,
        );
    final double laneHeight = 22 * maxLines.toDouble();
    final booksWithContent =
        books.where((b) => (b.content ?? '').trim().isNotEmpty).toList();
    final laneCountClamped = laneCount.clamp(1, 12);
    final numLanes = laneCountClamped;

    if (booksWithContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        const double itemWidth = 250;
        final travelDistance = screenWidth + itemWidth;
        final startX = screenWidth * startPosition;

        // 按顺序算每条初始 left，复用轨道的 = 同轨道前一条当时位置 + 200
        final initialLeftList = <double>[];
        for (var i = 0; i < booksWithContent.length; i++) {
          if (i < numLanes) {
            initialLeftList.add(_initialLeftForIndex(i, startX, screenWidth));
          } else {
            final j = i - numLanes;
            final phaseI =
                (i ~/ numLanes) * 0.25 + (i % numLanes) * 0.06;
            final phaseJ =
                (j ~/ numLanes) * 0.25 + (j % numLanes) * 0.06;
            initialLeftList.add(initialLeftList[j] -
                (phaseI - phaseJ) * travelDistance +
                400);
          }
        }

        return SizedBox(
          height: numLanes * laneHeight,
          width: screenWidth,
          child: ClipRect(
            child: Stack(
              children: List.generate(booksWithContent.length, (i) {
                final book = booksWithContent[i];
                final content = book.content ?? '';
                if (content.isEmpty) return const SizedBox.shrink();

                final laneIndex = i % numLanes;
                final phase = i == 0
                    ? 0.0
                    : (i ~/ numLanes) * 0.25 + (i % numLanes) * 0.06;
                final bgColor = _danmakuBgColors[i % _danmakuBgColors.length];
                final initialLeft = initialLeftList[i];

                return Positioned(
                  top: laneIndex * laneHeight,
                  left: 0,
                  right: 0,
                  height: laneHeight,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, indexChild) {
                      final effectiveValue =
                          (controller.value - phase).clamp(0.0, 1.0);
                      final animatedLeft =
                          initialLeft - effectiveValue * travelDistance;
                      final tappedBook = book;

                      return Transform.translate(
                        offset: Offset(animatedLeft, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              isPaused.value = !isPaused.value;
                            },
                            onDoubleTap: () {
                              onItemDoubleTap?.call(tappedBook);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: itemWidth),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  content,
                                  style: style,
                                  maxLines: maxLines,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
