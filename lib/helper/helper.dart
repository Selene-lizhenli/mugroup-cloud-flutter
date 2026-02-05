import 'package:logger/logger.dart';

final logger = Logger();

bool isUrl(String result) {
  // 正则表达式匹配 HTTP/HTTPS、FTP、电子邮件、电话、短信、地理位置、WhatsApp 等协议
  RegExp urlRegex = RegExp(
    r'^(https?|ftp|mailto|tel|sms|geo|whatsapp):\/\/[^\s]+$',
    caseSensitive: false,
  );
  return urlRegex.hasMatch(result);
}

/// 格式化数字：大于999使用k表示
/// 例如：999 -> "999", 1000 -> "1k", 1300 -> "1.3k", 2000 -> "2k"
///
/// 参数：
/// - [value]: 要格式化的数值（可以是 int 或 double）
///
/// 返回格式化后的字符串
String formatNumberWithK(num value) {
  final intValue = value.toInt();
  if (intValue < 1000) {
    return intValue.toString();
  }
  // 转换为k格式，保留一位小数
  final kValue = intValue / 1000;
  // 如果小数部分为0，则不显示小数
  if (kValue == kValue.toInt()) {
    return '${kValue.toInt()}k';
  }
  // 保留一位小数
  return '${kValue.toStringAsFixed(1)}k';
}

/// 处理金额的方法 返回w为单位，保留一位小数，四舍五入
/// 例如 1016856 ==> 101.7w
String formatCurrencyAmount(amount) {
  if (amount == null) return '';
  final double amountDouble = amount.toDouble();
  if (amountDouble >= 10000) {
    double wanAmount = amountDouble / 10000;
    // 使用 toStringAsFixed(1) 保留一位小数，例如 123456 -> 12.3w
    return wanAmount.toStringAsFixed(2);
  } else {
    // 金额小于10000，直接显示原始金额
    return amountDouble.toStringAsFixed(0);
  }
}

/// 将时间字符串格式化为 "yyyy-MM-dd HH:mm:ss"
/// - 支持直接传入 ISO8601 / 标准 DateTime 字符串
/// - 解析失败时返回原始字符串或 '—'
String formatDateTimeFull(String? value) {
  if (value == null || value.isEmpty) return '—';
  try {
    final dt = DateTime.tryParse(value);
    if (dt == null) return value;

    String two(int n) => n.toString().padLeft(2, '0');

    final y = dt.year.toString().padLeft(4, '0');
    final m = two(dt.month);
    final d = two(dt.day);
    final h = two(dt.hour);
    final min = two(dt.minute);
    final s = two(dt.second);

    return '$y-$m-$d $h:$min:$s';
  } catch (_) {
    return value;
  }
}

/// 设备类型枚举
enum DeviceType {
  iosPhone, // 苹果手机（iPhone/iPod）
  iosPad, // 苹果平板（iPad）
  macOs, // 苹果电脑（MacOS）
  windows, // Windows 电脑
  linux, // Linux 电脑
  androidPhone, // Android 手机
  androidPad, // Android 平板
  unknown, // 未知设备
}

/// 解析 UA 并返回设备类型
/// [ua]：用户传入的 User-Agent 字符串
/// 返回值：包含设备类型枚举和描述的 Map
Map<String, dynamic> parseUaDeviceType(String? ua) {
  // 处理空 UA 或空字符串
  if (ua == null || ua.isEmpty) {
    return {
      'type': DeviceType.unknown,
      'description': '未知设备',
    };
  }

  // 统一转为小写，避免大小写干扰
  final String lowerUa = ua.toLowerCase();

  // 1. 判断苹果设备（优先级：手机/平板 > 电脑）
  if (lowerUa.contains('iphone') || lowerUa.contains('ipod')) {
    return {
      'type': DeviceType.iosPhone,
      'description': '苹果手机',
    };
  } else if (lowerUa.contains('ipad')) {
    return {
      'type': DeviceType.iosPad,
      'description': '苹果平板',
    };
  } else if (lowerUa.contains('mac os x') || lowerUa.contains('macos')) {
    // 排除 iOS 设备伪装（iOS 设备 UA 也会包含 "Mac OS X"，但已先判断过手机/平板）
    return {
      'type': DeviceType.macOs,
      'description': '苹果电脑',
    };
  }

  // 2. 判断 Windows 设备
  else if (lowerUa.contains('windows')) {
    return {
      'type': DeviceType.windows,
      'description': 'Windows 设备',
    };
  }

  // 3. 判断 Linux 设备
  else if (lowerUa.contains('linux')) {
    return {
      'type': DeviceType.linux,
      'description': 'Linux 设备',
    };
  }

  // 4. 判断 Android 设备（区分手机/平板）
  else if (lowerUa.contains('android')) {
    if (lowerUa.contains('tablet') ||
        lowerUa.contains('pad') ||
        (lowerUa.contains('android') && !lowerUa.contains('mobile'))) {
      return {
        'type': DeviceType.androidPad,
        'description': 'Android 平板',
      };
    } else {
      return {
        'type': DeviceType.androidPhone,
        'description': 'Android 手机',
      };
    }
  }

  // 5. 未知设备
  else {
    return {
      'type': DeviceType.unknown,
      'description': '未知设备',
    };
  }
}

