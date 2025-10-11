import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

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
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: statusBarHeight + 80,
      color: colorScheme.primary,
      child: Column(
        children: [
          SizedBox(
            height: statusBarHeight,
          ),
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
          const SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity, // 占满父级宽度
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFF03380),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text("12"),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.camera,
                        size: 30, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      final AssetEntity? entity =
                          await CameraPicker.pickFromCamera(context);

                      logger.d(entity);
                    },
                  ),
                ),
                Container(
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 0.8,
                  height: 20,
                ),
                const Text(
                  "搜索",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFF03380),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HomeAppBarPlaceholder extends StatelessWidget {
  const HomeAppBarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: statusBarHeight + 80,
    );
  }
}
