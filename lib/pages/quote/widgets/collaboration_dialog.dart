import 'package:cloud/models/user.dart';
import 'package:cloud/pages/quote/providers/quote_detail_provider.dart';
import 'package:cloud/services/tenant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollaborationBottomSheet extends HookConsumerWidget {
  final int quoteId;

  const CollaborationBottomSheet({super.key, required this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(quoteDetailProvider(quoteId));
    final notifier = ref.read(quoteDetailProvider(quoteId).notifier);

    final searchController = useTextEditingController();
    useListenable(searchController);

    final searchResults = useState<List<User>>([]);
    final isSearching = useState(false);

    Future<void> handleSearch() async {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        searchResults.value = [];
        return;
      }

      isSearching.value = true;
      try {
        final result =
            await fetchCurrentUsers(queryParameters: {"search": query});

        searchResults.value = result ?? [];
      } finally {
        isSearching.value = false;
      }
    }

    useEffect(() {
      if (searchController.text.isEmpty) {
        searchResults.value = [];
      }
      return null;
    }, [searchController.text]);

    final currentCollaborators = quoteAsync.value?.collaborators ?? [];
    final bool hasSearchText = searchController.text.trim().isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F3F5),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    ),
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => handleSearch(),
                      decoration: InputDecoration(
                        hintText: '搜索姓名/工号',
                        hintStyle: const TextStyle(
                            color: Color(0xFFC9CDD4), fontSize: 14),
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFFC9CDD4)),
                        suffixIcon: hasSearchText
                            ? IconButton(
                                icon: const Icon(Icons.cancel,
                                    color: Colors.grey, size: 18),
                                onPressed: () {
                                  searchController.clear();
                                  searchResults.value = [];

                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        isDense: true,
                      ),
                    ),
                  ),
                ), 
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: hasSearchText ? handleSearch : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D66D6),
                      disabledBackgroundColor: const Color(0xFFE5E6EB),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: const RoundedRectangleBorder( 
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)), 
                      ),
                    ),
                    child: Text(
                      '搜索',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: hasSearchText
                            ? Colors.white
                            : const Color(0xFF86909C),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasSearchText) ...[
            _buildSectionHeader('搜索结果'),
            Flexible(
              flex: 1,
              child: _buildUserList(
                users: searchResults.value,
                isLoading: isSearching.value,
                emptyText: '未找到相关用户',
                actionType: ActionType.add,
                onAction: (user) async {
                  final exists =
                      currentCollaborators.any((u) => u.id == user.id);
                  if (exists) {
                    EasyLoading.showToast('该用户已在协作列表中');
                    return;
                  }
                  await notifier.addCollaborator(user);
                  EasyLoading.showSuccess('添加成功');
                },
              ),
            ),
          ],
          _buildSectionHeader('已协作用户 (${currentCollaborators.length})'),
          Expanded(
            flex: 2,
            child: _buildUserList(
              users: currentCollaborators,
              isLoading: quoteAsync.isLoading,
              emptyText: '暂无协作人员',
              actionType: ActionType.remove,
              onAction: (user) async {
                await notifier.removeCollaborator(user);
                EasyLoading.showSuccess('移除成功');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFF7F8FA),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Color(0xFF86909C)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '添加协作成员',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildUserList({
    required List<User> users,
    required bool isLoading,
    required String emptyText,
    required ActionType actionType,
    required Function(User) onAction,
  }) {
    if (isLoading) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(strokeWidth: 2),
      ));
    }

    if (users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(emptyText, style: const TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: users.length,
      separatorBuilder: (c, i) =>
          const Divider(height: 1, indent: 66, color: Color(0xFFF2F3F5)),
      itemBuilder: (context, index) {
        final user = users[index];
        final isAdd = actionType == ActionType.add;

        return InkWell(
          onTap: () => onAction(user),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF3D66D6),
                  child: Text(
                    user.name?.substring(0, 1) ?? "U",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? "未知",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1D2129),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onAction(user),
                  icon: isAdd
                      ? const Icon(Icons.add,
                          color: Color(0xFF3D66D6), size: 24)
                      : const Icon(Icons.delete_outline,
                          color: Color(0xFFF53F3F), size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum ActionType { add, remove }
