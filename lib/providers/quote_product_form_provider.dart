import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quote_product_form_provider.g.dart';

/// 报价产品表单数据 Provider - 用于在横竖屏切换时保持表单数据
@riverpod
class QuoteProductFormData extends _$QuoteProductFormData {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  /// 保存表单数据
  void saveFormData(Map<String, dynamic> data) {
    state = Map<String, dynamic>.from(data);
  }

  /// 获取表单数据
  Map<String, dynamic>? getFormData() {
    return state;
  }

  /// 清除表单数据
  void clearFormData() {
    state = null;
  }
}

