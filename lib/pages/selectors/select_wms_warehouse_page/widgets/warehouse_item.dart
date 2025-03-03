import 'package:cloud/models/wms/warehouse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  warehouse.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  warehouse.address ?? "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
