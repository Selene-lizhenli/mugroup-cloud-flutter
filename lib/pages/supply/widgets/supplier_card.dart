import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';

class SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback? onClick;

  const SupplierCard({
    super.key,
    required this.supplier,
    this.onClick,
  });

  Widget _buildTagChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCore = supplier.isCore ?? false;
    final bool canBill = supplier.canBill ?? false;
    final shippingAmount = supplier.shippingAmount;

    String locationText = '';
    if (supplier.city?.isNotEmpty ?? false) {
      locationText = supplier.city!;
      if (supplier.province?.isNotEmpty ?? false) {
        locationText += ' · ${supplier.province}';
      }
    } else if (supplier.province?.isNotEmpty ?? false) {
      locationText = supplier.province!;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (context.mounted) {
            context.router.push(SupplySupplierDetailRoute(id: supplier.id!));
          }
          onClick?.call();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      (supplier.name ?? supplier.shortName) ?? '无名称',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (supplier.supplierNo != null &&
                      supplier.supplierNo!.isNotEmpty)
                    Text(
                      '#${supplier.supplierNo}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontFamily: "monospace",
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (locationText.isNotEmpty) ...[
                    Icon(Icons.location_on_outlined,
                        size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 2),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(
                        locationText,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (shippingAmount != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Container(
                            width: 1, height: 10, color: Colors.grey.shade300),
                      ),
                  ],
                  if (shippingAmount != null) ...[
                    Expanded(
                      child: Row(children: [
                        Text(
                          '出货总额: ',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
                        ),
                        Expanded(
                          child: Text(
                            shippingAmount,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ]),
                    ),
                  ],
                ],
              ),
              if (supplier.businessScope != null &&
                  supplier.businessScope!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        supplier.businessScope!,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
              if (isCore || canBill) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: [
                    if (isCore)
                      _buildTagChip(Icons.star, '核心', Colors.red.shade700),
                    if (canBill)
                      _buildTagChip(
                          Icons.receipt_long, '可开票', Colors.green.shade700)
                    else
                      _buildTagChip(
                          Icons.receipt_long, '不可开票', Colors.grey.shade500),
                    if (!isCore)
                      _buildTagChip(
                          Icons.store, '普通', Colors.blueGrey.shade600),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
