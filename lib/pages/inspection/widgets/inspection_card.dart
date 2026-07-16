import 'dart:math' as math;

import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/inspection/const.dart';
import 'package:cloud/pages/inspection/tool/inspection_tool.dart';
import 'package:cloud/pages/inspection/widgets/collaboration_dialog.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/pages/widgets/progress.dart';
import 'package:cloud/services/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class InspectionCard extends HookConsumerWidget {
  final Inspection inspection;
  final VoidCallback? onTap;
  final VoidCallback? onRefresh;

  const InspectionCard(
      {super.key, required this.inspection, this.onTap, this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    const TextStyle greyTextStyle = TextStyle(fontSize: 12, height: 1);

    final createdAt = inspection.createdAt;
    final collaborators = inspection.collaborators;
    // final reportPerSku = inspection.reportPerSku;
    final hasCollaborators = collaborators != null && collaborators.isNotEmpty;

    final collabText = hasCollaborators
        ? collaborators.map((e) => e.name ?? '').join('、')
        : '暂无协作';

    final items = inspection.items ?? [];
    final int total = items.length;
    final int handledCount = items
        .where((item) => inspectionStatusLabelMap.containsKey(item.status))
        .length;

    // 进度百分比 (0.0 - 1.0)
    final double progress = total > 0 ? (handledCount / total) : 0.0;
    // 显示文本
    final String progressText = '$handledCount/$total';

    final useNormalTemplate = inspection.inspectionDynamicTemplateId == null ||
        inspection.inspectionDynamicTemplateId.toString() == '0';

    final reportPerSku = !useNormalTemplate &&
        inspection.inspectionDynamicTemplate?.inspectionScope == 'sku';

    return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.fromLTRB(4, 5, 4, 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
              bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
              top: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
              right: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                offset: const Offset(0, 0),
                blurRadius: 12,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              transform: const GradientRotation(
                math.pi / 180,
              ),
              colors: [
                Color.lerp(
                  colorScheme.secondary.withOpacity(0.05),
                  colorScheme.surfaceContainer,
                  0.93,
                )!,
                colorScheme.surface,
                colorScheme.surface,
              ],
              stops: const [0.0, 0.15, 1.0],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    inspection.name ?? '未知',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // color: colorScheme.primary
                    ),
                  ),
                  const Spacer(),
                  if ((reportPerSku == true && inspection.items!.isNotEmpty) ||
                      (useNormalTemplate == true &&
                          inspection.items!.isNotEmpty))
                    const SizedBox()
                  else ...[
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () async {
                        final bool isConfirmed = await ConfirmDialog.show(
                          context,
                          content: '确定要删除验货任务${inspection.name}？',
                        );
                        if (isConfirmed) {
                          await deleteInspection(inspection.id!);
                          EasyLoading.showSuccess('删除成功');
                          if (onRefresh != null) {
                            onRefresh!();
                          }
                        }
                      },
                      child: Icon(Icons.delete_outline,
                          size: 18, color: colorScheme.error),
                    )
                  ]
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    '创建人:',
                    style: greyTextStyle,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),
                    color: colorScheme.outline.withOpacity(0.2),
                    child: Text(
                      '${inspection.user?.name}',
                      style: greyTextStyle,
                    ),
                  ),
                  if (inspection.type == 1) ...[
                    const SizedBox(width: 10),
                    const Text('手动创建', style: greyTextStyle),
                  ],
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Color(0xFFFC8E5B),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    createdAt == null
                        ? ''
                        : DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(createdAt)),
                    style: greyTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        '协作人: ',
                        style: greyTextStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),
                        // color:  Colors.green,
                        child: Text(
                          collabText,
                          textAlign: TextAlign.left,
                          style: greyTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(24, 135, 40, 173),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                          ),
                          builder: (context) => CollaborationBottomSheet(
                            inspectionId: inspection.id!,
                          ),
                        );

                        if (onRefresh != null) {
                          onRefresh!();
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.add_outlined,
                            size: 15,
                            color: Color.lerp(
                              const Color.fromARGB(255, 135, 40, 173),
                              colorScheme.primary,
                              0.63,
                            )!,
                          ),
                          Text(
                            '协作',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1,
                              color: Color.lerp(
                                const Color.fromARGB(255, 135, 40, 173),
                                colorScheme.primary,
                                0.63,
                              )!,
                            ),
                          ),
                          Icon(
                            Icons.person_outline,
                            size: 15,
                            color: Color.lerp(
                              const Color.fromARGB(255, 135, 40, 173),
                              colorScheme.primary,
                              0.63,
                            )!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (useNormalTemplate || reportPerSku == true) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text(
                      '进度：',
                      textAlign: TextAlign.left,
                      style: greyTextStyle,
                    ),
                    Expanded(
                      child: MuProgressBar(
                        progress: progress,
                        progressText: progressText,
                        height: 4,
                        valueColor: Colors.green[300],
                        trackColor: colorScheme.surfaceTint,
                      ),
                    )
                  ],
                ),
              ] else
                Row(
                  children: [
                    const Text(
                      '验货结果：',
                      textAlign: TextAlign.left,
                      style: greyTextStyle,
                    ),
                    InspectionStatusTag(
                      status: inspection.status,
                      fontSize: 12,
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}
