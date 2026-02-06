import 'package:flutter/material.dart';

class MuProgressIndicator extends StatefulWidget {
  final Duration duration;
  final double barWidth;
  final double barSpacing;
  final double maxHeight;
  final double minHeightRatio;
  final String? text;
  final bool? showText;
  final Color? textColor;
  final double? fontSize;

  const MuProgressIndicator({
    super.key,
    this.duration = const Duration(milliseconds: 800),
    this.barWidth = 6.0,
    this.barSpacing = 2.0,
    this.maxHeight = 24.0,
    this.minHeightRatio = 0.3,
    this.text,
    this.showText,
    this.textColor,
    this.fontSize,
  });

  @override
  State<MuProgressIndicator> createState() => _MuProgressIndicatorState();
}

class _MuProgressIndicatorState extends State<MuProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.maxHeight,
            maxWidth: (widget.barWidth + (widget.barSpacing * 2)) * 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (index) {
              final baseRatios = [0.4, 0.7, 1.0, 0.7, 0.4];
              final color =
                  index % 2 == 0 ? colorScheme.primary : colorScheme.secondary;

              final animation = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  (index * 0.1).clamp(0.0, 0.5),
                  (index * 0.1 + 0.5).clamp(0.0, 1.0),
                  curve: Curves.easeInOut,
                ),
              );

              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  double animatedHeight = widget.maxHeight *
                      baseRatios[index] *
                      (widget.minHeightRatio +
                          (1 - widget.minHeightRatio) * animation.value);

                  return Container(
                    width: widget.barWidth,
                    height: animatedHeight,
                    margin:
                        EdgeInsets.symmetric(horizontal: widget.barSpacing / 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(widget.barWidth / 2),
                    ),
                  );
                },
              );
            }),
          ),
        ),
        if (widget.showText == true) ...[
          const SizedBox(height: 4),
          Text(
            widget.text ?? '加载中...',
            style: TextStyle(
              fontSize: widget.fontSize ?? 10.0,
              color: widget.textColor ?? colorScheme.onSurface,
            ),
          ),
        ]
      ],
    );
  }
}
