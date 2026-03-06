import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/new_supplier.dart';
import 'package:cloud/pages/quote/quote_page.dart';
import 'package:cloud/pages/quote/widgets/collaboration_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuoteCard extends HookConsumerWidget {
  final QuotationList item;
  final VoidCallback? onTap;
  final int? tabIndex;
  final int? selectedSupplierId;
  final void Function(int? supplierId)? onSupplierSelected;

  const QuoteCard({
    super.key,
    required this.item,
    this.onTap,
    this.tabIndex,
    this.onSupplierSelected,
    this.selectedSupplierId,
  });

  List<Map<String, dynamic>> _getProcessedSuppliers() {
    final quotes = item.supplyQuotes ?? [];
    final Map<int, Map<String, dynamic>> supplierMap = {};
    for (var q in quotes) {
      final s = q.supplier;
      if (s?.id != null) {
        if (!supplierMap.containsKey(s!.id)) {
          supplierMap[s.id!] = {'data': q, 'count': 1, 'id': s.id};
        } else {
          supplierMap[s.id]!['count'] =
              (supplierMap[s.id]!['count'] as int) + 1;
        }
      }
    }
    return supplierMap.values.toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final processedSuppliers = _getProcessedSuppliers();

    int displayCount = item.productCount ?? 0;
    if (selectedSupplierId != null) {
      try {
        final selected =
            processedSuppliers.firstWhere((e) => e['id'] == selectedSupplierId);
        displayCount = selected['count'];
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: _buildHeader(context, ref, colorScheme, displayCount),
          ),
          _buildSupplierHorizontalList(
              context, processedSuppliers, colorScheme),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref,
      ColorScheme colorScheme, int displayCount) {
    final customerName = item.company?.name ?? item.user?.name ?? '未知客户';
    final creatorName = item.creator?.name ?? '系统';
    final isFiltered = selectedSupplierId != null;

    final collaborators = item.collaborators;
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
                flex: 5,
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    '$customerName  ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
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
        _buildCollaborateButton(context, ref, colorScheme),
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

  Widget _buildSupplierHorizontalList(BuildContext context,
      List<Map<String, dynamic>> items, ColorScheme colorScheme) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildAddBtn(context);

          final itemData = items[index - 1];
          final id = itemData['id'];
          // 【核心变化】使用外部传入的 selectedSupplierId 判断
          final isSelected = selectedSupplierId == id;
          final supplier = itemData['data'].supplier;

          final String? imageUrl = () {
            if (supplier?.media == null || supplier!.media!.isEmpty) {
              return null;
            }
            final businessCards = supplier.media!
                .where((img) => img.collectionName == 'bussiness_card');
            return businessCards.isNotEmpty ? businessCards.first.url : null;
          }();

          return Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      final newId = isSelected ? null : id;
                      // 【核心变化】直接调用外部回调，不在此维护 state
                      onSupplierSelected?.call(newId);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageUrl != null
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : Center(
                                child: Text(
                                  supplier?.name ?? '',
                                  style: const TextStyle(fontSize: 9),
                                  textAlign: TextAlign.center,
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
                      onTap: () => _showImagePreview(context, imageUrl),
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
        },
      ),
    );
  }

  void _showImagePreview(BuildContext context, String url) {
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

  Widget _buildAddBtn(BuildContext context) {
    return Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.only(right: 8),
        child: Material(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
                onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
                    ),
                    builder: (context) =>
                        AddSupplierSheet(quotationId: item.id)),
                child: const Center(
                    child: Icon(Icons.add_rounded, color: Colors.grey)))));
  }

  Widget _buildCollaborateButton(
      BuildContext context, WidgetRef ref, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
          ),
          builder: (context) => CollaborationBottomSheet(quoteId: item.id!),
        );

        // 5. 协作完成后，通过 ref 触发刷新请求
        ref.read(quotePageRefreshTrigger.notifier).update((state) => state + 1);
      },
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
            Text('协作',
                style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
