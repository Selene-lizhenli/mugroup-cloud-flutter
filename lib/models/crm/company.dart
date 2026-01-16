import 'package:cloud/models/crm/contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
class Company with _$Company {
  factory Company(
    int? id,
    String? name,
    @JsonKey(name: "user_id") int? userId,
    String? address,
    String? industry,
    String? location,
    String? source,
    List<String?>? domain,
    List<String?>? email,
    List<String?>? facebook,
    List<String?>? linkedin,
    List<String?>? whatsapp,
    List<Contact?>? contacts,
  ) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
}
