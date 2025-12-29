import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/samples/samples_list_page.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';

class EntryGridModule extends StatelessWidget {
  const EntryGridModule({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 22, 12, 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ), n
        // ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: const [
          _EntryItem(
            icon: Icons.store,
            label: '市场带客',
            route: MarketProductRoute(),
          ),
          _EntryItem(
            icon: Icons.inventory_2,
            label: '样品间',
            route: SamplesRoute(),
          ),
          _EntryItem(
            icon: Icons.people,
            label: '客户',
            route: CrmCompanyRoute(),
          ),
          _EntryItem(
            icon: Icons.factory,
            label: '供应商',
            route: SupplySupplierRoute(),
          ),
          _EntryItem(
            icon: Icons.factory,
            label: '跟单验货',
            route: InspectionRoute(),
          ),
        ],
      ),
    );
  }
}

class _EntryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final route;

  const _EntryItem({
    required this.icon,
    required this.label,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
