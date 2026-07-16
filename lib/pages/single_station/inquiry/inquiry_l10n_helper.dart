import 'package:cloud/helper/helper.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/widgets.dart';

String inquirySourceLabel(BuildContext context, String? ua) {
  final parsed = parseUaDeviceType(ua);
  final type = parsed['type'] as DeviceType? ?? DeviceType.unknown;
  final l10n = context.l10n;

  final desc = switch (type) {
    DeviceType.iosPhone => l10n.inquiryDeviceIosPhone,
    DeviceType.iosPad => l10n.inquiryDeviceIosPad,
    DeviceType.macOs => l10n.inquiryDeviceMacOs,
    DeviceType.windows => l10n.inquiryDeviceWindows,
    DeviceType.linux => l10n.inquiryDeviceLinux,
    DeviceType.androidPhone => l10n.inquiryDeviceAndroidPhone,
    DeviceType.androidPad => l10n.inquiryDeviceAndroidPad,
    DeviceType.unknown => l10n.inquiryDeviceUnknown,
  };

  final lowerUa = ua?.toLowerCase() ?? '';
  if (lowerUa.contains('wxwork')) {
    return l10n.inquirySourceWithWework(desc);
  }
  return desc;
}
