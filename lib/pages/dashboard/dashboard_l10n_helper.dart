export 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';
import 'package:cloud/pages/dashboard/widgets/date_select.dart';
import 'package:flutter/material.dart';

String dashboardTimeDimensionMenuValue(TimeDimension dimension) {
  switch (dimension) {
    case TimeDimension.last6Months:
      return 'last6Months';
    case TimeDimension.last12Months:
      return 'last12Months';
    case TimeDimension.allTime:
      return 'allTime';
  }
}

TimeDimension? dashboardTimeDimensionFromMenuValue(String value) {
  switch (value) {
    case 'last6Months':
      return TimeDimension.last6Months;
    case 'last12Months':
      return TimeDimension.last12Months;
    case 'allTime':
      return TimeDimension.allTime;
  }
  return null;
}

extension DashboardL10nHelper on BuildContext {
  String dashboardTimeDimensionLabel(TimeDimension dimension) {
    final l10n = this.l10n;
    switch (dimension) {
      case TimeDimension.last6Months:
        return l10n.dashboardLast6Months;
      case TimeDimension.last12Months:
        return l10n.dashboardLast12Months;
      case TimeDimension.allTime:
        return l10n.dashboardAllTime;
    }
  }

  String dashboardDateRangeLabel(DateRange range) {
    final l10n = this.l10n;
    switch (range) {
      case DateRange.allTime:
        return l10n.dashboardAllTime;
      case DateRange.lastTwoYear:
        return l10n.dashboardLastTwoYears;
      case DateRange.lastYear:
        return l10n.dashboardLast12Months;
      case DateRange.lastHalfYear:
        return l10n.dashboardLast6Months;
    }
  }

  String dashboardSampleDimensionLabel(String value) {
    switch (value) {
      case 'quote_rank':
        return l10n.dashboardSampleQuoteRank;
      default:
        return value;
    }
  }

  String dashboardFormatMonthLabel(String label) {
    if (label.endsWith('月')) {
      final month = int.tryParse(label.replaceAll('月', ''));
      if (month != null) {
        return l10n.dashboardMonthLabel(month);
      }
    }
    final month = int.tryParse(label);
    if (month != null) {
      return l10n.dashboardMonthLabel(month);
    }
    return label;
  }
}
