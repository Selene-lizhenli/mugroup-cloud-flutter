import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
class Contact with _$Contact {
  factory Contact(
    int? id,
    String? name,
    String? mobile,
    String? department,
    String? sex,
    String? position,
    String? phone,
    String? fax,
    String? email,
    String? qq,
    String? wechat,
    String? remark,
  ) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
