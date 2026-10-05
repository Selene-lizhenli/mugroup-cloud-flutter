import 'package:cloud/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 在子组件上叠加用户信息水印（user.name + user.jobNumber）
class WatermarkWrapper extends ConsumerWidget {
  const WatermarkWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final watermarkText = _buildWatermarkText(user?.name, user?.jobNumber);

    return Stack(
      children: [
        child,
        if (watermarkText != null && watermarkText.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: _WatermarkPainter(text: watermarkText),
            ),
          ),
      ],
    );
  }

  static String? _buildWatermarkText(String? name, String? jobNumber) {
    final parts = <String>[];
    if (name != null && name.isNotEmpty) parts.add(name);
    if (jobNumber != null && jobNumber.isNotEmpty) parts.add(jobNumber);
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

class _WatermarkPainter extends StatelessWidget {
  const _WatermarkPainter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _WatermarkCustomPainter(text: text),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }
}

class _WatermarkCustomPainter extends CustomPainter {
  _WatermarkCustomPainter({required this.text});

  final String text;

  static const double _spacing = 180;
  static const double _fontSize = 12;
  static const double _angle = -0.25; // 约 -15 度

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(text: text, style: textSpanStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(_angle);
    canvas.translate(-size.width / 2, -size.height / 2);

    final stepX = _spacing;
    final stepY = _spacing * 0.8;
    final startX = -size.width;
    final startY = -size.height;

    for (double y = startY; y < size.height * 2; y += stepY) {
      for (double x = startX; x < size.width * 2; x += stepX) {
        textPainter.paint(canvas, Offset(x, y));
      }
    }

    canvas.restore();
  }

  TextStyle get textSpanStyle => const TextStyle(
        color: Color(0x1A000000),
        fontSize: _fontSize,
        fontWeight: FontWeight.w400,
      );

  @override
  bool shouldRepaint(covariant _WatermarkCustomPainter oldDelegate) {
    return oldDelegate.text != text;
  }
}
