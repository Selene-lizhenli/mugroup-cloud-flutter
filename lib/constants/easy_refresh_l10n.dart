import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void configureEasyRefreshL10n(AppLocalizations l10n) {
  EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
        dragText: l10n.refreshPullDown,
        armedText: l10n.refreshRelease,
        readyText: l10n.refreshProcessing,
        processingText: l10n.refreshProcessing,
        processedText: l10n.refreshSucceeded,
        noMoreText: l10n.refreshNoMore,
        failedText: l10n.refreshFailed,
        messageText: l10n.refreshLastUpdatedAt,
      );

  EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
        dragText: l10n.refreshPullUp,
        armedText: l10n.refreshRelease,
        readyText: l10n.loadProcessing,
        processingText: l10n.loadProcessing,
        processedText: l10n.refreshSucceeded,
        noMoreText: l10n.refreshNoMore,
        failedText: l10n.refreshFailed,
        messageText: l10n.refreshLastUpdatedAt,
      );
}
