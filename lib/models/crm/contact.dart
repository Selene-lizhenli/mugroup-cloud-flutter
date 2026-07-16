import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/log.dart';
import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

List<String>? _stringOrStringListToList(dynamic value) {
  if (value == null) return null;
  if (value is String) return [value];
  if (value is List) return value.map((e) => e.toString()).toList();
  return null;
}

@freezed
class Contact with _$Contact {
  factory Contact(
    int? id,
    String? name,
    String? location,
    String? position,
    String? birthday,
    @JsonKey(name: 'tel_number') String? telNumber,
    @JsonKey(name: 'company_id') int? companyId,
    Company? company,
    @JsonKey(fromJson: _stringOrStringListToList) List<String>? whatsapp,
    @JsonKey(fromJson: _stringOrStringListToList) List<String>? email,
    @JsonKey(fromJson: _stringOrStringListToList) List<String>? linkedin,
    @JsonKey(fromJson: _stringOrStringListToList) List<String>? facebook,
    User? head,
    String? mobile,
    List<Log>? logs,
  ) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
