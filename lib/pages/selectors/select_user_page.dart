import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/pages/selectors/widgets/user_card.dart';
import 'package:cloud/pages/selectors/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class SelectUserPage extends HookConsumerWidget {
  const SelectUserPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = useState<List<User>?>([]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('用户选择'),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                MultiSliver(children: [
                  Column(
                    children: users.value
                            ?.map((userItem) => InkWell(
                                  child: UserCard(
                                    child: UserItem(
                                      user: userItem,
                                    ),
                                  ),
                                  onTap: () =>
                                      {context.router.maybePop(userItem)},
                                ))
                            .toList() ??
                        [],
                  )
                ])
              ],
            ),
          )
        ]),
      ),
    );
  }
}
