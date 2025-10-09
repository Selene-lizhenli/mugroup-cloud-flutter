import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeAppBar extends HookConsumerWidget {
  const HomeAppBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);

    return Container(
      height: 100,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  home.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("样品1"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  home.pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("供应商"),
                ),
              ),
            ],
          ),
        ],
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
