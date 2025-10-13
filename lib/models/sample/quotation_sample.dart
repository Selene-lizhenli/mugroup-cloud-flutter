import 'package:cloud/models/sample/sample.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quotation_sample.freezed.dart';
part 'quotation_sample.g.dart';

@freezed
class QuotationSample with _$QuotationSample {
  factory QuotationSample({
    int? id,
    String? price,
    int? qty,
    @JsonKey(name: 'showroomSample') Sample? showroomSample,
  }) = _QuotationSample;

  factory QuotationSample.fromJson(Map<String, dynamic> json) =>
      _$QuotationSampleFromJson(json);
}
