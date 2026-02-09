 
/// 国家到语言的映射
/// 返回小写的语言代码（用于翻译 API）
Map<String, String?>? mapCountryToLanguage(String? country) {
  if (country == null || country.isEmpty) return null;

  final countryLower = country.toLowerCase();

  // 英语国家
  if (countryLower.contains('美国') ||
      countryLower.contains('united states') ||
      countryLower.contains('usa') ||
      countryLower.contains('uk') ||
      countryLower.contains('united kingdom') ||
      countryLower.contains('英国') ||
      countryLower.contains('canada') ||
      countryLower.contains('加拿大') ||
      countryLower.contains('australia') ||
      countryLower.contains('澳大利亚') ||
      countryLower.contains('new zealand') ||
      countryLower.contains('新西兰')) {
    return {"value": 'en', "lable": '英语'};
  }

  // 日语国家
  if (countryLower.contains('japan') || countryLower.contains('日本')) {
    return {"value": 'ja', "lable": '日语'};
  }

  // 西班牙语国家
  if (countryLower.contains('spain') ||
      countryLower.contains('西班牙') ||
      countryLower.contains('mexico') ||
      countryLower.contains('墨西哥') ||
      countryLower.contains('argentina') ||
      countryLower.contains('阿根廷') ||
      countryLower.contains('chile') ||
      countryLower.contains('智利') ||
      countryLower.contains('colombia') ||
      countryLower.contains('哥伦比亚') ||
      countryLower.contains('peru') ||
      countryLower.contains('秘鲁')) {
    return {"value": 'es', "lable": '西班牙语'};
  }

  // 葡萄牙语国家
  if (countryLower.contains('portugal') ||
      countryLower.contains('葡萄牙') ||
      countryLower.contains('brazil') ||
      countryLower.contains('巴西')) {
    return {"value": 'pt', "lable": '葡萄牙语'};
  }

  // 俄语国家
  if (countryLower.contains('russia') ||
      countryLower.contains('俄罗斯') ||
      countryLower.contains('russian')) {
    return {"value": 'ru', "lable": '俄语'};
  }

  // 法语国家
  if (countryLower.contains('france') ||
      countryLower.contains('法国') ||
      countryLower.contains('belgium') ||
      countryLower.contains('比利时') ||
      countryLower.contains('switzerland') && countryLower.contains('french') ||
      (countryLower.contains('canada') && countryLower.contains('quebec'))) {
    return {"value": 'fr', "lable": '法语'};
  }

  // 德语国家
  if (countryLower.contains('germany') ||
      countryLower.contains('德国') ||
      countryLower.contains('austria') ||
      countryLower.contains('奥地利') ||
      countryLower.contains('switzerland') ||
      countryLower.contains('瑞士')) {
    return {"value": 'de', "lable": '德语'};
  }

  // 默认返回英语
  return {"value": 'en', "lable": '英语'};
}
