import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
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

    final bottomPadding = MediaQuery.of(context).padding.bottom;

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

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
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
            onChanged: (_) => loadContacts(),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => loadContacts(),
            decoration: InputDecoration(
              hintText: '请输入关键字搜索',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        searchController.clear();
                        loadContacts();
                      },
                    )
                  : null,
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  Widget _list(
    BuildContext context,
    List<Contact> list,
    Contact? selected,
    bool isLoading,
    dynamic notifier,
  ) {
    if (companyId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            const Text(
              '请先选择客户',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const Center(child: MuProgressIndicator());
    }

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              '暂无联系人',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final item = list[index];
        final isSelected = item.id == selected?.id;
        final name = item.name ?? "未知";

        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.zero,
          title: Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.black87,
            ),
          ),
          subtitle: item.telNumber != null && item.telNumber!.isNotEmpty
              ? Text(
                  item.telNumber!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              : null,
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.blue, size: 18)
              : null,
          onTap: () {
            notifier.setSelectedContact(item);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
