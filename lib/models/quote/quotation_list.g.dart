// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuotationListImpl _$$QuotationListImplFromJson(Map<String, dynamic> json) =>
    _$QuotationListImpl(
      id: (json['id'] as num?)?.toInt(),
      quoteNo: json['quote_no'] as String?,
      inquiryAt: json['inquiry_at'] as String?,
      quoteAt: json['quote_at'] as String?,
      subCompany: json['sub_company'] as String?,
      curreny: json['curreny'] as String?,
      exchange: json['exchange'] as String?,
      offerType: json['offer_type'] as String?,
      priceClause: json['price_clause'] as String?,
      settlementType: json['settlement_type'] as String?,
      tradeCountry: json['trade_country'] as String?,
      outPort: json['out_port'] as String?,
      arrivalPort: json['arrival_port'] as String?,
      transport: json['transport'] as String?,
      commissionRate: json['commission_rate'] as String?,
      tradeType: json['trade_type'] as String?,
      status: json['status'] as String?,
      saleUser: json['sale_user'] as String?,
      collectionSource: json['collection_source'] as String?,
      collectionContent: json['collection_content'] as String?,
      remark: json['remark'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      userId: (json['user_id'] as num?)?.toInt(),
      creatorId: (json['creator_id'] as num?)?.toInt(),
      companyId: (json['company_id'] as num?)?.toInt(),
      itemType: json['item_type'] as String?,
      departmentId: (json['department_id'] as num?)?.toInt(),
      isTaxInclusive: json['is_tax_inclusive'] as bool?,
      productCount: (json['product_count'] as num?)?.toInt(),
      sumQty: json['sum_qty'] as String?,
      language: json['language'] as String?,
      contactId: json['contact_id'] as String?,
      lastSentAt: json['last_sent_at'] == null
          ? null
          : DateTime.parse(json['last_sent_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      creator: json['creator'] == null
          ? null
          : User.fromJson(json['creator'] as Map<String, dynamic>),
      company: json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QuotationListImplToJson(_$QuotationListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quote_no': instance.quoteNo,
      'inquiry_at': instance.inquiryAt,
      'quote_at': instance.quoteAt,
      'sub_company': instance.subCompany,
      'curreny': instance.curreny,
      'exchange': instance.exchange,
      'offer_type': instance.offerType,
      'price_clause': instance.priceClause,
      'settlement_type': instance.settlementType,
      'trade_country': instance.tradeCountry,
      'out_port': instance.outPort,
      'arrival_port': instance.arrivalPort,
      'transport': instance.transport,
      'commission_rate': instance.commissionRate,
      'trade_type': instance.tradeType,
      'status': instance.status,
      'sale_user': instance.saleUser,
      'collection_source': instance.collectionSource,
      'collection_content': instance.collectionContent,
      'remark': instance.remark,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'user_id': instance.userId,
      'creator_id': instance.creatorId,
      'company_id': instance.companyId,
      'item_type': instance.itemType,
      'department_id': instance.departmentId,
      'is_tax_inclusive': instance.isTaxInclusive,
      'product_count': instance.productCount,
      'sum_qty': instance.sumQty,
      'language': instance.language,
      'contact_id': instance.contactId,
      'last_sent_at': instance.lastSentAt?.toIso8601String(),
      'user': instance.user,
      'creator': instance.creator,
      'company': instance.company,
    };
