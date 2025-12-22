import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MarketProductInfoPage extends HookConsumerWidget {
  const MarketProductInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('市场采购首页'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _MenuCard(
              color: Color(0xFF3B82F6),
              icon: Icons.person_add_alt_1_outlined,
              title: '客户资料管理',
              subtitle: '管理客户信息、联系人和业务往来',
            ),
            const SizedBox(height: 12),
            const _MenuCard(
              color: Color(0xFF10B981),
              icon: Icons.storefront_outlined,
              title: '供应商资料管理',
              subtitle: '管理供应商信息、档口和产品报价',
            ),
            const SizedBox(height: 12),
            const _MenuCard(
              color: Color(0xFFF97316),
              icon: Icons.search,
              title: '产品管理',
              subtitle: '管理产品信息、库存和价格',
            ),
            const SizedBox(height: 12),
            const _MenuCard(
              color: Color(0xFFEF4444),
              icon: Icons.assignment_outlined,
              title: '报价单管理',
              subtitle: '创建和管理客户报价单',
            ),
            const SizedBox(height: 12),
            const _MenuCard(
              color: Color(0xFF8B5CF6),
              icon: Icons.check_circle_outline,
              title: '验货任务',
              subtitle: '创建和管理验货任务，上传验货图片',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '快捷操作',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.person_add_alt_1,
                    iconColor: Color(0xFF3B82F6),
                    iconBgColor: Color(0xFFEFF6FF),
                    enTitle: 'Customers',
                    cnTitle: '新增客户',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.storefront,
                    iconColor: Color(0xFF10B981),
                    iconBgColor: Color(0xFFECFDF5),
                    enTitle: 'Suppliers',
                    cnTitle: '新增供应商',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.shopping_cart_outlined,
                    iconColor: Color(0xFFF97316),
                    iconBgColor: Color(0xFFFFF7ED),
                    enTitle: 'Products',
                    cnTitle: '新增产品',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.assignment_turned_in_outlined,
                    iconColor: Color(0xFFEF4444),
                    iconBgColor: Color(0xFFFEF2F2),
                    enTitle: 'Quotations',
                    cnTitle: '新增报价',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _MenuCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // 半透明白色
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String enTitle;
  final String cnTitle;

  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.enTitle,
    required this.cnTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // 图标
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor, // 浅色背景
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          // 文字
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                enTitle,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                cnTitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
