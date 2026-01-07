import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/contact.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Contact? mainContact = supplier.contacts?.first;

    final bool isCore = supplier.isCore ?? false;
    final bool canBill = supplier.canBill ?? false;
    final shippingAmount = supplier.shippingAmount;

    return InkWell(
      onTap: () {
        if (context.mounted) {
          context.router.push(SupplySupplierDetailRoute(id: supplier.id!));

          return;
        }
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade100, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 卡片主体
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    (supplier.name ?? supplier.shortName) ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (supplier.supplierNo != '')
                    Row(
                      children: [
                        const Icon(Icons.numbers, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          supplier.supplierNo ?? '暂无',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  if ((supplier.city?.isNotEmpty ?? false) ||
                      (supplier.province?.isNotEmpty ?? false))
                    Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: Colors.grey),
                        if (supplier.city?.isNotEmpty ?? false)
                          Text(
                            supplier.city!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        if (supplier.province?.isNotEmpty ?? false)
                          Text(
                            (supplier.city?.isNotEmpty ?? false)
                                ? ' · ${supplier.province}'
                                : '${supplier.province}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  if (mainContact != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outline,
                                  size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '联系人: ${mainContact.name ?? '暂无'}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.phone_iphone,
                                  size: 12, color: Colors.grey.shade500),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '电话: ${mainContact.mobile ?? '暂无'}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 4),
                  if (supplier.shippingAmount != null)
                    Row(
                      children: [
                        Icon(Icons.receipt,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          '出货总额: $shippingAmount',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                  // 主营产品
                  if (supplier.businessScope != null)
                    _buildDetailRow(
                      Icons.inventory_2_outlined,
                      supplier.businessScope!,
                    ),

                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Divider(color: Color(0xFFF5F5F5), height: 1),
                  ),
                  const SizedBox(height: 6),

                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: [
                      if (isCore)
                        _buildTagChip(Icons.star, '核心供应商', Colors.red.shade700)
                      else
                        _buildTagChip(Icons.category_outlined, '普通供应商',
                            Colors.orange.shade700),
                      if (canBill)
                        _buildTagChip(
                            Icons.receipt_long, '可开票', Colors.green.shade700)
                      else
                        _buildTagChip(
                            Icons.receipt_long, '不可开票', Colors.grey.shade600),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    if (text.contains('（未提供）') || text.isEmpty || text.contains(': （未提供）')) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
