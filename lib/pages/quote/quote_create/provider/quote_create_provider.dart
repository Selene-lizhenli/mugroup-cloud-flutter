import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_language_sheet.dart';
import 'package:cloud/services/crm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; 
 

enum QuoteCreateStep {
  baseInfo,
  products,
}

class QuoteCreateState { 

  // ================= 报价单表单 =================
  final String? customer; // 最终选中的客户
  final String? contact; // 联系人id
  final LanguageItem? language;
  final String currency;

  final DateTime quoteDate;
  final String rate;
  final String addPercentage;

  final bool draftSaved;
  final bool submitting; 
  // ================= 客户选择  =================

  final List<Company> customers;
  final String customerKeyword;
  final Company? selectedCustomers;

  // ================= 联系人选择  =================

  final Contact? selectedContact;
  final String contactKeyword;

  QuoteCreateState({ 
    this.customer,
    this.contact, // 联系人id
    this.language = const LanguageItem(name: '英语(EN)', code: 'EN'),
    this.currency = '美元 (USD)',
    DateTime? quoteDate,
    this.rate = '1.00000',
    this.addPercentage = '0', 
    this.draftSaved = false,
    this.submitting = false,

    // customer select
    this.customers = const [],
    this.customerKeyword = '',
    this.selectedCustomers,

    // contact select
    this.selectedContact,
    this.contactKeyword = '',
  }) : quoteDate = quoteDate ?? DateTime.now();

  QuoteCreateState copyWith({ 
    // form
    String? customer,
    String? contact,
    LanguageItem? language,
    String? currency,
    DateTime? quoteDate,
    String? addPercentage,
    String? rate,
    bool? draftSaved,
    bool? submitting,

    // customer select
    List<Company>? customers,
    String? customerKeyword,
    Company? selectedCustomers, 

    // contact select
    Contact? selectedContact,
    String? contactKeyword,
  }) {
    return QuoteCreateState( 
      customer: customer ?? this.customer,
      contact: contact ?? this.contact,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      quoteDate: quoteDate ?? this.quoteDate,
      rate: rate ?? this.rate,
      addPercentage: addPercentage ?? this.addPercentage,
      draftSaved: draftSaved ?? this.draftSaved,
      submitting: submitting ?? this.submitting,
      customers: customers ?? this.customers,
      customerKeyword: customerKeyword ?? this.customerKeyword,
      selectedCustomers: selectedCustomers ?? this.selectedCustomers, 
      selectedContact: selectedContact ?? this.selectedContact,
      contactKeyword: contactKeyword ?? this.contactKeyword,
    );
  }
}

class QuoteCreateNotifier extends StateNotifier<QuoteCreateState> {
  QuoteCreateNotifier() : super(QuoteCreateState());

 

// 设置选中的联系人id
  void setContact(String value) {
    state = state.copyWith(contact: value);
  }
// 设置选中的联系人
  void setSelectedContact(Contact? value) {
    state = state.copyWith(
      selectedContact: value,
      contact: value?.id?.toString(),
    );
  }

  void clearContactKeyword() {
    state = state.copyWith(contactKeyword: '');
  }

  void setLanguage(LanguageItem value) {
    state = state.copyWith(language: value);
  }

  void setCurrency(String value) {
    state = state.copyWith(currency: value);
  }

  /// 设置货币和汇率
  void setCurrencyWithRate(String currency, String rate) {
    state = state.copyWith(
      currency: currency,
      rate: rate,
    );
  }

  void setQuoteDate(DateTime value) {
    state = state.copyWith(quoteDate: value);
  }

  void setRate(String value) {
    state = state.copyWith(rate: value);
  }

  void setAddPercentage(String value) {
    state = state.copyWith(addPercentage: value);
  }

//===================== 搜索客户  =================
  Future<void> loadCustomers() async {
    final params = {
      "pageSize": 30,
      "status": "normal",
      "page": 1,
      "search": state.customerKeyword,
    };
    final resp = await getCrmCompanies(queryParameters: params);
    final List<Company> companies = resp.data;
    state = state.copyWith(
      customers: companies,
    );
  }

  void setCustomerKeyword(String value) {
    state = state.copyWith(customerKeyword: value);
 
  }

  void clearCustomerKeyword() {
    state = state.copyWith(customerKeyword: '');
  }

  void setSelectedCustomer(Company value) {
    // 直接创建新状态对象，明确设置 null 值，避免 copyWith 的 null 处理问题
    state = QuoteCreateState( 
      customer: state.customer,
      contact: null, // 明确设置为 null
      language: state.language,
      currency: state.currency,
      quoteDate: state.quoteDate,
      rate: state.rate,
      addPercentage: state.addPercentage, 
      draftSaved: state.draftSaved,
      submitting: state.submitting,
      customers: state.customers,
      customerKeyword: state.customerKeyword,
      selectedCustomers: value,
      selectedContact: null, // 明确设置为 null
      contactKeyword: state.contactKeyword,
    );
  }

  /// 重置所有状态到初始值
  void reset() {
    state = QuoteCreateState();
  }

}

/// Provider
final quoteCreateProvider =
    StateNotifierProvider<QuoteCreateNotifier, QuoteCreateState>(
  (ref) => QuoteCreateNotifier(),
);
