import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/my/widgets/user_info.dart';
import 'package:cloud/pages/my/widgets/user_operator.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/theme_provider.dart'; 
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final colorScheme = Theme.of(context).colorScheme;
    final themeType = ref.watch(appThemeProvider);
    final kaiyuerenImage = themeType == ThemeType.pink
        ? 'assets/theme/kaiyueren_yuqiuyu_pink.png'
        : 'assets/theme/kaiyueren_yuqiuyu_blue.png';

    final backgrundBottomImage = themeType == ThemeType.pink
        ? 'assets/theme/column_chart_blue.png'
        : 'assets/theme/column_chart_pink.png';

    return Scaffold(
      backgroundColor: colorScheme.primary.withOpacity(0.9),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Image.asset(
          kaiyuerenImage,
          width: 65,
          fit: BoxFit.contain,
        ),
        leading: IconButton(
            onPressed: () {
              context.router.maybePop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: colorScheme.tertiary,
            )),
      ),
 
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgrundBottomImage,
            fit: BoxFit.fitWidth,
            width: 100,
            alignment: Alignment.bottomRight,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UserInfoHeader(user: user, colorScheme: colorScheme),
                    const UserOperatorSection(),
                  ],
                ),
              ), 
            ),
          ),
        ],
      ),
    );
  }
}
