import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:flutter/material.dart';

class CrmCompanyCard extends StatelessWidget {
  final Company company;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const CrmCompanyCard({
    super.key,
    required this.company,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 获取第一个联系人
    final Contact? firstContact =
        (company.contacts != null && company.contacts!.isNotEmpty)
            ? company.contacts!.first
            : null;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompanyAvatar(name: company.name),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name ?? "未命名客户",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (company.address != null &&
                            company.address!.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 14, color: Colors.grey[400]),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  company.address!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  if (onEdit != null)
                    Material(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: onEdit,
                        borderRadius: BorderRadius.circular(8),
                        splashColor: colorScheme.primary.withOpacity(0.2),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (firstContact != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Row(
                    children: [
                      _ContactPill(
                        icon: Icons.person,
                        text: firstContact.name ?? "未知姓名",
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyAvatar extends StatelessWidget {
  final String? name;

  const _CompanyAvatar({this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String char = (name != null && name!.isNotEmpty)
        ? name!.substring(0, 1).toUpperCase()
        : "?";

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ContactPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isBold;

  const _ContactPill({
    required this.icon,
    required this.text,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
