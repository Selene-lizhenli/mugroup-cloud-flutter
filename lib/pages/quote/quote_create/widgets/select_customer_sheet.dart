import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectCustomerSheet extends HookConsumerWidget {
  const SelectCustomerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteCreateProvider);
    final notifier = ref.read(quoteCreateProvider.notifier);
    final l10n = context.l10n;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    useEffect(() {
      notifier.loadCustomers();
      return null;
    }, []);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                onPressed: () =>
                    {notifier.clearCustomerKeyword(), Navigator.pop(context)},
                child: const Text('关闭'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: notifier.setCustomerKeyword,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) {
              notifier.loadCustomers();
            },
            decoration: InputDecoration(
              hintText: '${l10n.enterTheKeyword}...',
              prefixIcon: const Icon(Icons.search),
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
          _buildCreateCustomerCard(context, ref, notifier),
          const SizedBox(height: 12),
          Expanded(
            child: _list(
              context,
              state.customers,
              state.selectedCustomers,
              notifier,
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  Widget _buildCreateCustomerCard(
    BuildContext context,
    WidgetRef ref,
    dynamic notifier,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        final result = await context.router.push<(Company?, Contact?)>(
          const MarketProductCompanyCreateRoute(),
        );  
        if (context.mounted && result != null) {
          final (newCompany, newContact) = result; 
          if (newCompany != null) { 
            notifier.setSelectedCustomer(newCompany); 
            if (newContact != null) {
              notifier.setSelectedContact(newContact);
            } 
            Navigator.pop(context);
          } else { 
            notifier.loadCustomers();
          }
        } else if (context.mounted) { 
          notifier.loadCustomers();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.primary,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '创建新客户',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '添加一个新的客户',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(
    BuildContext context,
    List<Company> list,
    Company? selected,
    dynamic notifier,
  ) {
    if (list.isEmpty) {
      return const Center(child: Text('暂无客户'));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final item = list[index];
        final isSelected = item.id == selected?.id;

        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          minVerticalPadding: 2,
          contentPadding: EdgeInsets.zero,
          title: Text(
            item.name ?? "",
            style: const TextStyle(fontSize: 14),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.blue, size: 20)
              : null,
          onTap: () {
            notifier.setSelectedCustomer(item);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
