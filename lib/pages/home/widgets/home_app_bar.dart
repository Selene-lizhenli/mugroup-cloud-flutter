import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeAppBarItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final bool active;

  const HomeAppBarItem({
    super.key,
    required this.onTap,
    required this.text,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DefaultTextStyle(
        style: active
            ? const TextStyle(fontSize: 18, color: Colors.white)
            : const TextStyle(fontSize: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(text),
        ),
      ),
    );
  }
}

class HomeAppBar extends HookConsumerWidget {
  const HomeAppBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 100,
      color: colorScheme.primary,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                HomeAppBarItem(
                  onTap: () {
                    home.pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                  },
                  text: "样品",
                  active: home.currentPage == 0,
                ),
                HomeAppBarItem(
                  onTap: () {
                    home.pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                  },
                  text: "供应商",
                  active: home.currentPage == 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeAppBarPlaceholder extends StatelessWidget {
  const HomeAppBarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
    );
  }
}
