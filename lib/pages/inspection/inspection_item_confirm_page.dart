import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;

@RoutePage()
class InspectionItemConfirmPage extends HookConsumerWidget {
  final int id;
  const InspectionItemConfirmPage({super.key, required this.id});

  static const _cBlue = Color(0xFF3B68D8);
  static const _cBg = Color(0xFFF5F6FA);
  static const _cText = Color(0xFF333333);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: const Text('产品验货',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                _InfoCard(blue: _cBlue, text: _cText),
                SizedBox(height: 12),
                _PhotoCard(blue: _cBlue, text: _cText),
                SizedBox(height: 12),
                _NoteCard(blue: _cBlue, text: _cText),
              ],
            ),
          ),
          _buildBottomBtn(),
        ],
      ),
    );
  }

  Widget _buildBottomBtn() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _cBlue,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('完成验货',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ),
      );
}

class _InfoCard extends StatelessWidget {
  final Color blue;
  final Color text;
  const _InfoCard({required this.blue, required this.text});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TitleRow(
                  icon: Icons.store_mall_directory_outlined,
                  title: '产品验货',
                  color: blue,
                  textColor: text),
              Text('SKU: 10908',
                  style: TextStyle(color: blue, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _item('采购箱数', '0', false),
              const SizedBox(width: 8),
              _item('装箱量', '0', false),
              const SizedBox(width: 8),
              _item('总数量', '0', true),
            ],
          )
        ],
      ),
    );
  }

  Widget _item(String k, String v, bool active) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? blue : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$k: ',
                  style: TextStyle(
                      fontSize: 12,
                      color: active ? Colors.white : Colors.grey[600])),
              Text(v,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : Colors.black)),
            ],
          ),
        ),
      );
}

class _PhotoCard extends StatelessWidget {
  final Color blue;
  final Color text;
  const _PhotoCard({required this.blue, required this.text});

  static const _labels = ['正唛', '侧唛', '开箱', '条码标签', '产品重量', '产品主图'];

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          const double spacing = 12.0;

          final double itemSize =
              ((totalWidth - (spacing * 2)) / 3).floorToDouble();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TitleRow(
                      icon: Icons.camera_alt_outlined,
                      title: '验货图片',
                      color: blue,
                      textColor: text),
                  _buildToggle(),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: spacing,
                runSpacing: 16.0,
                children: _labels
                    .map((label) => _buildGridItem(label, itemSize))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('其他验货图片',
                          style: TextStyle(
                              color: text, fontWeight: FontWeight.w500)),
                      const Text('0/50张',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _dashedBox(itemSize, '添加图片', isPlus: true),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridItem(String label, double size) {
    return SizedBox(
      width: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label图片',
            style: TextStyle(
              fontSize: 13,
              color: text,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _dashedBox(size, '点击拍摄$label'),
        ],
      ),
    );
  }

  Widget _dashedBox(double size, String label, {bool isPlus = false}) {
    return CustomPaint(
      painter: _DashRectPainter(color: Colors.grey[300]!),
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isPlus ? Icons.add : Icons.camera_alt_outlined,
                color: Colors.grey[400], size: isPlus ? 28 : 24),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(color: Colors.grey[400], fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() => Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            _toggleItem('直接拍照', true),
            _toggleItem('选择来源', false),
          ],
        ),
      );

  Widget _toggleItem(String txt, bool active) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? blue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (active) const Icon(Icons.check, size: 12, color: Colors.white),
            if (active) const SizedBox(width: 4),
            Text(txt,
                style: TextStyle(
                    fontSize: 12, color: active ? Colors.white : Colors.grey)),
          ],
        ),
      );
}

class _NoteCard extends StatelessWidget {
  final Color blue;
  final Color text;
  const _NoteCard({required this.blue, required this.text});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          _TitleRow(
              icon: Icons.edit_note,
              title: '验货备注',
              color: blue,
              textColor: text),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '请输入验货备注信息（选填）',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: blue)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: child,
      );
}

class _TitleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color textColor;
  const _TitleRow(
      {required this.icon,
      required this.title,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      );
}

class _DashRectPainter extends CustomPainter {
  final Color color;
  _DashRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(4)));

    ui.PathMetrics pathMetrics = path.computeMetrics();
    for (ui.PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        canvas.drawPath(pathMetric.extractPath(distance, distance + 5), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
