import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/quote/export_template.dart';
import 'package:cloud/models/quote/quote_supplier_group.dart';
import 'package:cloud/models/sample/quotation_sample.dart';

enum ProductViewMode {
  supplier,
  time,
}

class QuoteDetailState {
  final bool isBaseLoading;
  final bool isProductLoading;
  final bool isTemplateLoading;

  final QuotationList? baseInfo;
  final List<QuotationSample> products;
  final List<ExportTemplate> dynamicTemplates;

  final String? baseError;
  final String? productError;
  final String? supplierError;
  final String? templateError;

  // ===== 新增：产品分页 =====
  final int productPage;
  final int productTotalPages;
  final String productTotalCount;
  final bool isSupplierLoading;
  final List<QuoteSupplierGroup> suppliers;
  final ProductViewMode productViewMode;

  const QuoteDetailState({
    this.isBaseLoading = false,
    this.isProductLoading = false,
    this.isTemplateLoading = false,
    this.baseInfo,
    this.products = const [],
    this.dynamicTemplates = const [],
    this.baseError,
    this.productError,
    this.productPage = 1,
    this.productTotalPages = 0,
    this.productTotalCount = '',
    this.isSupplierLoading = false,
    this.suppliers = const [],
    this.supplierError,
    this.templateError,
    this.productViewMode = ProductViewMode.time,
  });

  factory QuoteDetailState.initial({ProductViewMode? productViewMode}) {
    return QuoteDetailState(
      productViewMode: productViewMode ?? ProductViewMode.time,
    );
  }

  QuoteDetailState copyWith({
    bool? isBaseLoading,
    bool? isProductLoading,
    bool? isTemplateLoading,
    QuotationList? baseInfo,
    List<QuotationSample>? products,
    List<ExportTemplate>? dynamicTemplates,
    String? baseError,
    String? productError,
    String? templateError,
    int? productPage,
    int? productTotalPages,
    String? productTotalCount,
    bool? isSupplierLoading,
    List<QuoteSupplierGroup>? suppliers,
    String? supplierError,
    ProductViewMode? productViewMode,
  }) {
    return QuoteDetailState(
      isBaseLoading: isBaseLoading ?? this.isBaseLoading,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      isTemplateLoading: isTemplateLoading ?? this.isTemplateLoading,
      baseInfo: baseInfo ?? this.baseInfo,
      products: products ?? this.products,
      dynamicTemplates: dynamicTemplates ?? this.dynamicTemplates,
      baseError: baseError ?? this.baseError,
      productError: productError ?? this.productError,
      templateError: templateError ?? this.templateError,
      productPage: productPage ?? this.productPage,
      productTotalPages: productTotalPages ?? this.productTotalPages,
      productTotalCount: productTotalCount ?? this.productTotalCount,
      isSupplierLoading: isSupplierLoading ?? this.isSupplierLoading,
      suppliers: suppliers ?? this.suppliers,
      supplierError: supplierError ?? this.supplierError,
      productViewMode: productViewMode ?? this.productViewMode,
    );
  }
}
