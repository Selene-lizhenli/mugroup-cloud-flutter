import 'package:cloud/constants/samples.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/sample_quotation/sample_quotation_l10n_helper.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/widgets/approval_note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 独立站详情 - 基本信息 Tab
class BasicInfoTab extends HookConsumerWidget {
  const BasicInfoTab({
    super.key,
    this.item,
  });
  final item;

  Color get statusColor =>
      sampleApprovalStatusColor(item?.status, fallback: Colors.white);

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(context.l10n.quoteCopiedToClipboard(label)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _rowWithCopy(
    BuildContext context,
    String label,
    String? value,
    ColorScheme colorScheme,
  ) {
    final displayValue = (value == null || value.isEmpty) ? '—' : value;
    final canCopy = value != null && value.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: GestureDetector(
                    onDoubleTap: canCopy
                        ? () {
                            _copyToClipboard(
                              context,
                              value as String,
                              label,
                            );
                          }
                        : null,
                    child: Text(
                      displayValue,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (canCopy) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _copyToClipboard(context, value as String, label);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.copy_outlined,
                        size: 15,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String? value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              (value == null || value.isEmpty)
                  ? context.l10n.quoteNone
                  : value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCreatorOrSalesUser(dynamic item) {
    final currentUserId = authNotifier.user?.id;
    if (currentUserId == null) return false;
    return currentUserId == item.creatorId || currentUserId == item.userId;
  }

  Future<void> submitQuotationFromDialog(
    BuildContext pageContext,
    String? approvalNote,
    int? quotationId, {
    BuildContext? approvalDialogContext,
  }) async {
    if (quotationId == null) {
      EasyLoading.showError(pageContext.l10n.quoteNoIdForSubmit);
      return;
    }
    try {
      EasyLoading.show(status: pageContext.l10n.cartSubmittingApproval);
      await submitShowroomQuotationApproval(
        quotationId,
        note: approvalNote,
      );
      EasyLoading.dismiss();
      EasyLoading.showSuccess(pageContext.l10n.cartSubmitSuccess);
      if (approvalDialogContext != null && approvalDialogContext.mounted) {
        Navigator.of(approvalDialogContext).pop();
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(
        pageContext.l10n.quoteSubmitApprovalFailed('$e'),
      );
    }
  }

  Widget _rowApproval(String label, String? value, Color color, Color colorBtn,
      int? quotationId, BuildContext pageContext) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: color,
              ),
            ),
          ),
          Text(
            sampleApprovalStatusLocalizedText(pageContext, item.status),
            style: TextStyle(fontSize: 13, color: statusColor),
          ),
          const SizedBox(width: 20),
          if ((item.status == null || item.status == 'draft') &&
              _isCreatorOrSalesUser(item))
            InkWell(
              onTap: () async {
                await ApprovalNoteDialog.show(
                  pageContext,
                  onConfirm: (note, dialogContext) =>
                      submitQuotationFromDialog(
                    pageContext,
                    note,
                    quotationId,
                    approvalDialogContext: dialogContext,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorBtn.withOpacity(0.1),
                  border: Border.all(color: colorBtn, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pageContext.l10n.quoteSubmitApproval,
                  style: TextStyle(
                    color: colorBtn,
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (item == null) {
      return Center(
        child: Text(
          context.l10n.noData,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    final l10n = context.l10n;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.86),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  _row(
                    context,
                    l10n.quoteDate,
                    formatDateTimeFull(item.quoteAt),
                    colorScheme.outline,
                  ),
                  _rowWithCopy(
                    context,
                    l10n.quoteCreator,
                    item!.creator?.name,
                    colorScheme,
                  ),
                  _rowWithCopy(
                    context,
                    l10n.quoteExporter,
                    item.user?.name ?? '',
                    colorScheme,
                  ),
                  _row(
                    context,
                    l10n.quoteTradeCountry,
                    item.tradeCountry,
                    colorScheme.outline,
                  ),
                  _row(
                    context,
                    l10n.quoteExchangeRate,
                    item.exchange,
                    colorScheme.outline,
                  ),
                  _row(
                    context,
                    l10n.quoteCommissionRate,
                    item.commissionRate,
                    colorScheme.outline,
                  ),
                  _row(
                    context,
                    l10n.quotationPurchasePriceIncludesTax,
                    item.isTaxInclusive == true ? l10n.yes : l10n.no,
                    colorScheme.outline,
                  ),
                  _row(
                    context,
                    l10n.quoteCurrency,
                    item.curreny,
                    colorScheme.outline,
                  ),
                  _row(
                    context,
                    l10n.quoteRemark,
                    item.remark,
                    colorScheme.outline,
                  ),
                  _rowApproval(
                    l10n.quoteApprovalStatus,
                    item.status,
                    colorScheme.outline,
                      colorScheme.primary, item.id, context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
