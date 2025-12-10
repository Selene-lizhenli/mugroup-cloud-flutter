import 'package:flutter/material.dart';

class HomeTabButton extends StatelessWidget {
  final String title;
  final int index;
  final ValueNotifier<int> tabIndex;
  final VoidCallback onTap;

  const HomeTabButton({
    super.key,
    required this.title,
    required this.index,
    required this.tabIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = tabIndex.value == index;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? colorScheme.onPrimary : colorScheme.onPrimary,
                fontSize: isActive ? 17 : 14,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 底部小横线
          AnimatedContainer(
            duration: const Duration(milliseconds: 0),
            margin: const EdgeInsets.only(top: 1),
            height: isActive ? 2 : 0,
            width: isActive
                ? index == 0
                    ? 24
                    : 48
                : 0, // 控制短横线长度
            color: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
