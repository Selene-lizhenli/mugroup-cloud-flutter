import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/widgets/progress.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class InspectionDetailInfoCard extends StatelessWidget {
  const InspectionDetailInfoCard({
    super.key,
    required this.inspectionTaskDetail,
    required this.total,
    required this.finished,
  });

  final Inspection? inspectionTaskDetail;
  final int total;
  final int finished;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final createdAt = inspectionTaskDetail?.createdAt;
    final displayDate = (createdAt != null && createdAt.length >= 10)
        ? createdAt.substring(0, 10)
        : createdAt ?? '';
    final double progress = total > 0 ? (finished / total) : 0.0;
    final String progressText = '$finished/$total';
    final inspTemplateNameFromServer =
        inspectionTaskDetail?.inspectionDynamicTemplate?.name.toString() ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
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
              if (inspectionTaskDetail?.media != null)
                AttachmentPreviewButton(inspection: inspectionTaskDetail),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.amber[800],
              ),
              const SizedBox(width: 4),
              Text(
                displayDate,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const Spacer(),
              if (inspTemplateNameFromServer.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceTint.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    inspTemplateNameFromServer,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          MuProgressBar(
            progress: progress,
            progressText: progressText,
            height: 10,
            valueColor: Colors.green[300],
            trackColor: colorScheme.surfaceTint,
          ),
        ],
      ),
    );
  }
}

class AttachmentPreviewButton extends StatelessWidget {
  const AttachmentPreviewButton({super.key, required this.inspection});

  final Inspection? inspection;

  bool _isValidPreviewUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return uri.host.isNotEmpty;
    }
    return false;
  }

  void _openPreview(BuildContext context) {
    final previewUrls = inspection?.media
            ?.map((m) => m.url)
            .whereType<String>()
            .where(_isValidPreviewUrl)
            .toList() ??
        const <String>[];
    if (previewUrls.isEmpty) {
      EasyLoading.showInfo('暂无附件图片');
      return;
    }
    showFlanImagePreview(
      context,
      images: previewUrls,
      startPosition: 0,
      loop: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openPreview(context),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            // border: Border.all(color: Colors.purple.withOpacity(0.4)),
          ),
          child: const Text(
            '查看附件',
            style: TextStyle(color: Colors.purple, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
