import 'package:cloud/models/wms/warehouse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WarehouseItem extends HookWidget {
  final Warehouse warehouse;

  final int? count;

  final ValueChanged<int>? onChange;

  const WarehouseItem({
    super.key,
    required this.warehouse,
    this.count,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceTint,
              border: Border.all(
                color: colorScheme.primary.withRed(89),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        warehouse.name ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.primary.withRed(89),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color.fromARGB(255, 189, 141, 177),
                    ),
                    Expanded(
                      child: Text(
                        warehouse.address ?? "",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 41, 41, 41)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
