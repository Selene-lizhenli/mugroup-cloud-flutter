import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/inspection/widgets/collaboration_dialog.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class InspectionCard extends HookConsumerWidget {
  final Inspection inspection;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const InspectionCard(
      {super.key, required this.inspection, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final TextStyle greyTextStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 13,
    );
    const Color lightBlueBg = Color(0xFFEEF0FF);

    final createdAt = inspection.createdAt;
    final user = ref.watch(userProvider).user;

    final collaborators = inspection.collaborators;
    final hasCollaborators = collaborators != null && collaborators.isNotEmpty;

    final collabText = hasCollaborators
        ? collaborators.map((e) => e.name ?? '').join('、')
        : '暂无协作';

    final collabStyle = hasCollaborators
        ? const TextStyle(color: Colors.green, fontSize: 13)
        : greyTextStyle;

    final items = inspection.items ?? [];
    final int total = items.length;
    final int finished = items.where((item) => item.status == 1).length;

    // 进度百分比 (0.0 - 1.0)
    final double progress = total > 0 ? (finished / total) : 0.0;
    // 显示文本
    final String progressText = '$finished/$total';

    return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    inspection.name ?? '未知',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${user?.name}', style: greyTextStyle),
                  const SizedBox(width: 4),
                  Text(
                    '#${inspection.id}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
                      onDelete!();
                    },
                    child: Icon(Icons.delete_outline,
                        size: 18, color: Colors.red[300]),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child:
                    Divider(height: 1, thickness: 1, color: Colors.grey[100]),
              ),
              Row(
                children: [
                  Text(
                    createdAt == null
                        ? ''
                        : DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(createdAt)),
                    style: greyTextStyle,
                  ),
                  const SizedBox(width: 16),
                  if (inspection.type == 1) Text('手动创建', style: greyTextStyle),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      collabText,
                      style: collabStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: lightBlueBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CollaborationBottomSheet(
                              inspectionId: inspection.id!),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_add_alt_1,
                              size: 14, color: colorScheme.secondary),
                          const SizedBox(width: 4),
                          Text(
                            '协作',
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 24,
                  width: double.infinity,
                  color: const Color(0xFFE0E0E0),
                  child: Stack(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double currentWidth =
                              constraints.maxWidth * progress;
                          return Container(
                            width: currentWidth,
                            color: const Color(0xFF3B68D8),
                          );
                        },
                      ),
                      Center(
                        child: Text(
                          progressText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
