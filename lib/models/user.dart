import 'package:cloud/models/department.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    int? id,
    String? name,
    @JsonKey(name: 'job_number') String? jobNumber,
    Department? department,
    List<String>? permissions,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
