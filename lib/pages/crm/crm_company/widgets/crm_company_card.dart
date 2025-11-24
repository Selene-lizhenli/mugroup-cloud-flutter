import 'package:cloud/models/crm/company.dart';
import 'package:flutter/material.dart';

class CrmCompanyCard extends StatelessWidget {
  final Company company;
  final VoidCallback? onTap;

  const CrmCompanyCard({
    super.key,
    required this.company,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasEmail = company.email != null && company.email!.isNotEmpty;
    final hasPhone = company.whatsapp != null && company.whatsapp!.isNotEmpty;
    final hasDomain = company.domain != null && company.domain!.isNotEmpty;

    // 只有当至少有一个联系方式时，才显示底部栏
    final hasContactInfo = hasEmail || hasPhone || hasDomain;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名称与行业
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name ?? "未命名",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            color: Color(0xFF2D333A),
                          ),
                        ),
                        if (company.industry != null &&
                            company.industry!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            company.industry!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (_hasTags) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (company.source != null && company.source!.isNotEmpty)
                      _TagBadge(
                        text: company.source!,
                        color: Colors.blue,
                      ),
                    if (company.location != null &&
                        company.location!.isNotEmpty)
                      _TagBadge(
                        text: company.location!,
                        color: Colors.orange,
                        icon: Icons.location_on_outlined,
                      ),
                  ],
                ),
              ],

              /// 4. 底部联系方式概览
              if (hasContactInfo) ...[
                const SizedBox(height: 12),
                Container(height: 1, color: Colors.grey.withOpacity(0.08)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (hasEmail) ...[
                      const _ContactIcon(icon: Icons.email_outlined),
                      const SizedBox(width: 8),
                    ],
                    if (hasPhone) ...[
                      const _ContactIcon(icon: Icons.phone_iphone),
                      const SizedBox(width: 8),
                    ],
                    if (hasDomain) ...[
                      const _ContactIcon(icon: Icons.language),
                      const SizedBox(width: 8),
                    ],
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasTags =>
      (company.source != null && company.source!.isNotEmpty) ||
      (company.location != null && company.location!.isNotEmpty);
}

class _TagBadge extends StatelessWidget {
  final String text;
  final MaterialColor color;
  final IconData? icon;

  const _TagBadge({
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.shade100, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color.shade700),
            const SizedBox(width: 2),
          ],
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: color.shade700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactIcon extends StatelessWidget {
  final IconData icon;

  const _ContactIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        icon,
        size: 14,
        color: Colors.grey[600],
      ),
    );
  }
}
