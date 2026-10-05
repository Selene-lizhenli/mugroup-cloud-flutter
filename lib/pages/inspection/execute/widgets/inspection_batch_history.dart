import 'dart:async';

import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/inspection/inspection_item_batch.dart';
import 'package:cloud/models/inspection/inspection_round_snapshot.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/pages/inspection/const.dart';
import 'package:cloud/services/inspection.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class InspectionBatchHistory extends StatefulWidget {
  const InspectionBatchHistory({
    super.key,
    required this.itemId,
    required this.isExpanded,
    required this.onToggle,
    required this.colorScheme,
    this.photoCheckFields,
  });

  final int itemId;
  final bool isExpanded;
  final VoidCallback onToggle;
  final ColorScheme colorScheme;
  final List<FieldConfig>? photoCheckFields;

  @override
  State<InspectionBatchHistory> createState() => _InspectionBatchHistoryState();
}

class _InspectionBatchHistoryState extends State<InspectionBatchHistory> {
  List<InspectionItemBatch>? _batches;
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int _statusFilter = 0;
  Timer? _debounceTimer;
  final Set<int> _expandedBatchIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    _loadBatches();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadBatches();
    }
  }

  void _onSearchChanged() {
    setState(() {});
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _resetAndLoad();
    });
  }

  void _resetAndLoad() {
    setState(() {
      _page = 1;
      _batches = null;
      _hasMore = true;
    });
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final searchText = _searchController.text.trim();
      final batches = await getInspectionItemBatches(
        widget.itemId,
        page: _page,
        batchNo: searchText.isEmpty ? null : searchText,
        status: _statusFilter == 0 ? null : _statusFilter,
      );
      if (batches.isEmpty) {
        _hasMore = false;
      } else {
        _batches = (_batches ?? [])..addAll(batches);
        _page++;
      }
    } catch (_) {
      EasyLoading.showError('加载批次历史失败');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<_PhotoColumn> _buildPhotoColumns() {
    final photoCheckFields = widget.photoCheckFields ?? [];
    final columns = <_PhotoColumn>[];
    final seen = <String>{};

    for (final field in photoCheckFields) {
      if (seen.contains(field.name)) continue;
      seen.add(field.name);
      columns.add(_PhotoColumn(name: field.name, label: field.label));
    }

    return columns;
  }

  List<Media> _getMediaForCategory(
      InspectionItemBatch batch, String categoryName) {
    return (batch.media ?? <Media>[])
        .where((m) => (m.collectionName ?? '') == categoryName)
        .toList();
  }

  void _openPreview(List<Media> medias) {
    final urls = medias
        .map((m) => m.url)
        .whereType<String>()
        .where((u) => u.isNotEmpty)
        .toList();
    if (urls.isEmpty) return;
    showFlanImagePreview(
      context,
      images: urls,
      startPosition: 0,
      loop: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final batches = _batches ?? [];
    final photoCols = _buildPhotoColumns();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Icon(Icons.inventory_2,
                    size: 20, color: widget.colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  '历史批次验货',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                Text(
                  '共 ${batches.length} 批次',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: widget.isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xFF666666),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isExpanded) ...[
            const SizedBox(height: 12),
            _buildFilterBar(),
            const SizedBox(height: 8),
            if (batches.isEmpty && !_isLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    '暂无批次验货记录',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            if (batches.isNotEmpty || _isLoading)
              SizedBox(
                height: _tableHeight(batches.length),
                child: _buildTable(batches, photoCols),
              ),
          ],
        ],
      ),
    );
  }

  double _tableHeight(int rowCount) {
    const headerH = 36.0;
    const rowH = 56.0;
    const maxH = 400.0;
    var h = headerH + rowCount * rowH;
    if (_isLoading) h += 44;
    if (!_hasMore && rowCount > 0) h += 44;
    return h > maxH ? maxH : h;
  }

  String _statusLabel(int status) {
    switch (status) {
      case 1:
        return '合格';
      case 2:
        return '微瑕';
      case 3:
        return '不合格';
      case 4:
        return '返工';
      default:
        return '全部状态';
    }
  }

  String _displayBatchNo(InspectionItemBatch batch) {
    final no = batch.batchNo;
    if (no == null || no.isEmpty) return '-';
    if ((batch.duplicateCount ?? 1) > 1) {
      return '$no-${batch.batchNoSequence ?? 1}';
    }
    return no;
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: '批次号搜索',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                prefixIcon: const Icon(Icons.search, size: 18),
                prefixIconConstraints: const BoxConstraints(minWidth: 32),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _resetAndLoad();
                        },
                        child: const Icon(Icons.close,
                            size: 18, color: Colors.grey),
                      )
                    : null,
                suffixIconConstraints:
                    const BoxConstraints(minWidth: 32, maxHeight: 28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: widget.colorScheme.primary),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: PopupMenuButton<int>(
            offset: const Offset(0, 40),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onSelected: (value) {
              setState(() => _statusFilter = value);
              _resetAndLoad();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 0,
                  child: Text('全部状态', style: TextStyle(fontSize: 13))),
              const PopupMenuItem(
                  value: 1, child: Text('合格', style: TextStyle(fontSize: 13))),
              const PopupMenuItem(
                  value: 2, child: Text('微瑕', style: TextStyle(fontSize: 13))),
              const PopupMenuItem(
                  value: 3, child: Text('不合格', style: TextStyle(fontSize: 13))),
              const PopupMenuItem(
                  value: 4, child: Text('返工', style: TextStyle(fontSize: 13))),
            ],
            child: Listener(
              onPointerDown: (_) => _searchFocusNode.unfocus(),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade50,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _statusLabel(_statusFilter),
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF333333)),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down,
                        size: 20, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(
      List<InspectionItemBatch> batches, List<_PhotoColumn> photoCols) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(photoCols),
            ...batches.map((b) => _buildTableRow(b, photoCols)),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            if (!_hasMore && batches.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text('没有更多了',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(List<_PhotoColumn> photoCols) {
    return Container(
      color: Colors.grey.shade100,
      child: Row(
        children: [
          const _TableCell.fixed('批次号', width: 140, isHeader: true),
          const _TableCell.fixed('状态', width: 65, isHeader: true),
          const _TableCell.fixed('轮次', width: 65, isHeader: true),
          ...photoCols.map(
              (col) => _TableCell.fixed(col.label, width: 80, isHeader: true)),
          const _TableCell.fixed('验货时间', width: 100, isHeader: true),
          const _TableCell.fixed('备注', width: 100, isHeader: true),
        ],
      ),
    );
  }

  void _toggleBatchExpand(int batchId) {
    setState(() {
      if (_expandedBatchIds.contains(batchId)) {
        _expandedBatchIds.remove(batchId);
      } else {
        _expandedBatchIds.add(batchId);
      }
    });
  }

  Widget _buildTableRow(
      InspectionItemBatch batch, List<_PhotoColumn> photoCols) {
    final currentRound = batch.round ?? (batch.rounds?.length ?? 0);
    final hasRounds = (batch.rounds ?? []).isNotEmpty;
    final isExpanded = hasRounds && _expandedBatchIds.contains(batch.id);

    return Column(
      children: [
        InkWell(
          onTap: hasRounds ? () => _toggleBatchExpand(batch.id!) : null,
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                _TableCell.fixed(_displayBatchNo(batch), width: 140),
                _StatusCell(status: batch.status ?? 0, width: 65),
                _RoundCell(
                  currentRound: currentRound,
                  width: 65,
                  hasRounds: hasRounds,
                  isExpanded: isExpanded,
                ),
                ...photoCols.map((col) {
                  final medias = _getMediaForCategory(batch, col.name);
                  return _PhotoCell(
                    medias: medias,
                    width: 80,
                    onTap: () => _openPreview(medias),
                  );
                }),
                _TableCell.fixed(
                  batch.createdAt != null && batch.createdAt!.length >= 10
                      ? batch.createdAt!.substring(0, 10)
                      : batch.createdAt ?? '-',
                  width: 100,
                ),
                _RemarkCell(text: batch.remark ?? '', width: 100),
              ],
            ),
          ),
        ),
        if (isExpanded) ..._buildRoundSubRows(batch.rounds ?? [], photoCols),
      ],
    );
  }

  List<Widget> _buildRoundSubRows(
      List<InspectionRoundSnapshot> rounds, List<_PhotoColumn> photoCols) {
    final widgets = <Widget>[];
    for (int i = 0; i < rounds.length; i++) {
      final snapshot = rounds[i];
      final roundNum = snapshot.round ?? (i + 1);
      widgets.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              _TableCell.fixed(
                '  \u21B3 第$roundNum轮',
                width: 140,
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
              _StatusCell(
                status: snapshot.status ?? 0,
                width: 65,
                compact: true,
              ),
              const _TableCell.fixed('-', width: 65),
              ...photoCols.map((col) {
                final medias = (snapshot.mediaSnapshot ?? [])
                    .where((m) => (m.collectionName ?? '') == col.name)
                    .toList();
                return _PhotoCell(
                  medias: medias,
                  width: 80,
                  onTap: () => _openPreview(medias),
                  compact: true,
                );
              }),
              _TableCell.fixed(
                snapshot.createdAt != null &&
                        snapshot.createdAt!.length >= 10
                    ? snapshot.createdAt!.substring(0, 10)
                    : snapshot.createdAt ?? '-',
                width: 100,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              _RemarkCell(
                text: snapshot.remark ?? '',
                width: 100,
                compact: true,
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}

class _RoundCell extends StatelessWidget {
  const _RoundCell({
    required this.currentRound,
    required this.width,
    this.hasRounds = false,
    this.isExpanded = false,
  });

  final int currentRound;
  final double width;
  final bool hasRounds;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    if (currentRound <= 1 && !hasRounds) {
      return SizedBox(
        width: width,
        child: const Center(
          child: Text('-', style: TextStyle(fontSize: 13, color: Colors.grey)),
        ),
      );
    }

    return SizedBox(
      width: width,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '第$currentRound轮',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (hasRounds)
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 14,
                color: Colors.blue.withOpacity(0.6),
              ),
          ],
        ),
      ),
    );
  }
}

