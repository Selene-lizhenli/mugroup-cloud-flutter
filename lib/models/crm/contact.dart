import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/log.dart';
import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

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
    List<String>? whatsapp,
    List<String>? email,
    List<String>? linkedin,
    List<String>? facebook,
    User? head,
    String? mobile,
    List<Log>? logs,
  ) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
