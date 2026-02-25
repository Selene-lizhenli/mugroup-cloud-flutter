import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static final _deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getBaseInfo() async {
    if (Platform.isAndroid) {
      final a = await _deviceInfo.androidInfo;
      return {
        'platform': 'android',
        'manufacturer': a.manufacturer,  //厂商
        'brand': a.brand,  //品牌
        'model': a.model, // 型号
        'sdk': a.version.sdkInt, // SDK 版本
        'isPhysical': a.isPhysicalDevice,// 是否真机
      };
    }

    if (Platform.isIOS) {
      final i = await _deviceInfo.iosInfo;
      return {
        'platform': 'ios',
        'model': i.model,// iPhone
        'systemVersion': i.systemVersion, // 17.0
        'isPhysical': i.isPhysicalDevice,// 是否真机
      };
    }

    return {'platform': 'unknown'};
  }
}
