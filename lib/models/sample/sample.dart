import 'package:cloud/models/media.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'sample.freezed.dart';
part 'sample.g.dart';

/// `xTenantId` 在 JSON 里可能是数字或字符串，统一解析为字符串。
String? _sampleXTenantIdFromJson(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num) return value.toString();
  return value.toString();
}

@freezed
abstract class Sample with _$Sample {
  const Sample._();

  const factory Sample({
    int? id,
    @JsonKey(name: 'xTenantId', fromJson: _sampleXTenantIdFromJson)
    String? xTenantId,
    String? barcode,
    String? packing,
    String? construction,
    String? remark,
    String? series,
    String? unit,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'name_cn') String? nameCn,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'product_no') String? productNo,
    @JsonKey(name: 'tax_rate') String? taxRate,
    @JsonKey(name: 'purchase_cost') String? purchaseCost,
    @JsonKey(name: 'page_no') String? pageNo,
    @JsonKey(name: 'trade_country') String? tradeCountry,
    @JsonKey(name: 'developed_at') String? developedAt,
    @JsonKey(name: 'description_cn') String? descriptionCn,
    @JsonKey(name: 'description_en') String? descriptionEn,
    @JsonKey(name: 'item_type') String? itemType,
    List<Quote>? supplyQuotes,
    String? spec,
    SampleCategory? category,
    List<Media>? image,
    List<Media>? audios,
  }) = _Sample;

  factory Sample.fromJson(Map<String, Object?> json) => _$SampleFromJson(json);

  String? get cover {
    return image?.elementAtOrNull(0)?.thumbUrl ??
        image?.elementAtOrNull(0)?.url;
  }

  String get name {
    return nameCn ?? nameEn ?? "";
  }

  bool? get hasTaxRate {
    bool? result;
    if (taxRate == null) {
      return result;
    }

    var numberTaxRate = double.tryParse(taxRate!);

    if (numberTaxRate == null) {
      return result;
    }

    result = numberTaxRate > 0;

    return result;
  }
}

@freezed
abstract class SampleCategory with _$SampleCategory {
  const factory SampleCategory({
    int? id,
    String? name,
  }) = _SampleCategory;

  factory SampleCategory.fromJson(Map<String, Object?> json) =>
      _$SampleCategoryFromJson(json);
}
