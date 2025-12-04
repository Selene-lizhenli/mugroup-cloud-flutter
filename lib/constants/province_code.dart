const Map<String, String> provinceNameToCode = {
  "北京市": "110000",
  "天津市": "120000",
  "河北省": "130000",
  "山西省": "140000",
  "内蒙古自治区": "150000",
  "辽宁省": "210000",
  "吉林省": "220000",
  "黑龙江省": "230000",
  "上海市": "310000",
  "江苏省": "320000",
  "浙江省": "330000",
  "安徽省": "340000",
  "福建省": "350000",
  "江西省": "360000",
  "山东省": "370000",
  "河南省": "410000",
  "湖北省": "420000",
  "湖南省": "430000",
  "广东省": "440000",
  "广西壮族自治区": "450000",
  "海南省": "460000",
  "重庆市": "500000",
  "四川省": "510000",
  "贵州省": "520000",
  "云南省": "530000",
  "西藏自治区": "540000",
  "陕西省": "610000",
  "甘肃省": "620000",
  "青海省": "630000",
  "宁夏回族自治区": "640000",
  "新疆维吾尔自治区": "650000",
  "台湾省": "710000",
  "香港特别行政区": "810000",
  "澳门特别行政区": "820000",
};

/// 根据省份名获取省份代码
String? getProvinceCode(String? name) {
  if (name == null || name.isEmpty) return null;

  if (provinceNameToCode.containsKey(name)) {
    return provinceNameToCode[name];
  }

  for (final entry in provinceNameToCode.entries) {
    final fullName = entry.key;
    if (fullName.contains(name)) {
      return entry.value;
    }
  }

  return null;
}
