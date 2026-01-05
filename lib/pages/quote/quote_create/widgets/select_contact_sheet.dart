import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectContactSheet extends HookConsumerWidget {
  final int? companyId;

  const SelectContactSheet({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteCreateProvider);
    final notifier = ref.read(quoteCreateProvider.notifier);

    final contacts = useState<List<Contact>>([]);
    final isLoading = useState<bool>(true);
    final searchController = useTextEditingController();

    Future<void> loadContacts() async {
      if (companyId == null) {
        contacts.value = [];
        isLoading.value = false;
        return;
      }

      isLoading.value = true;
      try {
        final resp = await getCrmContacts(
          queryParameters: {
            'company_id': companyId,
            'search': searchController.text.trim(),
          },
        );
        contacts.value = resp.data;
      } catch (e) {
        contacts.value = [];
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      if (companyId == null) {
        isLoading.value = false;
        contacts.value = [];
        return null;
      }
      loadContacts();
      return null;
    }, [companyId]);

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  '选择联系人',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('关闭'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              onChanged: (_) {
                loadContacts();
              },
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                loadContacts();
              },
              decoration: InputDecoration(
                hintText: '请输入关键字搜索',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _list(
                context,
                contacts.value,
                state.selectedContact,
                isLoading.value,
                notifier,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= list =================

  Widget _list(
    BuildContext context,
    List<Contact> list,
    Contact? selected,
    bool isLoading,
    notifier,
  ) {
    if (companyId == null) {
      return const Center(
        child: Text(
          '请先选择客户',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (list.isEmpty) {
      return const Center(child: Text('暂无联系人'));
    }

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final item = list[index];
        final isSelected = item.id == selected?.id;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(item.name ?? ""),
          subtitle: item.telNumber != null
              ? Text(
                  item.telNumber!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              : null,
          trailing:
              isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
          onTap: () {
            notifier.setSelectedContact(item);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

