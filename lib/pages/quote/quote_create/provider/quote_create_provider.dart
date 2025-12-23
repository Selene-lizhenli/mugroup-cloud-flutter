import 'dart:async';
import 'dart:convert';

import 'package:cloud/helper/helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _draftKey = 'quote_draft';

enum QuoteCreateStep {
  baseInfo,
  products,
  review,
}

class QuoteCreateState {
  // ================= 流程 =================
  final QuoteCreateStep step;

  // ================= 报价单表单 =================
  final String? customer; // 最终选中的客户
  final String? contact;
  final String? language;
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
  // ================= 客户选择（merge 自 customer_select） =================

  /// 客户原始列表
  final List<String> customers;

  final String customerKeyword;

  /// 选择器中的选中（支持多选）
  final List<String> selectedCustomers;
  QuoteCreateState({
    // flow
    this.step = QuoteCreateStep.baseInfo,

    // form
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
    this.selectedCustomers = const [],
  }) : quoteDate = quoteDate ?? DateTime.now();

  // ================= 派生状态（只读） =================

  int get stepIndex => step.index;

  bool get hasPrevious => stepIndex > 0;

  bool get isLastStep => step == QuoteCreateStep.review;

  String get nextButtonText => isLastStep ? '完成' : '下一步';

  bool get canGoNext {
    switch (step) {
      case QuoteCreateStep.baseInfo:
        return true;
      case QuoteCreateStep.products:
        return true;
      case QuoteCreateStep.review:
        return true;
    }
  }

  /// 🔥 过滤后的客户列表
  List<String> get filteredCustomers {
    if (customerKeyword.isEmpty) return customers;
    return customers
        .where(
          (c) => c.toLowerCase().contains(customerKeyword.toLowerCase()),
        )
        .toList();
  }

  bool isCustomerSelected(String value) {
    return selectedCustomers.contains(value);
  }

  QuoteCreateState copyWith({
    QuoteCreateStep? step,

    // form
    String? customer,
    String? contact,
    String? language,
    String? currency,
    DateTime? quoteDate,
    String? addPercentage,
    String? rate,

    // draft / submit
    bool? savingDraft,
    bool? draftSaved,
    bool? submitting,

    // customer select
    List<String>? customers,
    String? customerKeyword,
    List<String>? selectedCustomers,
    List<dynamic>? productList,
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
    );
  }
}

class QuoteCreateNotifier extends StateNotifier<QuoteCreateState> {
  QuoteCreateNotifier()
      : super(
          QuoteCreateState(
            customers: [
              '测试客户123',
              'Walmart',
              '1111',
              '批量上传演示',
            ],
          ),
        );

  // ================= step =================

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

  void setCustomer(String value) {
    state = state.copyWith(
      customer: value,
      selectedCustomers: [value],
    );
  }

  void setContact(String value) {
    state = state.copyWith(contact: value);
  }

  void setLanguage(String value) {
    state = state.copyWith(language: value);
  }

  void setCurrency(String value) {
    state = state.copyWith(currency: value);
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

  // ================= 客户选择  =================

  void setCustomerKeyword(String value) {
    state = state.copyWith(customerKeyword: value);
  }

  void clearCustomerKeyword() {
    state = state.copyWith(customerKeyword: '');
  }

  void setProductList(List<dynamic> value) {
    state = state.copyWith(productList: value);
  }

  /// 单选（你现在用这个）
  void selectCustomerFromList(String value) {
    state = state.copyWith(
      customer: value,
      selectedCustomers: [value],
    );
  }

  /// 多选（为以后准备）
  void toggleCustomer(String value) {
    final list = [...state.selectedCustomers];
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }

    state = state.copyWith(
      selectedCustomers: list,
      customer: list.isNotEmpty ? list.first : null,
    );
  }

  // ================= 草稿 =================
  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_draftKey);
    if (json == null) return;

    final map = jsonDecode(json) as Map<String, dynamic>;

    state = state.copyWith(
      step: QuoteCreateStep.values[map['step'] ?? 0],
      customer: map['customer'],
      contact: map['contact'],
      language: map['language'],
      currency: map['currency'] ?? state.currency,
      quoteDate: map['quoteDate'] != null
          ? DateTime.parse(map['quoteDate'])
          : state.quoteDate,
      rate: map['rate'] ?? state.rate,
      addPercentage: map['addPercentage'] ?? state.addPercentage,
    );
  }

  Future<void> saveDraft() async {
    if (state.savingDraft) return;

    state = state.copyWith(
      savingDraft: true,
      draftSaved: false,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _draftKey,
      jsonEncode({
        'step': state.stepIndex,
        'customer': state.customer,
        'contact': state.contact,
        'language': state.language,
        'currency': state.currency,
        'quoteDate': state.quoteDate.toIso8601String(),
        'rate': state.rate,
        'addPercentage': state.addPercentage,
      }),
    );

    state = state.copyWith(
      savingDraft: false,
      draftSaved: true,
    );
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
