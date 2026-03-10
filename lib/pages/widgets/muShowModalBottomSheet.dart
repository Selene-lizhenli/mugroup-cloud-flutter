import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class _MeasureSize extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onChange;

  const _MeasureSize({
    required this.onChange,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMeasureSize(onChange);
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  Size? _oldSize;
  final ValueChanged<Size> _onChange;

  _RenderMeasureSize(this._onChange);

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size;
    if (newSize == null) return;
    if (_oldSize == newSize) return;
    _oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onChange(newSize);
    });
  }
}

class _MuSheetWithAwning extends StatefulWidget {
  final ColorScheme colorScheme;
  final Widget content;
  final double sheetMaxHeight;
  final bool? noBorder;

  const _MuSheetWithAwning({
    required this.colorScheme,
    required this.content,
    required this.sheetMaxHeight,
    this.noBorder = false,
  });
  @override
  State<_MuSheetWithAwning> createState() => _MuSheetWithAwningState();
}

class _MuSheetWithAwningState extends State<_MuSheetWithAwning> {
  double? _awningHeight;

  @override
  Widget build(BuildContext context) {
    final noBorder = widget.noBorder;
    final colorScheme = Theme.of(context).colorScheme;
    final sheetMaxHeight = widget.sheetMaxHeight;
    final content = widget.content;

    final dy = _awningHeight == null
        ? -40.0
        : -(_awningHeight! - 5).clamp(0.0, double.infinity).toDouble();
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(maxHeight: sheetMaxHeight),
          child: Container(
            decoration: BoxDecoration(
              border: noBorder == true
                  ? const Border()
                  : Border(
                      bottom: BorderSide(color: colorScheme.primary, width: 10),
                      right: const BorderSide(
                          color: Colors.transparent, width: 10),
                      left: const BorderSide(
                          color: Colors.transparent, width: 10),
                    ),
              color: const Color.fromARGB(255, 253, 250, 243),
            ),
            child: content,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: _MeasureSize(
              onChange: (size) {
                if (!mounted) return;
                if (_awningHeight == size.height) return;
                setState(() => _awningHeight = size.height);
              },
              child: Image.asset(
                'assets/element/awning.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 统一的底部弹窗样式封装
/// 参考 showModalBottomSheet 用法
Future<T?> muShowModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext sheetContext) builder,
  bool isScrollControlled = true,
  Color? backgroundColor,
  double? maxHeightRatio,
  double? maxHeight,
  bool? noBorder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor ?? Colors.transparent,
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width,
    ),
    builder: (sheetContext) {
      final colorScheme = Theme.of(sheetContext).colorScheme;
      Widget content = builder(sheetContext);
      final sheetMaxHeight = maxHeight ??
          (maxHeightRatio != null
              ? MediaQuery.of(sheetContext).size.height * maxHeightRatio
              : MediaQuery.of(sheetContext).size.height);
      if (maxHeightRatio != null) {
        final maxHeight =
            MediaQuery.of(sheetContext).size.height * maxHeightRatio;
        content = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: content,
        );
      }
      return _MuSheetWithAwning(
        colorScheme: colorScheme,
        content: content,
        sheetMaxHeight: sheetMaxHeight,
        noBorder: noBorder,
      );
    },
  );
}
