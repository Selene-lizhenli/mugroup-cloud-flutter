import 'package:cloud/constants/theme_config.dart';
import 'package:flutter/material.dart';

class CustomScanIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomScanIcon({
    super.key,
    this.size = 40,
    this.color = primaryColorPink,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ScanFramePainter(color: color),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  final Color color;
  final Paint _paint;

  _ScanFramePainter({required this.color})
      : _paint = Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.square;

  @override
  void paint(Canvas canvas, Size size) {
    final double padding = size.width * 0.2; // 四角边距
    final double lineLen = size.width * 0.15; // 四角短线长度
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // 1. 绘制四角（左上、右上、左下、右下）
    // 左上
    canvas.drawLine(Offset(padding, padding), Offset(padding + lineLen, padding), _paint);
    canvas.drawLine(Offset(padding, padding), Offset(padding, padding + lineLen), _paint);
    // 右上
    canvas.drawLine(Offset(size.width - padding, padding), Offset(size.width - padding - lineLen, padding), _paint);
    canvas.drawLine(Offset(size.width - padding, padding), Offset(size.width - padding, padding + lineLen), _paint);
    // 左下
    canvas.drawLine(Offset(padding, size.height - padding), Offset(padding + lineLen, size.height - padding), _paint);
    canvas.drawLine(Offset(padding, size.height - padding), Offset(padding, size.height - padding - lineLen), _paint);
    // 右下
    canvas.drawLine(Offset(size.width - padding, size.height - padding), Offset(size.width - padding - lineLen, size.height - padding), _paint);
    canvas.drawLine(Offset(size.width - padding, size.height - padding), Offset(size.width - padding, size.height - padding - lineLen), _paint);

    // 2. 绘制中间横线（完全匹配原图）
    canvas.drawLine(
      Offset(padding, centerY),
      Offset(size.width - padding, centerY),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// 使用示例：const CustomScanIcon(size: 60, color: Colors.black)