import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/samples/samples_list_page.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/theme/color.dart';
import 'package:flutter/material.dart';

class EntryGridModule extends StatelessWidget {
  const EntryGridModule({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: [
          _EntryItem(
            icon: Icons.inventory_2,
            label: '样品间',
            route: const SamplesRoute(),
            color: colorScheme.primary,
          ),
          _EntryItem(
            icon: Icons.store,
            label: '市场带客',
            route: const QuoteRoute(),
            color: colorScheme.primary,
          ),
          _EntryItem(
            icon: Icons.factory,
            label: '验货',
            route: const InspectionRoute(),
            color: colorScheme.primary,
          ),
          _EntryItem(
            icon: Icons.people,
            label: '客户',
            route: const CrmCompanyRoute(),
            color: colorScheme.primary,
          ),
          _EntryItem(
            icon: Icons.factory,
            label: '供应商',
            route: const SupplySupplierRoute(),
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _EntryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final route;

  const _EntryItem({
    required this.icon,
    required this.label,
    required this.color,
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.07),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 62,
            height: 44,
            child: Icon(
              icon,
              size:32,
              color: color,
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
