// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return _Company.fromJson(json);
}

/// @nodoc
mixin _$Company {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "user_id")
  int? get userId => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get industry => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  List<String>? get domain => throw _privateConstructorUsedError;
  List<String>? get email => throw _privateConstructorUsedError;
  List<String>? get facebook => throw _privateConstructorUsedError;
  List<String>? get linkedin => throw _privateConstructorUsedError;
  List<String>? get whatsapp => throw _privateConstructorUsedError;
  List<Contact>? get contacts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanyCopyWith<Company> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyCopyWith<$Res> {
  factory $CompanyCopyWith(Company value, $Res Function(Company) then) =
      _$CompanyCopyWithImpl<$Res, Company>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      @JsonKey(name: "user_id") int? userId,
      String? address,
      String? industry,
      String? location,
      String? source,
      List<String>? domain,
      List<String>? email,
      List<String>? facebook,
      List<String>? linkedin,
      List<String>? whatsapp,
      List<Contact>? contacts});
}

/// @nodoc
class _$CompanyCopyWithImpl<$Res, $Val extends Company>
    implements $CompanyCopyWith<$Res> {
  _$CompanyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? userId = freezed,
    Object? address = freezed,
    Object? industry = freezed,
    Object? location = freezed,
    Object? source = freezed,
    Object? domain = freezed,
    Object? email = freezed,
    Object? facebook = freezed,
    Object? linkedin = freezed,
    Object? whatsapp = freezed,
    Object? contacts = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      linkedin: freezed == linkedin
          ? _value.linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contacts: freezed == contacts
          ? _value.contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyImplCopyWith<$Res> implements $CompanyCopyWith<$Res> {
  factory _$$CompanyImplCopyWith(
          _$CompanyImpl value, $Res Function(_$CompanyImpl) then) =
      __$$CompanyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      @JsonKey(name: "user_id") int? userId,
      String? address,
      String? industry,
      String? location,
      String? source,
      List<String>? domain,
      List<String>? email,
      List<String>? facebook,
      List<String>? linkedin,
      List<String>? whatsapp,
      List<Contact>? contacts});
}

/// @nodoc
class __$$CompanyImplCopyWithImpl<$Res>
    extends _$CompanyCopyWithImpl<$Res, _$CompanyImpl>
    implements _$$CompanyImplCopyWith<$Res> {
  __$$CompanyImplCopyWithImpl(
      _$CompanyImpl _value, $Res Function(_$CompanyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? userId = freezed,
    Object? address = freezed,
    Object? industry = freezed,
    Object? location = freezed,
    Object? source = freezed,
    Object? domain = freezed,
    Object? email = freezed,
    Object? facebook = freezed,
    Object? linkedin = freezed,
    Object? whatsapp = freezed,
    Object? contacts = freezed,
  }) {
    return _then(_$CompanyImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == domain
          ? _value._domain
          : domain // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == email
          ? _value._email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == facebook
          ? _value._facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == linkedin
          ? _value._linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == whatsapp
          ? _value._whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == contacts
          ? _value._contacts
          : contacts // ignore: cast_nullable_to_non_nullable
              as List<Contact>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyImpl implements _Company {
  _$CompanyImpl(
      this.id,
      this.name,
      @JsonKey(name: "user_id") this.userId,
      this.address,
      this.industry,
      this.location,
      this.source,
      final List<String>? domain,
      final List<String>? email,
      final List<String>? facebook,
      final List<String>? linkedin,
      final List<String>? whatsapp,
      final List<Contact>? contacts)
      : _domain = domain,
        _email = email,
        _facebook = facebook,
        _linkedin = linkedin,
        _whatsapp = whatsapp,
        _contacts = contacts;

  factory _$CompanyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  @JsonKey(name: "user_id")
  final int? userId;
  @override
  final String? address;
  @override
  final String? industry;
  @override
  final String? location;
  @override
  final String? source;
  final List<String>? _domain;
  @override
  List<String>? get domain {
    final value = _domain;
    if (value == null) return null;
    if (_domain is EqualUnmodifiableListView) return _domain;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _email;
  @override
  List<String>? get email {
    final value = _email;
    if (value == null) return null;
    if (_email is EqualUnmodifiableListView) return _email;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _facebook;
  @override
  List<String>? get facebook {
    final value = _facebook;
    if (value == null) return null;
    if (_facebook is EqualUnmodifiableListView) return _facebook;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _linkedin;
  @override
  List<String>? get linkedin {
    final value = _linkedin;
    if (value == null) return null;
    if (_linkedin is EqualUnmodifiableListView) return _linkedin;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _whatsapp;
  @override
  List<String>? get whatsapp {
    final value = _whatsapp;
    if (value == null) return null;
    if (_whatsapp is EqualUnmodifiableListView) return _whatsapp;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Contact>? _contacts;
  @override
  List<Contact>? get contacts {
    final value = _contacts;
    if (value == null) return null;
    if (_contacts is EqualUnmodifiableListView) return _contacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Company(id: $id, name: $name, userId: $userId, address: $address, industry: $industry, location: $location, source: $source, domain: $domain, email: $email, facebook: $facebook, linkedin: $linkedin, whatsapp: $whatsapp, contacts: $contacts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(other._domain, _domain) &&
            const DeepCollectionEquality().equals(other._email, _email) &&
            const DeepCollectionEquality().equals(other._facebook, _facebook) &&
            const DeepCollectionEquality().equals(other._linkedin, _linkedin) &&
            const DeepCollectionEquality().equals(other._whatsapp, _whatsapp) &&
            const DeepCollectionEquality().equals(other._contacts, _contacts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      userId,
      address,
      industry,
      location,
      source,
      const DeepCollectionEquality().hash(_domain),
      const DeepCollectionEquality().hash(_email),
      const DeepCollectionEquality().hash(_facebook),
      const DeepCollectionEquality().hash(_linkedin),
      const DeepCollectionEquality().hash(_whatsapp),
      const DeepCollectionEquality().hash(_contacts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyImplCopyWith<_$CompanyImpl> get copyWith =>
      __$$CompanyImplCopyWithImpl<_$CompanyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyImplToJson(
      this,
    );
  }
}

abstract class _Company implements Company {
  factory _Company(
      final int? id,
      final String? name,
      @JsonKey(name: "user_id") final int? userId,
      final String? address,
      final String? industry,
      final String? location,
      final String? source,
      final List<String>? domain,
      final List<String>? email,
      final List<String>? facebook,
      final List<String>? linkedin,
      final List<String>? whatsapp,
      final List<Contact>? contacts) = _$CompanyImpl;

  factory _Company.fromJson(Map<String, dynamic> json) = _$CompanyImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  @JsonKey(name: "user_id")
  int? get userId;
  @override
  String? get address;
  @override
  String? get industry;
  @override
  String? get location;
  @override
  String? get source;
  @override
  List<String>? get domain;
  @override
  List<String>? get email;
  @override
  List<String>? get facebook;
  @override
  List<String>? get linkedin;
  @override
  List<String>? get whatsapp;
  @override
  List<Contact>? get contacts;
  @override
  @JsonKey(ignore: true)
  _$$CompanyImplCopyWith<_$CompanyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
