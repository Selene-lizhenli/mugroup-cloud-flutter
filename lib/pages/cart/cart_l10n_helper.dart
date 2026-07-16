import 'package:cloud/constants/cart.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:flutter/widgets.dart';

String cartTypeLocalizedTitle(BuildContext context, CartType type) {
  final l10n = context.l10n;
  switch (type) {
    case CartType.stockIn:
      return l10n.cartTypeStockIn;
    case CartType.borrowOut:
      return l10n.cartTypeBorrowOut;
    case CartType.borrowIn:
      return l10n.cartTypeBorrowIn;
    case CartType.transferOut:
      return l10n.cartTypeTransferOut;
    case CartType.transferIn:
      return l10n.cartTypeTransferIn;
    case CartType.inout:
      return l10n.cartTypeInout;
    case CartType.quotation:
      return l10n.cartTypeQuotation;
    case CartType.deliveryOut:
      return l10n.cartTypeDeliveryOut;
  }
}

String stockInTypeLocalizedTitle(BuildContext context, String type) {
  final l10n = context.l10n;
  switch (type) {
    case 'submission_in':
      return l10n.cartStockInSubmission;
    case 'purchase':
      return l10n.cartStockInPurchase;
    case 'remove':
      return l10n.cartStockInRemove;
    case 'return':
      return l10n.cartStockInReturn;
    case 'other':
      return l10n.cartStockInOther;
    case 'cancel':
      return l10n.cartStockInCancel;
    case 'transfer_in':
      return l10n.cartStockInTransfer;
    case 'borrow_in':
      return l10n.cartStockInBorrow;
    case 'inventory_in':
      return l10n.cartStockInInventory;
    default:
      return l10n.cartStockInTypeNotSet;
  }
}

String borrowReasonLocalizedTitle(BuildContext context, String id) {
  final l10n = context.l10n;
  switch (id) {
    case 'customer_meeting':
      return l10n.cartBorrowReasonCustomerMeeting;
    case 'pricing_quote':
      return l10n.cartBorrowReasonPricingQuote;
    case 'exhibition':
      return l10n.cartBorrowReasonExhibition;
    case 'group_shipment_sample':
      return l10n.cartBorrowReasonGroupShipment;
    case borrowReasonOther:
      return l10n.cartBorrowReasonOther;
    default:
      return id;
  }
}

String cartOperateLabel(BuildContext context, CartType? type) {
  if (type == null) return context.l10n.cartConfirm;
  final l10n = context.l10n;
  switch (type) {
    case CartType.borrowOut:
      return l10n.cartOperateBorrow;
    case CartType.borrowIn:
      return l10n.cartOperateReturn;
    case CartType.transferIn:
      return l10n.cartTransferIn;
    case CartType.transferOut:
      return l10n.cartTransferOut;
    case CartType.quotation:
      return l10n.cartOperateQuotation;
    case CartType.inout:
      return l10n.cartOperateInventory;
    case CartType.deliveryOut:
      return l10n.cartDeliveryOut;
    case CartType.stockIn:
      return l10n.cartStockIn;
  }
}
