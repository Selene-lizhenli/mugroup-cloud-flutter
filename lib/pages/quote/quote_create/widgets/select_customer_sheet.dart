import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectCustomerSheet extends ConsumerWidget {
  const SelectCustomerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteCreateProvider);
    final notifier = ref.read(quoteCreateProvider.notifier);

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
                  '选择客户',
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
              onChanged: notifier.setCustomerKeyword,
              decoration: InputDecoration(
                hintText: '搜索客户',
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
            // const SizedBox(height: 12),
            // _createCustomer(context),
            const SizedBox(height: 12),
            Expanded(
              child: _list(
                context,
                state.filteredCustomers,
                state.selectedCustomers.isNotEmpty
                    ? state.selectedCustomers.first
                    : null,
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
    List<String> list,
    String? selected,
    notifier,
  ) {
    if (list.isEmpty) {
      return const Center(child: Text('暂无客户'));
    }

    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final item = list[index];
        final isSelected = item == selected;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(item),
          trailing:
              isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
          onTap: () {
            notifier.selectCustomerFromList(item);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
