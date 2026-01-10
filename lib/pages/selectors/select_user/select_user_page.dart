import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/pages/selectors/select_user/widgets/user_card.dart';
import 'package:cloud/pages/selectors/select_user/widgets/user_item.dart';
import 'package:cloud/services/tenant.dart';
import 'package:cloud/pages/widgets/search_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SelectUserPage extends HookConsumerWidget {
  const SelectUserPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = useState<List<User>?>(null);
    final isLoading = useState<bool>(false);
    final error = useState<String?>(null);

    final searchText = ref.watch(searchTextProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final debouncedInput =
        useDebounced(searchText, const Duration(milliseconds: 500));

    Future fetchUsers(String? query) async {
      try {
        isLoading.value = true;
        error.value = null;
        final resp = await fetchCurrentUsers(queryParameters: {"search": query});
        users.value = resp;
      } catch (e) {
        error.value = e.toString();
        users.value = [];
      } finally {
        isLoading.value = false;
      }
    }

    // 立即执行搜索（点击搜索按钮时）
    void handleSearch() {
      final query = searchText.trim();
      if (query.isNotEmpty) {
        fetchUsers(query);
      }
    }

    useEffect(() {
      if (debouncedInput != null && debouncedInput.isNotEmpty) {
        fetchUsers(debouncedInput);
      } else {
        users.value = null;
        error.value = null;
      }
      return null;
    }, [debouncedInput]);

    // 页面关闭时清空搜索文本和员工列表
    void clearSearchAndUsers() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchTextProvider.notifier).state = '';
        users.value = null;
        error.value = null;
      });
    }

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          clearSearchAndUsers();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: SearchAppTabbar(onSearch: handleSearch),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              clearSearchAndUsers();
              context.router.maybePop();
            },
          ),
        ),
        body: SafeArea(
          child: _buildBody(
            context,
            users.value,
            isLoading.value,
            error.value,
            colorScheme,
            clearSearchAndUsers,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<User>? users,
    bool isLoading,
    String? error,
    ColorScheme colorScheme,
    VoidCallback clearSearchAndUsers,
  ) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '加载失败',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (users == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '请输入姓名或工号搜索',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 64,
              color: colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '未找到相关用户',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          child: UserItem(
            user: user,
          ),
          onTap: () {
            clearSearchAndUsers();
            context.router.maybePop(user);
          },
        );
      },
    );
  }
}
