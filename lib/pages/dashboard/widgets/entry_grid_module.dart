import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EntryGridModule extends StatelessWidget {
  const EntryGridModule({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const int crossAxisCount = 5;
    const double spacing = 6.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth =
              ((constraints.maxWidth - ((crossAxisCount - 1) * spacing)) /
                      crossAxisCount)
                  .floorToDouble();

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              _EntryItem(
                width: itemWidth,
                icon: Icons.inventory_2,
                label: '样品间',
                route: const SamplesListRoute(),
                color: colorScheme.primary,
              ),
              // _EntryItem(
              //   width: itemWidth,
              //   icon: Icons.store,
              //   label: '市场带客',
              //   route: const QuoteRoute(),
              //   color: colorScheme.primary,
              // ),
              _EntryItem(
                width: itemWidth,
                icon: Icons.people,
                label: '客户',
                route: const CrmCompanyRoute(),
                color: colorScheme.primary,
              ),
              _EntryItem(
                width: itemWidth,
                icon: Icons.factory,
                label: '供应商',
                route: const SupplySupplierRoute(),
                color: colorScheme.primary,
              ),
                 _EntryItem(
                width: itemWidth,
                icon: FontAwesomeIcons.fileCircleCheck,
                label: '验货',
                route: const InspectionRoute(),
                color: colorScheme.primary,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EntryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final dynamic route;
  final double width;

  const _EntryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.width,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            context.router.push(route);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
