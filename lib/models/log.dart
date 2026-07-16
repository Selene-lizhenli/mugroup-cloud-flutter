import 'package:cloud/models/media.dart';
import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log.freezed.dart';
part 'log.g.dart';

@freezed
abstract class Log with _$Log {
  const factory Log({
    int? id,
    String? description,
    Map<String, dynamic>? properties,
    User? causer,
    String? event,
    List<Media>? attachments,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _Log;

  factory Log.fromJson(Map<String, Object?> json) => _$LogFromJson(json);
}
