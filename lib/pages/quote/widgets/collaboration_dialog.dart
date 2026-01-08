import 'package:cloud/models/user.dart';
import 'package:cloud/pages/quote/providers/quote_detail_provider.dart';
import 'package:cloud/services/tenant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollaborationDialog extends HookConsumerWidget {
  final int quoteId;

  const CollaborationDialog({super.key, required this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 监听 Provider 数据
    final quoteAsync = ref.watch(quoteDetailProvider(quoteId));
    final notifier = ref.read(quoteDetailProvider(quoteId).notifier);

    // 2. 本地搜索状态
    final searchController = useTextEditingController();
    useListenable(searchController);

    final searchResults = useState<List<User>>([]);
    final isSearching = useState(false);
    final hasSearched = useState(false);

    final showSearchResults = useState(false);

    useEffect(() {
      void listener() {
        if (showSearchResults.value) {
          showSearchResults.value = false;
        }
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    Future<void> handleSearch() async {
      final query = searchController.text.trim();
      if (query.isEmpty) return;

      isSearching.value = true;
      hasSearched.value = true;

      showSearchResults.value = true;

      try {
        final result = await fetchCurrentUsers(queryParameters: {
          "search": query,
        });
        searchResults.value = result ?? [];
      } catch (e) {
        searchResults.value = [];
      } finally {
        isSearching.value = false;
      }
    }

    final bool isSearchMode = showSearchResults.value;

    final currentCollaborators = quoteAsync.value?.collaborators ?? [];
    final bool isProviderLoading = quoteAsync.isLoading;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('协作分享',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: searchController,
                        onSubmitted: (_) => handleSearch(),
                        decoration: const InputDecoration(
                          hintText: '搜索用户姓名',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: (isSearching.value ||
                              searchController.text.trim().isEmpty)
                          ? null
                          : handleSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D66D6),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: isSearching.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF5F5F5),
              child: Text(
                isSearchMode ? '搜索结果' : '已协作用户',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
            Expanded(
              child: isSearchMode
                  ? _buildUserList(
                      users: searchResults.value,
                      isLoading: isSearching.value,
                      emptyText: hasSearched.value ? '未找到相关用户' : '请输入关键词搜索',
                      actionText: '添加',
                      isDestructive: false,
                      isActionLoading: isProviderLoading,
                      onAction: (user) async {
                        await notifier.addCollaborator(user);
                        EasyLoading.showSuccess('添加成功');
                      },
                    )
                  : _buildUserList(
                      users: currentCollaborators,
                      isLoading: false,
                      emptyText: '暂无协作用户',
                      actionText: '移除',
                      isDestructive: true,
                      isActionLoading: isProviderLoading,
                      onAction: (user) async {
                        await notifier.removeCollaborator(user);
                        EasyLoading.showSuccess('移除成功');
                      },
                    ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF5F5F5),
              child: Text(
                '已协作用户 (${currentCollaborators.length})',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList({
    required List<User> users,
    required bool isLoading,
    required String emptyText,
    required String actionText,
    required bool isDestructive,
    required Function(User) onAction,
    required bool isActionLoading,
  }) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text(emptyText, style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                isDestructive ? Colors.grey[200] : Colors.blue[100],
            child: Text(
              user.name?.substring(0, 1) ?? "U",
              style:
                  TextStyle(color: isDestructive ? Colors.grey : Colors.blue),
            ),
          ),
          title: Text(user.name ?? ""),
          trailing: TextButton(
            onPressed: isActionLoading ? null : () => onAction(user),
            child: Text(
              actionText,
              style: TextStyle(
                  color: isDestructive ? Colors.red : const Color(0xFF3D66D6)),
            ),
          ),
        );
      },
    );
  }
}
