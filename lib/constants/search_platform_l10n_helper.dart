import 'package:cloud/constants/core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String searchPlatformLabel(AppLocalizations l10n, String value) {
  switch (value) {
    case 'cloud':
      return l10n.searchPlatformCloud;
    case '1688':
      return l10n.searchPlatform1688;
    case 'amazon':
      return l10n.searchPlatformAmazon;
    case 'alibabaglobal':
      return l10n.searchPlatformAlibabaglobal;
    case 'yiwugo':
      return l10n.searchPlatformYiwugo;
    case 'chinagoods':
      return l10n.searchPlatformChinagoods;
    default:
      return value;
  }
}

List<SearchPlatformItem> localizedSearchPlatform(AppLocalizations l10n) {
  return searchPlatform
      .map(
        (item) => SearchPlatformItem(
          value: item.value,
          label: searchPlatformLabel(l10n, item.value),
        ),
      )
      .toList();
}
