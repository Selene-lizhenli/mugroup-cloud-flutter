import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quotation.freezed.dart';
part 'quotation.g.dart';

@freezed
class Quotation with _$Quotation {
  factory Quotation({
    int? id,
    User? user,
    String? exchange,
    bool? showPrice,
    List<QuotationSample>? quotationSamples,
    @JsonKey(name: 'commission_rate') String? commissionRate,
    @JsonKey(name: 'inquiry_at') DateTime? inquiryAt,
    @JsonKey(name: 'quote_at') DateTime? quoteAt,
  }) = _Quotation;

  factory Quotation.fromJson(Map<String, dynamic> json) =>
      _$QuotationFromJson(json);
}
