import 'package:cloud/constants/app_feature_constants.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/widgets.dart';

extension EntryFeatureL10n on EntryFeature {
  String localizedTitle(BuildContext context) =>
      entryFeatureLocalizedTitle(context, id);
}

String entryFeatureLocalizedTitle(BuildContext context, String featureId) {
  final l10n = context.l10n;
  switch (featureId) {
    case 'showroom_sample':
      return l10n.samplesShowroom;
    case 'crm_company':
      return l10n.dashboardCustomer;
    case 'supply_supplier':
      return l10n.dashboardSupplier;
    case 'ecommerce_product_comparison':
      return l10n.featurePurchaseAssist;
    case 'market_purchase':
      return l10n.dashboardMarketPurchase;
    case 'showroom_station':
      return l10n.featureIndependentWebsite;
    case 'inspection':
      return l10n.dashboardInspection;
    case 'advice_collect':
      return l10n.featureAdviceCollect;
    case 'changxiang_inventory':
      return l10n.featureWarehouseManagement;
    case 'warehouse_receipts':
      return l10n.featureWarehouseReceipts;
    case 'rate':
      return l10n.featureTodayExchangeRate;
    default:
      return featureId;
  }
}
