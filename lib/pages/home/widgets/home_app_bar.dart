import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/widgets/home_media.dart';
import 'package:cloud/services/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  final TextEditingController controller;
  final void Function(String search)? onSearchText;
  final void Function(TemporaryMedia temporaryMedia)? onSearchMedia;
  final void Function(TemporaryMedia temporaryMedia)? onDeleteMedia;

  const HomeAppBar({
    super.key,
    required this.controller,
    this.onSearchText,
    this.onSearchMedia,
    this.onDeleteMedia,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final focusNode = useFocusNode();

    final colorScheme = Theme.of(context).colorScheme;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    handleUploadMedia() async {
      final AssetEntity? entity = await CameraPicker.pickFromCamera(context);

      if (entity == null) {
        return;
      }

      final file = await entity.file;

      final temporaryMedia = await upload(file: file!);

      onSearchMedia?.call(temporaryMedia);
    }

    return Container(
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
          if (home.currentMediaId != null)
            HomeMedia(
              media: home.media,
              onTapUplod: handleUploadMedia,
              currentMediaId: home.currentMediaId!,
              onTapMedia: onSearchMedia,
              onDeleteMedia: onDeleteMedia,
            )
          else
            Container(
              width: double.infinity, // 占满父级宽度
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                  Expanded(
                    child: TextField(
                      autofocus: false,
                      controller: controller,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      focusNode: focusNode,
                      decoration: const InputDecoration.collapsed(
                        hintText: '',
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        onSearchText?.call(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.camera,
                          size: 30, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: handleUploadMedia,
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 0.8,
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      onSearchText?.call(controller.text);
                    },
                    child: const Text(
                      "搜索",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFF03380),
                      ),
                    ),
                  )
                ],
              ),
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
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      height: statusBarHeight + 80,
    );
  }
}
