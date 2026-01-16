import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/quote/quote_supplier_group.dart';
import 'package:cloud/models/sample/quotation_sample.dart'; 

class QuoteDetailState {
  final bool isBaseLoading;
  final bool isProductLoading;

  final QuotationList? baseInfo;
  final List<QuotationSample> products;

  final String? baseError;
  final String? productError;
  final String? supplierError;

  // ===== 新增：产品分页 =====
  final int productPage;
  final int productTotalPages;
  final String productTotalCount;
  final bool isSupplierLoading;
  final List<QuoteSupplierGroup> suppliers;

  const QuoteDetailState({
    this.isBaseLoading = false,
    this.isProductLoading = false,
    this.baseInfo,
    this.products = const [],
    this.baseError,
    this.productError,
    this.productPage = 1,
    this.productTotalPages = 0,
    this.productTotalCount = '',
    this.isSupplierLoading = false,
    this.suppliers = const [],
    this.supplierError,
  });

  factory QuoteDetailState.initial() {
    return const QuoteDetailState();
  }

  QuoteDetailState copyWith({
    bool? isBaseLoading,
    bool? isProductLoading,
    QuotationList? baseInfo,
    List<QuotationSample>? products,
    String? baseError,
    String? productError,
    int? productPage,
    int? productTotalPages,
    String? productTotalCount,
    bool? isSupplierLoading,
    List<QuoteSupplierGroup>? suppliers,
    String? supplierError,
  }) {
    return QuoteDetailState(
      isBaseLoading: isBaseLoading ?? this.isBaseLoading,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      baseInfo: baseInfo ?? this.baseInfo,
      products: products ?? this.products,
      baseError: baseError ?? this.baseError,
      productError: productError ?? this.productError,
      productPage: productPage ?? this.productPage,
      productTotalPages: productTotalPages ?? this.productTotalPages,
      productTotalCount: productTotalCount ?? this.productTotalCount,
      isSupplierLoading: isSupplierLoading ?? this.isSupplierLoading,
      suppliers: suppliers ?? this.suppliers,
      supplierError: supplierError ?? this.supplierError,
    );
  }
}
