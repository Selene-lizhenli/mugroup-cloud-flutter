import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    String? name,
    @JsonKey(name: 'name_en') String? nameEn,
    List<Category>? children,
    List<Category>? ancestors, 
    @JsonKey(name: 'parent_id') int? parentId,
    @JsonKey(name: 'products_count') int? productsCount, 
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) =>
      _$CategoryFromJson(json);
}
