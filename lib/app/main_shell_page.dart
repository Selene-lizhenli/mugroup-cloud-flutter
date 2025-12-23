import 'package:flutter/material.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 1; // 默认中间“看板”

  final _pages = const [
    Placeholder(color: Colors.red), // 首页
    Placeholder(color: Colors.blue), // 看板
    Placeholder(color: Colors.green), // 假期
    Placeholder(color: Colors.orange), // 我的
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCenterButton(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCenterButton() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF22C3A6),
      elevation: 6,
      onPressed: () {
        // 先留空，下一步再接市场采购
      },
      child: const Icon(Icons.play_arrow_rounded, size: 28),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 64,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _tab(Icons.home_outlined, '首页', 0),
          _tab(Icons.calendar_today_outlined, '考勤', 1),
          const SizedBox(width: 48), // 👈 给中间按钮留坑
          _tab(Icons.beach_access_outlined, '假期', 2),
          _tab(Icons.person_outline, '我的', 3),
        ],
      ),
    );
  }

  Widget _tab(IconData icon, String label, int index) {
    final selected = _index == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() => _index = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: selected ? const Color(0xFF22C3A6) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? const Color(0xFF22C3A6) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
