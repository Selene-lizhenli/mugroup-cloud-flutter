import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

bool showroomPreferChinese(BuildContext context) =>
    Localizations.localeOf(context).languageCode.startsWith('zh');

String showroomUnknown(BuildContext context) => context.l10n.cartUnknown;

String showroomFieldLine(BuildContext context, String label, String? value) {
  final display = (value == null || value.isEmpty)
      ? showroomUnknown(context)
      : value;
  return '$label $display';
}
