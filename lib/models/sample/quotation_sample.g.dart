// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuotationSampleImpl _$$QuotationSampleImplFromJson(
        Map<String, dynamic> json) =>
    _$QuotationSampleImpl(
      id: (json['id'] as num?)?.toInt(),
      price: json['price'] as String?,
      customerProductNo: json['customer_product_no'] as String?,
      qty: (json['qty'] as num?)?.toInt(),
      showroomSample: json['showroomSample'] == null
          ? null
          : Sample.fromJson(json['showroomSample'] as Map<String, dynamic>),
      supplyQuote: json['supplyQuote'] == null
          ? null
          : Quote.fromJson(json['supplyQuote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QuotationSampleImplToJson(
        _$QuotationSampleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'customer_product_no': instance.customerProductNo,
      'qty': instance.qty,
      'showroomSample': instance.showroomSample,
      'supplyQuote': instance.supplyQuote,
    };
