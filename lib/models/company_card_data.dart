import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_card_data.freezed.dart';
part 'company_card_data.g.dart';

@freezed
abstract class CompanyCardData with _$CompanyCardData {
  const factory CompanyCardData({
    String? name,
    String? address,
    String? location,
    String? industry,
    @Default([]) List<String> domain,
    @Default([]) List<String> email,
    @Default([]) List<String> linkedin,
    @Default([]) List<String> whatsapp,
    @Default([]) List<String> facebook,
    @Default([]) List<Contact> contact,
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

