import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:flutter/widgets.dart';

String sampleApprovalStatusLocalizedText(BuildContext context, String? status) {
  final l10n = context.l10n;
  switch ((status ?? '').trim()) {
    case 'draft':
      return l10n.quoteApprovalDraft;
    case 'pending':
      return l10n.quoteApprovalPending;
    case 'approved':
      return l10n.quoteApprovalApproved;
    case 'rejected':
      return l10n.quoteApprovalRejected;
    default:
      return status ?? '';
  }
}

String selectedSuppliersLocalizedText(
  BuildContext context,
  List<Supplier> suppliers,
) {
  final l10n = context.l10n;
  if (suppliers.isEmpty) return l10n.quoteSelectSupplier;

  String nameOf(Supplier s) {
    final short = s.shortName?.trim();
    final name = s.name?.trim();
    if (short != null && short.isNotEmpty) return short;
    if (name != null && name.isNotEmpty) return name;
    return l10n.quoteUnknownSupplier;
  }

  if (suppliers.length == 1) return nameOf(suppliers.first);
  return l10n.quoteSuppliersCount(
    nameOf(suppliers.first),
    suppliers.length,
  );
}
