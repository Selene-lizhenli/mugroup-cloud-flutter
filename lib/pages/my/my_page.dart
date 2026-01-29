import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/my/widgets/user_info.dart';
import 'package:cloud/pages/my/widgets/user_operator.dart';
import 'package:cloud/providers/app_provider.dart';  
import 'package:flutter/material.dart'; 
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Image.asset(
          'assets/mu/kaiyueren.png',
          width: 70,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.03),
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
    );
  }


}
