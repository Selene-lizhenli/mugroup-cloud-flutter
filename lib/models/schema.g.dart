// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchemaOptionImpl _$$SchemaOptionImplFromJson(Map<String, dynamic> json) =>
    _$SchemaOptionImpl(
      id: json['id'],
      index: json['index'],
      value: json['value'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$$SchemaOptionImplToJson(_$SchemaOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'value': instance.value,
      'label': instance.label,
    };

_$SchemaPropsImpl _$$SchemaPropsImplFromJson(Map<String, dynamic> json) =>
    _$SchemaPropsImpl(
      tableSearch: json['tableSearch'] as bool? ?? false,
      showSearch: json['showSearch'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => SchemaOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SchemaPropsImplToJson(_$SchemaPropsImpl instance) =>
    <String, dynamic>{
      'tableSearch': instance.tableSearch,
      'showSearch': instance.showSearch,
      'options': instance.options,
    };

_$SchemaImpl _$$SchemaImplFromJson(Map<String, dynamic> json) => _$SchemaImpl(
      id: (json['id'] as num).toInt(),
      order: (json['order'] as num).toInt(),
      table: json['table'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      widget: json['widget'] as String,
      isRequired: json['required'] as bool? ?? false,
      props: json['props'] == null
          ? null
          : SchemaProps.fromJson(json['props'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isNew: json['new'] as bool? ?? false,
      hidden: json['hidden'] as bool? ?? false,
      extra: json['extra'] as String?,
      description: json['description'] as String?,
      tooltip: json['tooltip'] as String?,
      hiddenInTable: json['hidden_in_table'] as bool? ?? false,
      isExternal: json['is_external'] as bool? ?? false,
      cellSpan: (json['cellSpan'] as num?)?.toInt(),
      readOnly: json['readOnly'] as bool?,
    );

Map<String, dynamic> _$$SchemaImplToJson(_$SchemaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'table': instance.table,
      'name': instance.name,
      'title': instance.title,
      'type': instance.type,
      'widget': instance.widget,
      'required': instance.isRequired,
      'props': instance.props,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'new': instance.isNew,
      'hidden': instance.hidden,
      'extra': instance.extra,
      'description': instance.description,
      'tooltip': instance.tooltip,
      'hidden_in_table': instance.hiddenInTable,
      'is_external': instance.isExternal,
      'cellSpan': instance.cellSpan,
      'readOnly': instance.readOnly,
    };
