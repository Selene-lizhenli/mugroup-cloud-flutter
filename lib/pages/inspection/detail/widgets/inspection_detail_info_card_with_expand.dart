import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/inspection/detail/widgets/inspection_detail_info_card.dart';
import 'package:cloud/pages/inspection/tool/inspection_tool.dart';
import 'package:cloud/pages/inspection/widgets/select_template_dialog.dart';
import 'package:cloud/pages/widgets/progress.dart';
import 'package:cloud/services/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 可折叠的基础信息卡片：默认折叠，展开后展示验货名称、日期、模板、进度条等。
class InspectionDetailInfoCardWithExpand extends HookWidget {
  const InspectionDetailInfoCardWithExpand({
    super.key,
    required this.inspectionTaskDetail,
    required this.total,
    required this.finished,
    required this.refreshData,
    required this.reportPerSku,
  });

  final Inspection? inspectionTaskDetail;
  final int finished;
  final int total;
  final Function refreshData;
  final bool reportPerSku;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    final colorScheme = Theme.of(context).colorScheme;
    final createdAt = inspectionTaskDetail?.createdAt;
    final displayDate = (createdAt != null && createdAt.length >= 10)
        ? createdAt.substring(0, 10)
        : createdAt ?? '';

    final double progress = total > 0 ? (finished / total) : 0.0;
    final String progressText = '$finished/$total';
    final templateName =
        inspectionTaskDetail?.inspectionDynamicTemplate?.name ?? '';
    final inspectionTaskHasRecord = inspectionTaskDetail?.status != null &&
        inspectionTaskDetail!.status! > 0;

    final inspectionItemsHasStatus = inspectionTaskDetail?.items?.any(
          (item) => item.status != null && item.status! > 0,
        ) ??
        false;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => isExpanded.value = !isExpanded.value,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.format_list_bulleted,
                      color: colorScheme.primary, size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '基础信息',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF666666),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded.value) ...[
            const SizedBox(height: 4),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '名称：',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${inspectionTaskDetail?.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '时间：',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(width: 4),
                Text(
                  displayDate,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '附件：',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                if (inspectionTaskDetail?.media != null)
                  AttachmentPreviewButton(inspection: inspectionTaskDetail),
              ],
            ),
            const SizedBox(height: 0),
            if (templateName.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '模板：',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceTint.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      templateName,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.penToSquare,
                        color: Color.fromARGB(255, 128, 128, 128), size: 18),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (inspectionTaskHasRecord || inspectionItemsHasStatus) {
                        EasyLoading.showInfo('已有验货记录,禁止修改！');
                        return;
                      }
                      final templateData =
                          await showDialog<Map<String, dynamic>>(
                        context: context,
                        barrierDismissible: true,
                        builder: (dialogContext) {
                          return const SelectTemplateDialog();
                        },
                      );
                      if (templateData != null) {
                        final templateValue = templateData['value'];
                        try {
                          await updateInspectionTask(
                            inspectionTaskDetail?.id,
                            {
                              'inspection_dynamic_template_id': templateValue
                                      is int
                                  ? templateValue
                                  : int.tryParse(
                                          templateValue?.toString() ?? '') ??
                                      templateValue,
                            },
                          );
                          refreshData();
                        } catch (e) {
                          EasyLoading.showError('绑定验货任务失败');
                        }
                      }
                    },
                  ),
                ],
              ),
            const SizedBox(height: 8),
            if (reportPerSku == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '进度：',
                    style: TextStyle(
                        fontSize: 13, height: 1, color: Colors.grey[600]),
                  ),
                  Expanded(
                    child: MuProgressBar(
                      progress: progress,
                      progressText: progressText,
                      height: 13,
                      valueColor: Colors.green[300],
                      trackColor: colorScheme.surfaceTint,
                    ),
                  )
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '状态：',
                    style: TextStyle(
                        fontSize: 13, height: 1, color: Colors.grey[600]),
                  ),
                  InspectionStatusTag(status: inspectionTaskDetail?.status),
                ],
              ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
