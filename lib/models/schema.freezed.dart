// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchemaOption _$SchemaOptionFromJson(Map<String, dynamic> json) {
  return _SchemaOption.fromJson(json);
}

/// @nodoc
mixin _$SchemaOption {
  dynamic get id => throw _privateConstructorUsedError;
  dynamic get index => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchemaOptionCopyWith<SchemaOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemaOptionCopyWith<$Res> {
  factory $SchemaOptionCopyWith(
          SchemaOption value, $Res Function(SchemaOption) then) =
      _$SchemaOptionCopyWithImpl<$Res, SchemaOption>;
  @useResult
  $Res call({dynamic id, dynamic index, String value, String label});
}

/// @nodoc
class _$SchemaOptionCopyWithImpl<$Res, $Val extends SchemaOption>
    implements $SchemaOptionCopyWith<$Res> {
  _$SchemaOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? index = freezed,
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      index: freezed == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as dynamic,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchemaOptionImplCopyWith<$Res>
    implements $SchemaOptionCopyWith<$Res> {
  factory _$$SchemaOptionImplCopyWith(
          _$SchemaOptionImpl value, $Res Function(_$SchemaOptionImpl) then) =
      __$$SchemaOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic id, dynamic index, String value, String label});
}

/// @nodoc
class __$$SchemaOptionImplCopyWithImpl<$Res>
    extends _$SchemaOptionCopyWithImpl<$Res, _$SchemaOptionImpl>
    implements _$$SchemaOptionImplCopyWith<$Res> {
  __$$SchemaOptionImplCopyWithImpl(
      _$SchemaOptionImpl _value, $Res Function(_$SchemaOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? index = freezed,
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_$SchemaOptionImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      index: freezed == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as dynamic,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemaOptionImpl implements _SchemaOption {
  const _$SchemaOptionImpl(
      {required this.id, this.index, required this.value, required this.label});

  factory _$SchemaOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemaOptionImplFromJson(json);

  @override
  final dynamic id;
  @override
  final dynamic index;
  @override
  final String value;
  @override
  final String label;

  @override
  String toString() {
    return 'SchemaOption(id: $id, index: $index, value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemaOptionImpl &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.index, index) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(index),
      value,
      label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemaOptionImplCopyWith<_$SchemaOptionImpl> get copyWith =>
      __$$SchemaOptionImplCopyWithImpl<_$SchemaOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemaOptionImplToJson(
      this,
    );
  }
}

abstract class _SchemaOption implements SchemaOption {
  const factory _SchemaOption(
      {required final dynamic id,
      final dynamic index,
      required final String value,
      required final String label}) = _$SchemaOptionImpl;

  factory _SchemaOption.fromJson(Map<String, dynamic> json) =
      _$SchemaOptionImpl.fromJson;

  @override
  dynamic get id;
  @override
  dynamic get index;
  @override
  String get value;
  @override
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$SchemaOptionImplCopyWith<_$SchemaOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SchemaProps _$SchemaPropsFromJson(Map<String, dynamic> json) {
  return _SchemaProps.fromJson(json);
}

/// @nodoc
mixin _$SchemaProps {
  bool get tableSearch => throw _privateConstructorUsedError;
  bool get showSearch => throw _privateConstructorUsedError;
  List<SchemaOption>? get options => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchemaPropsCopyWith<SchemaProps> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemaPropsCopyWith<$Res> {
  factory $SchemaPropsCopyWith(
          SchemaProps value, $Res Function(SchemaProps) then) =
      _$SchemaPropsCopyWithImpl<$Res, SchemaProps>;
  @useResult
  $Res call({bool tableSearch, bool showSearch, List<SchemaOption>? options});
}

/// @nodoc
class _$SchemaPropsCopyWithImpl<$Res, $Val extends SchemaProps>
    implements $SchemaPropsCopyWith<$Res> {
  _$SchemaPropsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableSearch = null,
    Object? showSearch = null,
    Object? options = freezed,
  }) {
    return _then(_value.copyWith(
      tableSearch: null == tableSearch
          ? _value.tableSearch
          : tableSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      showSearch: null == showSearch
          ? _value.showSearch
          : showSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<SchemaOption>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchemaPropsImplCopyWith<$Res>
    implements $SchemaPropsCopyWith<$Res> {
  factory _$$SchemaPropsImplCopyWith(
          _$SchemaPropsImpl value, $Res Function(_$SchemaPropsImpl) then) =
      __$$SchemaPropsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool tableSearch, bool showSearch, List<SchemaOption>? options});
}

/// @nodoc
class __$$SchemaPropsImplCopyWithImpl<$Res>
    extends _$SchemaPropsCopyWithImpl<$Res, _$SchemaPropsImpl>
    implements _$$SchemaPropsImplCopyWith<$Res> {
  __$$SchemaPropsImplCopyWithImpl(
      _$SchemaPropsImpl _value, $Res Function(_$SchemaPropsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableSearch = null,
    Object? showSearch = null,
    Object? options = freezed,
  }) {
    return _then(_$SchemaPropsImpl(
      tableSearch: null == tableSearch
          ? _value.tableSearch
          : tableSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      showSearch: null == showSearch
          ? _value.showSearch
          : showSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<SchemaOption>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemaPropsImpl implements _SchemaProps {
  const _$SchemaPropsImpl(
      {this.tableSearch = false,
      this.showSearch = false,
      final List<SchemaOption>? options})
      : _options = options;

  factory _$SchemaPropsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemaPropsImplFromJson(json);

  @override
  @JsonKey()
  final bool tableSearch;
  @override
  @JsonKey()
  final bool showSearch;
  final List<SchemaOption>? _options;
  @override
  List<SchemaOption>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SchemaProps(tableSearch: $tableSearch, showSearch: $showSearch, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemaPropsImpl &&
            (identical(other.tableSearch, tableSearch) ||
                other.tableSearch == tableSearch) &&
            (identical(other.showSearch, showSearch) ||
                other.showSearch == showSearch) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tableSearch, showSearch,
      const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemaPropsImplCopyWith<_$SchemaPropsImpl> get copyWith =>
      __$$SchemaPropsImplCopyWithImpl<_$SchemaPropsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemaPropsImplToJson(
      this,
    );
  }
}

abstract class _SchemaProps implements SchemaProps {
  const factory _SchemaProps(
      {final bool tableSearch,
      final bool showSearch,
      final List<SchemaOption>? options}) = _$SchemaPropsImpl;

  factory _SchemaProps.fromJson(Map<String, dynamic> json) =
      _$SchemaPropsImpl.fromJson;

  @override
  bool get tableSearch;
  @override
  bool get showSearch;
  @override
  List<SchemaOption>? get options;
  @override
  @JsonKey(ignore: true)
  _$$SchemaPropsImplCopyWith<_$SchemaPropsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Schema _$SchemaFromJson(Map<String, dynamic> json) {
  return _Schema.fromJson(json);
}

/// @nodoc
mixin _$Schema {
  int get id => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  String get table => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get widget => throw _privateConstructorUsedError;
  @JsonKey(name: 'required', defaultValue: false)
  bool get isRequired => throw _privateConstructorUsedError;
  SchemaProps? get props => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'new', defaultValue: false)
  bool get isNew => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;
  String? get extra => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get tooltip => throw _privateConstructorUsedError;
  @JsonKey(name: 'hidden_in_table', defaultValue: false)
  bool get hiddenInTable => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_external', defaultValue: false)
  bool get isExternal => throw _privateConstructorUsedError;
  int? get cellSpan => throw _privateConstructorUsedError;
  bool? get readOnly => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchemaCopyWith<Schema> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemaCopyWith<$Res> {
  factory $SchemaCopyWith(Schema value, $Res Function(Schema) then) =
      _$SchemaCopyWithImpl<$Res, Schema>;
  @useResult
  $Res call(
      {int id,
      int order,
      String table,
      String name,
      String title,
      String type,
      String widget,
      @JsonKey(name: 'required', defaultValue: false) bool isRequired,
      SchemaProps? props,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'new', defaultValue: false) bool isNew,
      bool hidden,
      String? extra,
      String? description,
      String? tooltip,
      @JsonKey(name: 'hidden_in_table', defaultValue: false) bool hiddenInTable,
      @JsonKey(name: 'is_external', defaultValue: false) bool isExternal,
      int? cellSpan,
      bool? readOnly});

  $SchemaPropsCopyWith<$Res>? get props;
}

/// @nodoc
class _$SchemaCopyWithImpl<$Res, $Val extends Schema>
    implements $SchemaCopyWith<$Res> {
  _$SchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? table = null,
    Object? name = null,
    Object? title = null,
    Object? type = null,
    Object? widget = null,
    Object? isRequired = null,
    Object? props = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isNew = null,
    Object? hidden = null,
    Object? extra = freezed,
    Object? description = freezed,
    Object? tooltip = freezed,
    Object? hiddenInTable = null,
    Object? isExternal = null,
    Object? cellSpan = freezed,
    Object? readOnly = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      table: null == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      widget: null == widget
          ? _value.widget
          : widget // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      props: freezed == props
          ? _value.props
          : props // ignore: cast_nullable_to_non_nullable
              as SchemaProps?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tooltip: freezed == tooltip
          ? _value.tooltip
          : tooltip // ignore: cast_nullable_to_non_nullable
              as String?,
      hiddenInTable: null == hiddenInTable
          ? _value.hiddenInTable
          : hiddenInTable // ignore: cast_nullable_to_non_nullable
              as bool,
      isExternal: null == isExternal
          ? _value.isExternal
          : isExternal // ignore: cast_nullable_to_non_nullable
              as bool,
      cellSpan: freezed == cellSpan
          ? _value.cellSpan
          : cellSpan // ignore: cast_nullable_to_non_nullable
              as int?,
      readOnly: freezed == readOnly
          ? _value.readOnly
          : readOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SchemaPropsCopyWith<$Res>? get props {
    if (_value.props == null) {
      return null;
    }

    return $SchemaPropsCopyWith<$Res>(_value.props!, (value) {
      return _then(_value.copyWith(props: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SchemaImplCopyWith<$Res> implements $SchemaCopyWith<$Res> {
  factory _$$SchemaImplCopyWith(
          _$SchemaImpl value, $Res Function(_$SchemaImpl) then) =
      __$$SchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int order,
      String table,
      String name,
      String title,
      String type,
      String widget,
      @JsonKey(name: 'required', defaultValue: false) bool isRequired,
      SchemaProps? props,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt,
      @JsonKey(name: 'new', defaultValue: false) bool isNew,
      bool hidden,
      String? extra,
      String? description,
      String? tooltip,
      @JsonKey(name: 'hidden_in_table', defaultValue: false) bool hiddenInTable,
      @JsonKey(name: 'is_external', defaultValue: false) bool isExternal,
      int? cellSpan,
      bool? readOnly});

  @override
  $SchemaPropsCopyWith<$Res>? get props;
}

/// @nodoc
class __$$SchemaImplCopyWithImpl<$Res>
    extends _$SchemaCopyWithImpl<$Res, _$SchemaImpl>
    implements _$$SchemaImplCopyWith<$Res> {
  __$$SchemaImplCopyWithImpl(
      _$SchemaImpl _value, $Res Function(_$SchemaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? table = null,
    Object? name = null,
    Object? title = null,
    Object? type = null,
    Object? widget = null,
    Object? isRequired = null,
    Object? props = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isNew = null,
    Object? hidden = null,
    Object? extra = freezed,
    Object? description = freezed,
    Object? tooltip = freezed,
    Object? hiddenInTable = null,
    Object? isExternal = null,
    Object? cellSpan = freezed,
    Object? readOnly = freezed,
  }) {
    return _then(_$SchemaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      table: null == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      widget: null == widget
          ? _value.widget
          : widget // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      props: freezed == props
          ? _value.props
          : props // ignore: cast_nullable_to_non_nullable
              as SchemaProps?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
      extra: freezed == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tooltip: freezed == tooltip
          ? _value.tooltip
          : tooltip // ignore: cast_nullable_to_non_nullable
              as String?,
      hiddenInTable: null == hiddenInTable
          ? _value.hiddenInTable
          : hiddenInTable // ignore: cast_nullable_to_non_nullable
              as bool,
      isExternal: null == isExternal
          ? _value.isExternal
          : isExternal // ignore: cast_nullable_to_non_nullable
              as bool,
      cellSpan: freezed == cellSpan
          ? _value.cellSpan
          : cellSpan // ignore: cast_nullable_to_non_nullable
              as int?,
      readOnly: freezed == readOnly
          ? _value.readOnly
          : readOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemaImpl implements _Schema {
  const _$SchemaImpl(
      {required this.id,
      required this.order,
      required this.table,
      required this.name,
      required this.title,
      required this.type,
      required this.widget,
      @JsonKey(name: 'required', defaultValue: false) required this.isRequired,
      this.props,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'new', defaultValue: false) required this.isNew,
      this.hidden = false,
      this.extra,
      this.description,
      this.tooltip,
      @JsonKey(name: 'hidden_in_table', defaultValue: false)
      required this.hiddenInTable,
      @JsonKey(name: 'is_external', defaultValue: false)
      required this.isExternal,
      this.cellSpan,
      this.readOnly});

  factory _$SchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemaImplFromJson(json);

  @override
  final int id;
  @override
  final int order;
  @override
  final String table;
  @override
  final String name;
  @override
  final String title;
  @override
  final String type;
  @override
  final String widget;
  @override
  @JsonKey(name: 'required', defaultValue: false)
  final bool isRequired;
  @override
  final SchemaProps? props;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'new', defaultValue: false)
  final bool isNew;
  @override
  @JsonKey()
  final bool hidden;
  @override
  final String? extra;
  @override
  final String? description;
  @override
  final String? tooltip;
  @override
  @JsonKey(name: 'hidden_in_table', defaultValue: false)
  final bool hiddenInTable;
  @override
  @JsonKey(name: 'is_external', defaultValue: false)
  final bool isExternal;
  @override
  final int? cellSpan;
  @override
  final bool? readOnly;

  @override
  String toString() {
    return 'Schema(id: $id, order: $order, table: $table, name: $name, title: $title, type: $type, widget: $widget, isRequired: $isRequired, props: $props, createdAt: $createdAt, updatedAt: $updatedAt, isNew: $isNew, hidden: $hidden, extra: $extra, description: $description, tooltip: $tooltip, hiddenInTable: $hiddenInTable, isExternal: $isExternal, cellSpan: $cellSpan, readOnly: $readOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.table, table) || other.table == table) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.widget, widget) || other.widget == widget) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.props, props) || other.props == props) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isNew, isNew) || other.isNew == isNew) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.extra, extra) || other.extra == extra) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.tooltip, tooltip) || other.tooltip == tooltip) &&
            (identical(other.hiddenInTable, hiddenInTable) ||
                other.hiddenInTable == hiddenInTable) &&
            (identical(other.isExternal, isExternal) ||
                other.isExternal == isExternal) &&
            (identical(other.cellSpan, cellSpan) ||
                other.cellSpan == cellSpan) &&
            (identical(other.readOnly, readOnly) ||
                other.readOnly == readOnly));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        order,
        table,
        name,
        title,
        type,
        widget,
        isRequired,
        props,
        createdAt,
        updatedAt,
        isNew,
        hidden,
        extra,
        description,
        tooltip,
        hiddenInTable,
        isExternal,
        cellSpan,
        readOnly
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemaImplCopyWith<_$SchemaImpl> get copyWith =>
      __$$SchemaImplCopyWithImpl<_$SchemaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemaImplToJson(
      this,
    );
  }
}

abstract class _Schema implements Schema {
  const factory _Schema(
      {required final int id,
      required final int order,
      required final String table,
      required final String name,
      required final String title,
      required final String type,
      required final String widget,
      @JsonKey(name: 'required', defaultValue: false)
      required final bool isRequired,
      final SchemaProps? props,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'updated_at') required final String updatedAt,
      @JsonKey(name: 'new', defaultValue: false) required final bool isNew,
      final bool hidden,
      final String? extra,
      final String? description,
      final String? tooltip,
      @JsonKey(name: 'hidden_in_table', defaultValue: false)
      required final bool hiddenInTable,
      @JsonKey(name: 'is_external', defaultValue: false)
      required final bool isExternal,
      final int? cellSpan,
      final bool? readOnly}) = _$SchemaImpl;

  factory _Schema.fromJson(Map<String, dynamic> json) = _$SchemaImpl.fromJson;

  @override
  int get id;
  @override
  int get order;
  @override
  String get table;
  @override
  String get name;
  @override
  String get title;
  @override
  String get type;
  @override
  String get widget;
  @override
  @JsonKey(name: 'required', defaultValue: false)
  bool get isRequired;
  @override
  SchemaProps? get props;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'new', defaultValue: false)
  bool get isNew;
  @override
  bool get hidden;
  @override
  String? get extra;
  @override
  String? get description;
  @override
  String? get tooltip;
  @override
  @JsonKey(name: 'hidden_in_table', defaultValue: false)
  bool get hiddenInTable;
  @override
  @JsonKey(name: 'is_external', defaultValue: false)
  bool get isExternal;
  @override
  int? get cellSpan;
  @override
  bool? get readOnly;
  @override
  @JsonKey(ignore: true)
  _$$SchemaImplCopyWith<_$SchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
