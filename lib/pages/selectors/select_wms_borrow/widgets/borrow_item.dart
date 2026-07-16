import 'package:cloud/models/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class BorrowItem extends HookWidget {
  final Borrow borrow;

  final int? count;

  final ValueChanged<int>? onChange;

  const BorrowItem({
    super.key,
    required this.borrow,
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
            height: 85,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  borrow.orderNo ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  style: const TextStyle(fontSize: 14),
                  borrow.warehouse?.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  textBaseline: TextBaseline.ideographic,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      borrow.user?.name ?? "",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                    ),
                    Text(
                      borrow.borrowAt != null
                          ? DateFormat("yyyy-MM-dd HH:mm:ss")
                              .format(borrow.borrowAt!)
                          : "",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
