import 'package:cloud/pages/dashboard/dashboard_l10n_helper.dart';
import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';
import 'package:flutter/material.dart';

class DashboardTimeDimensionMenu extends StatelessWidget {
  final TimeDimension currentDimension;
  final ValueChanged<TimeDimension> onSelected;

  const DashboardTimeDimensionMenu({
    super.key,
    required this.currentDimension,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.tune,
        size: 20,
        color: Colors.grey.shade600,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      offset: const Offset(-10, 45),
      itemBuilder: (BuildContext context) {
        return TimeDimension.values.map((dimension) {
          final isSelected = currentDimension == dimension;
          return PopupMenuItem<String>(
            value: dashboardTimeDimensionMenuValue(dimension),
            child: Row(
              children: [
                Icon(
                  dimension == TimeDimension.allTime
                      ? Icons.all_inclusive
                      : Icons.access_time,
                  size: 18,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  context.dashboardTimeDimensionLabel(dimension),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (String value) {
        final dimension = dashboardTimeDimensionFromMenuValue(value);
        if (dimension != null) {
          onSelected(dimension);
        }
      },
    );
  }
}
