import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_card_data.freezed.dart';
part 'company_card_data.g.dart';

Map<String, dynamic>? _companyCardDataContactToJson(Contact? c) => c?.toJson();
Contact? _companyCardDataContactFromJson(dynamic json) =>
    json == null ? null : Contact.fromJson(json as Map<String, dynamic>);

@freezed
abstract class CompanyCardData with _$CompanyCardData {
  const factory CompanyCardData({
    String? name,
    String? address,
    String? location,
    String? industry,
    @Default([]) List<String>? domain,
    @Default([]) List<String>? email,
    @Default([]) List<String>? linkedin,
    @Default([]) List<String>? whatsapp,
    @Default([]) List<String>? facebook,
    @JsonKey(
      toJson: _companyCardDataContactToJson,
      fromJson: _companyCardDataContactFromJson,
    )
    Contact? contact,
  }) = _CompanyCardData;

  factory CompanyCardData.fromJson(Map<String, dynamic> json) =>
      _$CompanyCardDataFromJson(json);
}

@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    String? name,
    String? phone,
    String? mobile,
    String? position,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

