import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/crm/contact.dart';
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
    @JsonKey(name: 'company_id') int? companyId,
    @JsonKey(name: 'item_type') String? itemType,
    @JsonKey(name: 'department_id') int? departmentId,
    @JsonKey(name: 'is_tax_inclusive') bool? isTaxInclusive,
    @JsonKey(name: 'product_count') int? productCount,
    @JsonKey(name: 'sum_qty') String? sumQty,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'contact_id') String? contactId,
    @JsonKey(name: 'last_sent_at') DateTime? lastSentAt,
    List<User>? collaborators,
    User? user,
    User? creator,
    Company? company,
    Contact? contact,
  }) = _QuotationList;

  factory QuotationList.fromJson(Map<String, dynamic> json) =>
      _$QuotationListFromJson(json);
}



// [
//   {
//     "id": 306,
//     "quote_no": "PI202512100001",
//     "inquiry_at": "2025-12-04 00:00:00",
//     "quote_at": "2025-12-10 11:23:15",
//     "sub_company": "我方公司测试",
//     "curreny": "AUD",
//     "exchange": "0.22",
//     "offer_type": "直接外销价",
//     "price_clause": "22.33",
//     "settlement_type": "结汇方式1",
//     "trade_country": "美国",
//     "out_port": "出XX海岸",
//     "arrival_port": "目的XX海岸",
//     "transport": "by sea",
//     "commission_rate": "3.00",
//     "trade_type": "FOB贸易方式",
//     "status": "已报价",
//     "sale_user": null,
//     "collection_source": null,
//     "collection_content": null,
//     "remark": "备注",
//     "created_at": "2025-12-10T11:23:15+08:00",
//     "updated_at": "2025-12-16T10:07:17+08:00",
//     "user_id": 7614,
//     "creator_id": 7614,
//     "company_id": "4",
//     "item_type": "showroom",
//     "department_id": 1189,
//     "is_tax_inclusive": false,
//     "product_count": 1,
//     "sum_qty": "1",
//     "last_sent_at": null,
//     "user": {
//       "id": 7614,
//       "name": "王新",
//       "source_from": "core",
//       "job_number": "07520",
//       "last_login_at": "2025-12-10 11:58:47",
//       "has_password": true,
//       "phone": null,
//       "contact_email": null,
//       "contact_phone": null,
//       "contact_wechat": null,
//       "contact_fax": null,
//       "contact_address": null,
//       "work_location": "义乌",
//       "job": "后勤类",
//       "position": "后勤类",
//       "employ_status": 3,
//       "department": {
//         "id": 1189,
//         "parent_id": 1188,
//         "name": "数字研发部",
//         "name_en": "222"
//       }
//     },
//     "creator": {
//       "id": 7614,
//       "name": "王新",
//       "source_from": "core",
//       "job_number": "07520",
//       "last_login_at": "2025-12-10 11:58:47",
//       "has_password": true,
//       "phone": null,
//       "contact_email": null,
//       "contact_phone": null,
//       "contact_wechat": null,
//       "contact_fax": null,
//       "contact_address": null,
//       "work_location": "义乌",
//       "job": "后勤类",
//       "position": "后勤类",
//       "employ_status": 3
//     },
//     "company": {
//       "id": 4,
//       "user_id": 7614,
//       "parent_id": null,
//       "name": "33333333344444",
//       "created_at": "2025-11-20T06:03:02.000000Z",
//       "updated_at": "2025-11-24T08:10:48.000000Z",
//       "latest_logged_at": "2025-11-20 14:03:02",
//       "email": [],
//       "address": null,
//       "source": null,
//       "linkedin": [],
//       "whatsapp": [],
//       "facebook": [],
//       "industry": null,
//       "domain": null,
//       "location": null
//     }
//   }
// ]