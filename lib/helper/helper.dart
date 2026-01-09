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