import 'package:cloud/models/warehouse/warehouse_receipt_item.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item_entry.dart';
import 'package:flutter/material.dart';

/// Aggregated entry status for a receipt item, shared by the list card and the
/// detail summary so the labels/colors never diverge.
enum ReceiptEntryStatus { none, pre, partial, full, over }

class ReceiptStatusInfo {
  final ReceiptEntryStatus status;
  final String label;
  final Color bg;
  final Color fg;

  /// Total entered cartons across completed (已入库) entries.
  final num enteredQty;

  /// Planned cartons from the item, when known.
  final int? plannedQty;

  const ReceiptStatusInfo({
    required this.status,
    required this.label,
    required this.bg,
    required this.fg,
    required this.enteredQty,
    required this.plannedQty,
  });

  bool get isEntered =>
      status == ReceiptEntryStatus.partial ||
      status == ReceiptEntryStatus.full ||
      status == ReceiptEntryStatus.over;
}

ReceiptStatusInfo receiptItemStatus(
  WarehouseReceiptItem item,
  List<WarehouseReceiptItemEntry> entries,
) {
  final completed = entries.where((e) => e.enteredAt != null).toList();
  final preCount = entries.length - completed.length;
  final planned = item.cartonQty;
  final enteredQty =
      completed.fold<num>(0, (sum, e) => sum + (e.actualCartonQty ?? 0));

  if (completed.isEmpty) {
    if (preCount > 0) {
      return ReceiptStatusInfo(
        status: ReceiptEntryStatus.pre,
        label: '预入库',
        bg: const Color(0xFFE3F2FD),
        fg: const Color(0xFF1565C0),
        enteredQty: enteredQty,
        plannedQty: planned,
      );
    }
    return ReceiptStatusInfo(
      status: ReceiptEntryStatus.none,
      label: '未入库',
      bg: const Color(0xFFF4F5F7),
      fg: Colors.grey.shade600,
      enteredQty: enteredQty,
      plannedQty: planned,
    );
  }

  if (planned != null && planned > 0 && enteredQty < planned) {
    return ReceiptStatusInfo(
      status: ReceiptEntryStatus.partial,
      label: '部分入库',
      bg: const Color(0xFFFFF3E0),
      fg: const Color(0xFFEF6C00),
      enteredQty: enteredQty,
      plannedQty: planned,
    );
  }

  if (planned != null && planned > 0 && enteredQty > planned) {
    return ReceiptStatusInfo(
      status: ReceiptEntryStatus.over,
      label: '超量',
      bg: const Color(0xFFFFEBEE),
      fg: const Color(0xFFC62828),
      enteredQty: enteredQty,
      plannedQty: planned,
    );
  }

  return ReceiptStatusInfo(
    status: ReceiptEntryStatus.full,
    label: '已入库',
    bg: const Color(0xFFE8F5E9),
    fg: const Color(0xFF2E7D32),
    enteredQty: enteredQty,
    plannedQty: planned,
  );
}
