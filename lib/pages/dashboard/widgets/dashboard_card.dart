import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final Color? background;
  final double height;

  const DashboardCard({
    super.key,
    required this.child,
    this.background,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            if (background != null)
              Positioned.fill(
                child: Container(
                  color: background,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
