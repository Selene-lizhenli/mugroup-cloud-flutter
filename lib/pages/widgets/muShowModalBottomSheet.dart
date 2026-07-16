import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

class _MuSheetWithAwning extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final noBorder = this.noBorder;
    final sheetMaxHeight = this.sheetMaxHeight;
    final content = this.content;
    final awningHeight = useState<double?>(null);

    final themeType = ref.watch(appThemeProvider);
    final backgrundTopImage = themeType == ThemeType.pink
        ? 'assets/theme/awning_pink.png'
        : 'assets/theme/awning_blue.png';

    final dy = awningHeight.value == null
        ? -53.0
        : -(awningHeight.value! - 5).clamp(0.0, double.infinity).toDouble();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 10,
                      ),
                      right: BorderSide(
                          color: Theme.of(context).colorScheme.surface,
                          width: 10),
                      left: BorderSide(
                          color: Theme.of(context).colorScheme.surface,
                          width: 10),
                    ),
              color: themeType == ThemeType.blue
                  ? colorScheme.surface
                  : const Color.fromARGB(255, 253, 250, 243),
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
                if (!context.mounted) return;
                if (awningHeight.value == size.height) return;
                awningHeight.value = size.height;
              },
              child: Image.asset(
                backgrundTopImage,
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
