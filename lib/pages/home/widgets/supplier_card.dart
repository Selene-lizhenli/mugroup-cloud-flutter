import 'package:cloud/models/supply/contact.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:flutter/material.dart';

class SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback onClick;

  const SupplierCard({
    super.key,
    required this.supplier,
    required this.onClick,
  });

  List<Color> _getGradient(String vendorId) {
    final String numericPart = vendorId.replaceAll(RegExp(r'[^0-9]'), '');
    final int index = numericPart.isNotEmpty
        ? int.tryParse(numericPart.substring(numericPart.length - 1)) ?? 0
        : 0;

    final gradients = [
      [Colors.blue.shade400, Colors.blue.shade600],
      [Colors.indigo.shade400, Colors.purple.shade600],
      [Colors.pink.shade400, Colors.red.shade600],
      [Colors.teal.shade400, Colors.teal.shade600],
    ];
    return gradients[index % gradients.length];
  }

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
              fontSize: 10,
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
    final List<Color> gradientColors = _getGradient(supplier.supplierNo ?? '0');
    String nameInitial = '未'; // 默认值

    if (supplier.name != null && supplier.name!.isNotEmpty) {
      nameInitial = supplier.name!.trim().substring(0, 1); // 去除首尾空格后取首字母
    } else if (supplier.shortName != null && supplier.shortName!.isNotEmpty) {
      nameInitial = supplier.shortName!.trim().substring(0, 1); // 去除首尾空格后取首字母
    }

    final Contact? mainContact = supplier.contacts?.first;

    // UI 增强：显示核心供应商、可开票状态
    final bool isCore = supplier.isCore as bool;
    final bool canBill = supplier.canBill as bool;

    return InkWell(
      onTap: onClick,
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      supplier.supplierNo ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: -20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      nameInitial,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: gradientColors.first, // 使用主题色首字母
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 卡片主体
            Padding(
              padding: const EdgeInsets.only(
                  top: 24, bottom: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Text(
                    (supplier.name ?? supplier.shortName) ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // 位置信息
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey),
                      Text(
                        supplier.city ?? '',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (supplier.province != null)
                        Text(
                          ' · ${supplier.province}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (mainContact != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                          )
                        ],
                      ),
                    ),

                  // 主营产品
                  if (supplier.businessScope != null)
                    _buildDetailRow(
                      Icons.inventory_2_outlined,
                      supplier.businessScope!,
                    ),

                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Divider(color: Color(0xFFF5F5F5), height: 1),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
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
      padding: const EdgeInsets.only(bottom: 4.0),
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
