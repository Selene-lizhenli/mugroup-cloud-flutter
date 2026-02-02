import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/new_supplier.dart';
import 'package:cloud/pages/quote/widgets/collaboration_dialog.dart';
import 'package:flutter/material.dart';

class QuoteCard extends StatefulWidget {
  final QuotationList item;
  final VoidCallback? onTap;
  final int? tabIndex;

  const QuoteCard({
    super.key,
    required this.item,
    this.onTap,
    this.tabIndex,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  int? selectedSupplierId;

  List<Map<String, dynamic>> _getProcessedSuppliers() {
    final quotes = widget.item.supplyQuotes ?? [];
    final Map<int, Map<String, dynamic>> supplierMap = {};

    for (var q in quotes) {
      final s = q.supplier;
      if (s?.id != null) {
        if (!supplierMap.containsKey(s!.id)) {
          supplierMap[s.id!] = {
            'data': q,
            'count': 1,
            'id': s.id,
          };
        } else {
          supplierMap[s.id]!['count'] =
              (supplierMap[s.id]!['count'] as int) + 1;
        }
      }
    }
    return supplierMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final processedSuppliers = _getProcessedSuppliers();

    int displayCount = widget.item.productCount ?? 0;
    if (selectedSupplierId != null) {
      try {
        final selected =
            processedSuppliers.firstWhere((e) => e['id'] == selectedSupplierId);
        displayCount = selected['count'];
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: _buildHeader(colorScheme, displayCount),
          ),
          _buildSupplierHorizontalList(processedSuppliers, colorScheme),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, int displayCount) {
    final customerName =
        widget.item.company?.name ?? widget.item.user?.name ?? '未知客户';
    final creatorName = widget.item.creator?.name ?? '系统';
    final isFiltered = selectedSupplierId != null;

    final collaborators = widget.item.collaborators;
    final hasCollaborators = collaborators != null && collaborators.isNotEmpty;
    final collabText = hasCollaborators
        ? collaborators.map((e) => e.name ?? '').join('、')
        : '暂无';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    customerName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '创建人: $creatorName',
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Text(
                  '协作: $collabText',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        hasCollaborators ? Colors.green[600] : Colors.grey[400],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildCountTag(displayCount, isFiltered),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildCollaborateButton(colorScheme),
      ],
    );
  }

  Widget _buildCountTag(int count, bool isFiltered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color:
            isFiltered ? Colors.blue.withOpacity(0.1) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$count个产品',
        style: TextStyle(
          fontSize: 10,
          color: isFiltered ? Colors.blue[700] : Colors.grey[600],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSupplierHorizontalList(
      List<Map<String, dynamic>> items, ColorScheme colorScheme) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildAddBtn(quote: items[0]);
          final itemData = items[index - 1];
          return _buildSquareCard(colorScheme, itemData['data'],
              selectedSupplierId == itemData['id'], itemData['id']);
        },
      ),
    );
  }

  Widget _buildSquareCard(
      ColorScheme colorScheme, dynamic quote, bool isSelected, int id) {
    final supplier = quote.supplier;
    final String name = supplier?.name ?? '未知';
    final String? imageUrl =
        (supplier?.images?.isNotEmpty == true) ? supplier.images.first : null;

    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () =>
                  setState(() => selectedSupplierId = isSelected ? null : id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? colorScheme.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl != null
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Container(
                          padding: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 9, color: Color(0xFF333333)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ),
              ),
            ),
          ),
          if (imageUrl != null && isSelected)
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => _showImagePreview(imageUrl),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.fullscreen_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showImagePreview(String url) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.9),
      pageBuilder: (context, _, __) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child:
            InteractiveViewer(child: Image.network(url, fit: BoxFit.contain)),
      ),
    );
  }

  Widget _buildAddBtn({required Map<String, dynamic> quote}) {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) =>
                    AddSupplierSheet(quotationId: quote['id']));
          },
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollaborateButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            CollaborationBottomSheet(quoteId: widget.item.id!),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt_rounded,
                size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              '协作',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
