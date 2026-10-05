import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/pages/inspection/tool/inspection_tool.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';

/// 验货历史底部弹出面板
/// 展示当前轮次 + 所有历史轮次，历史轮次按倒序排列（最近在前），支持展开/收起
class InspectionHistoryPanel extends StatefulWidget {
  const InspectionHistoryPanel({
    super.key,
    required this.item,
  });

  final InspectionItem item;

  @override
  State<InspectionHistoryPanel> createState() => _InspectionHistoryPanelState();
}

class _InspectionHistoryPanelState extends State<InspectionHistoryPanel> {
  final Set<int> _expandedRounds = {};

  bool _isValidPreviewUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return uri.host.isNotEmpty;
    }
    return false;
  }

  void _openPreview(BuildContext context, List<Media> medias) {
    final urls = medias
        .map((m) => m.url)
        .whereType<String>()
        .where(_isValidPreviewUrl)
        .toList();
    if (urls.isEmpty) return;
    showFlanImagePreview(context, images: urls, startPosition: 0, loop: false);
  }

  void _toggleRound(int index) {
    setState(() {
      if (_expandedRounds.contains(index)) {
        _expandedRounds.remove(index);
      } else {
        _expandedRounds.add(index);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final rounds = widget.item.rounds ?? [];
    if (rounds.isNotEmpty) {
      _expandedRounds.add(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rounds = widget.item.rounds ?? [];
    final reversedRounds = rounds.reversed.toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.history, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '验货历史',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                InspectionRoundCard(
                  roundLabel: '当前轮次',
                  status: widget.item.status,
                  remark: widget.item.remark,
                  createdAt: widget.item.createdAt,
                  medias: widget.item.media ?? [],
                  isCurrent: true,
                  colorScheme: colorScheme,
                  onImageTap: (medias) => _openPreview(context, medias),
                ),
                if (reversedRounds.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...reversedRounds.asMap().entries.map((entry) {
                    final index = entry.key;
                    final round = entry.value;
                    final roundNumber = round.round ?? rounds.length - index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InspectionRoundCard(
                        roundLabel: '第 $roundNumber 轮',
                        status: round.status,
                        remark: round.remark,
                        createdAt: round.createdAt,
                        medias: round.mediaSnapshot ?? [],
                        isCurrent: false,
                        isExpanded: _expandedRounds.contains(index),
                        onToggle: () => _toggleRound(index),
                        colorScheme: colorScheme,
                        onImageTap: (medias) => _openPreview(context, medias),
                      ),
                    );
                  }),
                ],
                if (rounds.isEmpty &&
                    (widget.item.status == 0 || widget.item.status == null))
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child:
                          Text('暂无验货历史', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionRoundCard extends StatelessWidget {
  const InspectionRoundCard({
    required this.roundLabel,
    required this.status,
    required this.remark,
    required this.createdAt,
    required this.medias,
    required this.isCurrent,
    required this.colorScheme,
    required this.onImageTap,
    this.isExpanded,
    this.onToggle,
  });

  final String roundLabel;
  final int? status;
  final String? remark;
  final String? createdAt;
  final List<Media> medias;
  final bool isCurrent;
  final ColorScheme colorScheme;
  final Function(List<Media>) onImageTap;
  final bool? isExpanded;
  final VoidCallback? onToggle;

  static const _categoryLabels = {
    'shipping_mark_front': '正唛',
    'shipping_mark_side': '侧唛',
    'unboxing': '开箱',
    'barcode_label': '条码标签',
    'weight_proof': '产品重量',
    'cover': '产品主图',
    'details': '其他验货图片',
  };

  List<Widget> _buildCategorizedImages() {
    final grouped = <String, List<Media>>{};
    for (final media in medias) {
      final key = media.collectionName ?? 'details';
      grouped.putIfAbsent(key, () => []).add(media);
    }

    const orderedKeys = [
      'shipping_mark_front',
      'shipping_mark_side',
      'unboxing',
      'barcode_label',
      'weight_proof',
      'cover',
      'details',
    ];

    final widgets = <Widget>[];
    for (final key in orderedKeys) {
      final list = grouped[key];
      if (list == null || list.isEmpty) continue;
      final label = _categoryLabels[key] ?? key;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label（${list.length}）',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: list.map((media) {
                  final thumb = media.thumbUrl ?? media.url;
                  return GestureDetector(
                    onTap: () => onImageTap(list),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: thumb != null
                          ? Image.network(
                              thumb,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, size: 20),
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image, size: 20),
                            ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }

    if (widgets.isEmpty) {
      widgets.add(
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: medias.map((media) {
            final thumb = media.thumbUrl ?? media.url;
            return GestureDetector(
              onTap: () => onImageTap(medias),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: thumb != null
                    ? Image.network(
                        thumb,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 20),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 20),
                      ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return widgets;
  }

  Widget _buildHeader() {
    final displayDate = (createdAt != null && createdAt!.length >= 10)
        ? createdAt!.substring(0, 10)
        : createdAt ?? '';
    final canCollapse = onToggle != null;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isCurrent
                ? colorScheme.primary.withOpacity(0.1)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            roundLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isCurrent ? colorScheme.primary : Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        InspectionStatusTag(status: status, fontSize: 13),
        const Spacer(),
        if (displayDate.isNotEmpty)
          Text(
            displayDate,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        if (canCollapse) ...[
          const SizedBox(width: 4),
          AnimatedRotation(
            turns: (isExpanded ?? false) ? 0.25 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.keyboard_arrow_right, size: 20),
          ),
        ],
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (remark != null && remark!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '备注：$remark',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
        if (medias.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._buildCategorizedImages(),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCollapse = onToggle != null;
    final expanded = isExpanded ?? true;

    return GestureDetector(
      onTap: canCollapse ? onToggle : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.primary.withOpacity(0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: isCurrent
              ? Border.all(color: colorScheme.primary.withOpacity(0.3))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            if (canCollapse)
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: expanded ? _buildBody() : const SizedBox.shrink(),
              )
            else
              _buildBody(),
          ],
        ),
      ),
    );
  }
}
