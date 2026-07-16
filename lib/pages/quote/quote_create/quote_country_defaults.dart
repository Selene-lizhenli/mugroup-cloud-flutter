import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/helper/exchange.dart';

/// shortName -> 国家/货币 关键字静态映射表
/// 按照汇率接口中的 name 来补充，同时增加国家名称，便于 location 匹配
const Map<String, String> shortNameToCountry = {
  // 日元（兼容老的 JAY）
  'JAY': '日本,日元',
  'JPY': '日本,日元',

  // 美元
  'USD': '美国,美元,美金,usa,united states',

  // 欧元
  'EUR': '欧元,欧元区,法国,比利时',

  // 英镑
  'GBP': '英国,英镑,uk,united kingdom',

  // 人民币
  'CNY': '中国,人民币,cny,rmb',

  // 澳大利亚元
  'AUD': '澳大利亚,澳大利亚元,澳元,australia',

  // 加拿大元
  'CAD': '加拿大,加拿大元,加元,canada',

  // 俄罗斯卢布
  'RUB': '俄罗斯,卢布,russia',
  // 沙特里亚尔
  'SAR': '沙特,沙特阿拉伯,沙特里亚尔,saudi arabia',
  // 新加坡元
  'SGD': '新加坡,新加坡元,singapore',
  // 印度卢比
  'INR': '印度,印度卢比,india',

  // 土耳其里拉
  'TRY': '土耳其,土耳其里拉,turkey',

  // 韩元
  'KRW': '韩国,韩元,韩圆,korea',
};

/// 根据 shortName 获取国家
String? getCountryByShortName(String? shortName) {
  if (shortName == null || shortName.trim().isEmpty) return null;
  return shortNameToCountry[shortName.trim().toUpperCase()];
}

/// 根据客户 location 从汇率列表中匹配一条汇率。
/// 匹配规则：客户的 location 包含该条汇率的 name 或 short_name 即视为匹配。
Map? findRateByCustomerLocation(
  String? customerLocation,
  List<ExchangeRate>? rates,
) {
  if (customerLocation == null ||
      customerLocation.trim().isEmpty ||
      rates == null ||
      rates.isEmpty) {
    return null;
  }

  ExchangeRate? rateValue;
  final language = mapCountryToLanguage(customerLocation);
  final location = customerLocation.trim().toLowerCase();

  for (final rate in rates) {
    final name = (rate.name ?? '').trim().toLowerCase();
    final shortName = (rate.shortName ?? '').trim().toLowerCase();
    final countryKeywords =
        getCountryByShortName(rate.shortName)?.split(RegExp(r'[，,]'));

    if (name.isEmpty && shortName.isEmpty) continue;

    bool matched = false;

    if (name.isNotEmpty && location.contains(name)) {
      matched = true;
    } else if (shortName.isNotEmpty && location.contains(shortName)) {
      matched = true;
    } else if (countryKeywords != null) {
      for (final raw in countryKeywords) {
        final keyword = raw.trim().toLowerCase();
        if (keyword.isEmpty) continue;
        if (location.contains(keyword)) {
          matched = true;
          break;
        }
      }
    }
    if (matched) rateValue = rate;
  }
  final data = {
    ...rateValue != null ? {'rate': rateValue} : {},
    'language': language,
  };
  return data;
}