class _PhotoColumn {
  final String name;
  final String label;
  const _PhotoColumn({required this.name, required this.label});
}

class _TableCell extends StatelessWidget {
  const _TableCell.fixed(
    this.text, {
    required this.width,
    this.isHeader = false,
    this.style,
  });

  final String text;
  final double width;
  final bool isHeader;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style ??
              TextStyle(
                fontSize: isHeader ? 12 : 13,
                fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                color:
                    isHeader ? Colors.grey.shade700 : const Color(0xFF333333),
              ),
        ),
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({
    required this.status,
    required this.width,
    this.compact = false,
  });

  final int status;
  final double width;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label =
        inspectionStatusLabelMap[status] ?? inspectionStatusPendingLabel;
    final color = {
          1: Colors.green,
          2: Colors.orange,
          3: Colors.red,
          4: Colors.blue
        }[status] ??
        Colors.grey;

    return SizedBox(
      width: width,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: compact ? 3 : 6, vertical: compact ? 1 : 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoCell extends StatelessWidget {
  const _PhotoCell({
    required this.medias,
    required this.width,
    required this.onTap,
    this.compact = false,
  });

  final List<Media> medias;
  final double width;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (medias.isEmpty) {
      return SizedBox(
        width: width,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 8, vertical: compact ? 6 : 10),
          child: Text('-',
              style:
                  TextStyle(fontSize: compact ? 11 : 13, color: Colors.grey)),
        ),
      );
    }

    final firstMedia = medias.first;
    final imgSize = 44.0;
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.all(compact ? 4 : 6),
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: imgSize,
            height: imgSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    firstMedia.thumbUrl ?? firstMedia.url ?? '',
                    width: imgSize,
                    height: imgSize,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: imgSize,
                      height: imgSize,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.broken_image,
                          size: compact ? 14 : 18, color: Colors.grey),
                    ),
                  ),
                ),
                if (medias.length > 1)
                  Positioned(
                    top: -4,
                    right: imgSize == 34 ? 10 : 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        '${medias.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RemarkCell extends StatelessWidget {
  const _RemarkCell({
    required this.text,
    required this.width,
    this.compact = false,
  });

  final String text;
  final double width;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          if (text.isNotEmpty) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('备注'),
                content: SingleChildScrollView(child: Text(text)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('关闭'),
                  ),
                ],
              ),
            );
          }
        },
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 8, vertical: compact ? 6 : 10),
          child: Text(
            text.isEmpty ? '-' : text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 11 : 13,
              color: text.isEmpty ? Colors.grey : const Color(0xFF333333),
            ),
          ),
        ),
      ),
    );
  }
}