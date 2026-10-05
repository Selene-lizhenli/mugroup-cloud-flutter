import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quote_product_add_form_provider.g.dart';

@riverpod
class QuoteProductAddForm extends _$QuoteProductAddForm {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setInitialSupplier(Map<String, dynamic> supplierData) {
    if (state['supplier'] == null) {
      state = {
        ...state,
        'supplier': supplierData,
      };
    }
  }

  void updateForm(Map<String, dynamic> newData) {
    if (state.toString() != newData.toString()) {
      state = newData;
    }
  }

  void updateField(String key, dynamic value) {
    state = {...state, key: value};
  }

  void clearFormData() {
    state = {};
  }
}
