import 'package:cloud/models/media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'sample.freezed.dart';
part 'sample.g.dart';

@freezed
abstract class Sample with _$Sample {
  const factory Sample({
    int? id,
    String? barcode,
    @JsonKey(name: 'name_cn') String? nameCn,
    @JsonKey(name: 'product_no') String? productNo,
    @JsonKey(name: 'purchase_cost') String? purchaseCost,
    String? spec,
    List<Media>? image,
  }) = _Sample;

  factory Sample.fromJson(Map<String, Object?> json) => _$SampleFromJson(json);
}
