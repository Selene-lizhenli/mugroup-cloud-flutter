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
