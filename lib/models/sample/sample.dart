import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'sample.freezed.dart';
part 'sample.g.dart';

@freezed
abstract class Sample with _$Sample {
  const factory Sample({
    int? id,
    @JsonKey(name: 'name_cn') String? nameCn,
  }) = _Sample;

  factory Sample.fromJson(Map<String, Object?> json) => _$SampleFromJson(json);
}
