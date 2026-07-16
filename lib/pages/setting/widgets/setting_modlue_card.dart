import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

/// =======================
/// 模块卡片
/// =======================
class SettingModuleCard extends StatelessWidget {
  final String moduleId;
  final String title;
  final bool selected;
  final VoidCallback onAction;
  final int? dragIndex; // 用于拖拽的索引

  const SettingModuleCard({
    super.key,
    required this.moduleId,
    required this.title,
    required this.selected,
    required this.onAction,
    this.dragIndex,
  });

  /// 根据模块 id 获取图标和颜色
  _ModuleIconConfig _getIconConfig() {
    switch (moduleId) {
      case 'rate':
      case 'showroom_sample':
        return _ModuleIconConfig(
          icon: Icons.show_chart,
          iconBgColor: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF388E3C),
        );
      case 'market_purchase':
        return _ModuleIconConfig(
          icon: Icons.shopping_cart_outlined,
          iconBgColor: const Color(0xFFFFF3E0),
          iconColor: const Color(0xFFE65100),
        );
      case 'inspection':
        return _ModuleIconConfig(
          icon: Icons.check_circle_outline,
          iconBgColor: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
        );
      case 'crm_company':
        return _ModuleIconConfig(
          icon: Icons.people_outline,
          iconBgColor: const Color(0xFFEDE7F6),
          iconColor: const Color(0xFF5E35B1),
        );
      case 'supply_supplier':
        return _ModuleIconConfig(
          icon: Icons.factory_outlined,
          iconBgColor: const Color(0xFFFFEBEE),
          iconColor: const Color(0xFFC62828),
        );
      default:
        return _ModuleIconConfig(
          icon: Icons.dashboard_outlined,
          iconBgColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFF616161),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getIconConfig();

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            children: [
              /// 拖拽手柄（仅在可拖拽时显示）
              if (dragIndex != null)
                ReorderableDragStartListener(
                  index: dragIndex!,
                  child: Container(
                    padding: const EdgeInsets.only(right: 8),
                    color: Colors.transparent,
                    child: Icon(
                      Icons.drag_handle,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                  ),
                ),

              /// 左侧 icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: config.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(config.icon, color: config.iconColor, size: 26),
              ),
              const SizedBox(width: 16),

              /// 文本
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selected
                          ? context.l10n.settingModuleSelected
                          : context.l10n.settingModuleUnselected,
                      style: TextStyle(
                        fontSize: 13,
                        color: selected
                            ? Colors.grey.shade600
                            : Colors.grey.shade500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 右上角加减号
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onAction,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? Colors.redAccent : Colors.blueAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (selected ? Colors.redAccent : Colors.blueAccent)
                        .withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                selected ? Icons.remove : Icons.add,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 模块图标配置
class _ModuleIconConfig {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  _ModuleIconConfig({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}
