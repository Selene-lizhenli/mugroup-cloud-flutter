import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/widgets.dart';

String stationDetailThemeLabel(BuildContext context, String? theme) {
  if (theme == null || theme.isEmpty) return '—';
  final t = theme.toLowerCase();
  final l10n = context.l10n;
  if (t.contains('meimeiimage')) return l10n.stationThemeMeimeiImage;
  if (t.contains('christmas')) return l10n.stationThemeChristmas;
  if (t.contains('default')) return l10n.stationThemeDefault;
  return theme;
}
