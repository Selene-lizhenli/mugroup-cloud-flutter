import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud/models/user.dart';

part 'quotation_list.freezed.dart';
part 'quotation_list.g.dart';

@freezed
class QuotationList with _$QuotationList {
  factory QuotationList({
    int? id,
    @JsonKey(name: 'quote_no') String? quoteNo,
    @JsonKey(name: 'inquiry_at') String? inquiryAt,
    @JsonKey(name: 'quote_at') String? quoteAt,
    @JsonKey(name: 'sub_company') String? subCompany,
    String? curreny,
    String? exchange,
    @JsonKey(name: 'offer_type') String? offerType,
    @JsonKey(name: 'price_clause') String? priceClause,
    @JsonKey(name: 'settlement_type') String? settlementType,
    @JsonKey(name: 'trade_country') String? tradeCountry,
    @JsonKey(name: 'out_port') String? outPort,
    @JsonKey(name: 'arrival_port') String? arrivalPort,
    String? transport,
    @JsonKey(name: 'commission_rate') String? commissionRate,
    @JsonKey(name: 'trade_type') String? tradeType,
    String? status,
    @JsonKey(name: 'sale_user') String? saleUser,
    @JsonKey(name: 'collection_source') String? collectionSource,
    @JsonKey(name: 'collection_content') String? collectionContent,
    String? remark,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'creator_id') int? creatorId,
    @JsonKey(name: 'company_id') String? companyId,
    @JsonKey(name: 'item_type') String? itemType,
    @JsonKey(name: 'department_id') int? departmentId,
    @JsonKey(name: 'is_tax_inclusive') bool? isTaxInclusive,
    @JsonKey(name: 'product_count') int? productCount,
    @JsonKey(name: 'sum_qty') String? sumQty,
    @JsonKey(name: 'last_sent_at') DateTime? lastSentAt,
    User? user,
    User? creator,
  }) = _QuotationList;

  factory QuotationList.fromJson(Map<String, dynamic> json) =>
      _$QuotationListFromJson(json);
}
