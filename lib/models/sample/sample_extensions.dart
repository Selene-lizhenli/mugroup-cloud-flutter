import 'package:cloud/models/sample/sample.dart';

extension SampleLocalizedName on Sample {
  /// 按语言优先返回样品名称：中文环境中文名→英文名，英文环境英文名→中文名。
  String localizedName({required bool preferChinese}) {
    final cn = nameCn?.trim();
    final en = nameEn?.trim();
    if (preferChinese) {
      if (cn != null && cn.isNotEmpty) return cn;
      if (en != null && en.isNotEmpty) return en;
    } else {
      if (en != null && en.isNotEmpty) return en;
      if (cn != null && cn.isNotEmpty) return cn;
    }
    return '';
  }
}
