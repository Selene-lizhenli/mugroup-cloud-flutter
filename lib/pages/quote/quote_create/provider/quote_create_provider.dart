import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_language_sheet.dart';
import 'package:cloud/services/crm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _draftKey = 'quote_draft';

enum QuoteCreateStep {
  baseInfo,
  products,
}

class QuoteCreateState {
  // ================= 流程 =================
  final QuoteCreateStep step;

  // ================= 报价单表单 =================
  final String? customer; // 最终选中的客户
  final String? contact;
  final LanguageItem? language;
  final String currency;

  final DateTime quoteDate;
  final String rate;
  final String addPercentage;

  // ================= 草稿 / 提交 =================
  final bool savingDraft;
  final bool draftSaved;
  final bool submitting;

  // final bool isProductLoading;
  // final bool productError;
  final List<dynamic> productList;

  // ================= 客户选择  =================

  final List<Company> customers;
  final String customerKeyword;
  final Company? selectedCustomers;

  // ================= 联系人选择  =================

  final Contact? selectedContact;
  final String contactKeyword;

  QuoteCreateState({
    this.step = QuoteCreateStep.baseInfo,
    this.customer,
    this.contact,
    this.language,
    this.currency = '人民币 (CNY)',
    DateTime? quoteDate,
    this.rate = '1.00000',
    this.addPercentage = '0',

    // product
    // this.isProductLoading = false,
    // this.productError = false,
    this.productList = const [],

    // draft / submit
    this.savingDraft = false,
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

  // ================= 派生状态（只读） =================
  int get stepIndex => step.index;
  bool get hasPrevious => stepIndex > 0;
  bool get isLastStep => step == QuoteCreateStep.products;
  String get nextButtonText => isLastStep ? '完成' : '下一步';

  bool get canGoNext {
    switch (step) {
      case QuoteCreateStep.baseInfo:
        return true;
      case QuoteCreateStep.products:
        return true;
    }
  }

  bool isCustomerSelected(String value) {
    // return selectedCustomers.contains(value);
    return false;
  }

  QuoteCreateState copyWith({
    QuoteCreateStep? step,

    // form
    String? customer,
    String? contact,
    LanguageItem? language,
    String? currency,
    DateTime? quoteDate,
    String? addPercentage,
    String? rate,

    // draft / submit
    bool? savingDraft,
    bool? draftSaved,
    bool? submitting,

    // customer select
    List<Company>? customers,
    String? customerKeyword,
    Company? selectedCustomers,
    List<dynamic>? productList,

    // contact select
    Contact? selectedContact,
    String? contactKeyword,
  }) {
    return QuoteCreateState(
      step: step ?? this.step,
      customer: customer ?? this.customer,
      contact: contact ?? this.contact,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      quoteDate: quoteDate ?? this.quoteDate,
      rate: rate ?? this.rate,
      addPercentage: addPercentage ?? this.addPercentage,
      savingDraft: savingDraft ?? this.savingDraft,
      draftSaved: draftSaved ?? this.draftSaved,
      submitting: submitting ?? this.submitting,
      customers: customers ?? this.customers,
      customerKeyword: customerKeyword ?? this.customerKeyword,
      selectedCustomers: selectedCustomers ?? this.selectedCustomers,
      productList: productList ?? this.productList,
      selectedContact: selectedContact ?? this.selectedContact,
      contactKeyword: contactKeyword ?? this.contactKeyword,
    );
  }
}

class QuoteCreateNotifier extends StateNotifier<QuoteCreateState> {
  QuoteCreateNotifier() : super(QuoteCreateState());

//================= step =================
  void nextStep() {
    if (!state.canGoNext) return;
    if (state.isLastStep) {
      submit();
      return;
    }
    state = state.copyWith(
      step: QuoteCreateStep.values[state.stepIndex + 1],
    );
  }

  void previousStep() {
    if (!state.hasPrevious) return;
    state = state.copyWith(
      step: QuoteCreateStep.values[state.stepIndex - 1],
    );
  }

// ================= 表单 setters =================

  void setCustomer(Company value) {
    state = state.copyWith(
      // customer: value,
      selectedCustomers: value,
      // 切换客户时，清空已选的联系人
      selectedContact: null,
      contact: null,
    );
    logger.d("state$state");
  }

  void setContact(String value) {
    state = state.copyWith(contact: value);
  }

  void setSelectedContact(Contact value) {
    state = state.copyWith(
      selectedContact: value,
      contact: value.id?.toString(),
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
    //     state = state.copyWith(
    //   // customer: value,
    //   selectedCustomers: value,
    //   // 切换客户时，清空已选的联系人
    //   selectedContact: null,
    //   contact: null,
    // );
  }

  void clearCustomerKeyword() {
    state = state.copyWith(customerKeyword: '');
  }

  void setProductList(List<dynamic> value) {
    state = state.copyWith(productList: value);
  }

  void setSelectedCustomer(Company value) {
    // 强制清空联系人，即使选择的是同一个客户
    // 直接创建新状态对象，明确设置 null 值，避免 copyWith 的 null 处理问题
    final newState = QuoteCreateState(
      step: state.step,
      customer: state.customer,
      contact: null, // 明确设置为 null
      language: state.language,
      currency: state.currency,
      quoteDate: state.quoteDate,
      rate: state.rate,
      addPercentage: state.addPercentage,
      customers: state.customers,
      customerKeyword: state.customerKeyword,
      selectedCustomers: value,
      productList: state.productList,
      selectedContact: null, // 明确设置为 null
      contactKeyword: state.contactKeyword,
      savingDraft: state.savingDraft,
      draftSaved: state.draftSaved,
      submitting: state.submitting,
    );
    state = newState;
  }

  void clearDraftSavedFlag() {
    state = state.copyWith(draftSaved: false);
  }

  // ================= 提交 =================

  Future<void> submit() async {
    if (state.submitting) return;

    state = state.copyWith(submitting: true);

    // TODO: 提交报价单
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(submitting: false);
  }
}

/// Provider
final quoteCreateProvider =
    StateNotifierProvider<QuoteCreateNotifier, QuoteCreateState>(
  (ref) => QuoteCreateNotifier(),
);
