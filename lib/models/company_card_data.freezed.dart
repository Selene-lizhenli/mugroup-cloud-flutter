// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_card_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompanyCardData _$CompanyCardDataFromJson(Map<String, dynamic> json) {
  return _CompanyCardData.fromJson(json);
}

/// @nodoc
mixin _$CompanyCardData {
  String? get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get industry => throw _privateConstructorUsedError;
  List<String>? get domain => throw _privateConstructorUsedError;
  List<String>? get email => throw _privateConstructorUsedError;
  List<String>? get linkedin => throw _privateConstructorUsedError;
  List<String>? get whatsapp => throw _privateConstructorUsedError;
  List<String>? get facebook => throw _privateConstructorUsedError;
  @JsonKey(
      toJson: _companyCardDataContactToJson,
      fromJson: _companyCardDataContactFromJson)
  Contact? get contact => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanyCardDataCopyWith<CompanyCardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyCardDataCopyWith<$Res> {
  factory $CompanyCardDataCopyWith(
          CompanyCardData value, $Res Function(CompanyCardData) then) =
      _$CompanyCardDataCopyWithImpl<$Res, CompanyCardData>;
  @useResult
  $Res call(
      {String? name,
      String? address,
      String? location,
      String? industry,
      List<String>? domain,
      List<String>? email,
      List<String>? linkedin,
      List<String>? whatsapp,
      List<String>? facebook,
      @JsonKey(
          toJson: _companyCardDataContactToJson,
          fromJson: _companyCardDataContactFromJson)
      Contact? contact});

  $ContactCopyWith<$Res>? get contact;
}

/// @nodoc
class _$CompanyCardDataCopyWithImpl<$Res, $Val extends CompanyCardData>
    implements $CompanyCardDataCopyWith<$Res> {
  _$CompanyCardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? industry = freezed,
    Object? domain = freezed,
    Object? email = freezed,
    Object? linkedin = freezed,
    Object? whatsapp = freezed,
    Object? facebook = freezed,
    Object? contact = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      domain: freezed == domain
          ? _value.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      linkedin: freezed == linkedin
          ? _value.linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContactCopyWith<$Res>? get contact {
    if (_value.contact == null) {
      return null;
    }

    return $ContactCopyWith<$Res>(_value.contact!, (value) {
      return _then(_value.copyWith(contact: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompanyCardDataImplCopyWith<$Res>
    implements $CompanyCardDataCopyWith<$Res> {
  factory _$$CompanyCardDataImplCopyWith(_$CompanyCardDataImpl value,
          $Res Function(_$CompanyCardDataImpl) then) =
      __$$CompanyCardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? address,
      String? location,
      String? industry,
      List<String>? domain,
      List<String>? email,
      List<String>? linkedin,
      List<String>? whatsapp,
      List<String>? facebook,
      @JsonKey(
          toJson: _companyCardDataContactToJson,
          fromJson: _companyCardDataContactFromJson)
      Contact? contact});

  @override
  $ContactCopyWith<$Res>? get contact;
}

/// @nodoc
class __$$CompanyCardDataImplCopyWithImpl<$Res>
    extends _$CompanyCardDataCopyWithImpl<$Res, _$CompanyCardDataImpl>
    implements _$$CompanyCardDataImplCopyWith<$Res> {
  __$$CompanyCardDataImplCopyWithImpl(
      _$CompanyCardDataImpl _value, $Res Function(_$CompanyCardDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? address = freezed,
    Object? location = freezed,
    Object? industry = freezed,
    Object? domain = freezed,
    Object? email = freezed,
    Object? linkedin = freezed,
    Object? whatsapp = freezed,
    Object? facebook = freezed,
    Object? contact = freezed,
  }) {
    return _then(_$CompanyCardDataImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      domain: freezed == domain
          ? _value._domain
          : domain // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      email: freezed == email
          ? _value._email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      linkedin: freezed == linkedin
          ? _value._linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      whatsapp: freezed == whatsapp
          ? _value._whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      facebook: freezed == facebook
          ? _value._facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contact: freezed == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as Contact?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyCardDataImpl implements _CompanyCardData {
  const _$CompanyCardDataImpl(
      {this.name,
      this.address,
      this.location,
      this.industry,
      final List<String>? domain = const [],
      final List<String>? email = const [],
      final List<String>? linkedin = const [],
      final List<String>? whatsapp = const [],
      final List<String>? facebook = const [],
      @JsonKey(
          toJson: _companyCardDataContactToJson,
          fromJson: _companyCardDataContactFromJson)
      this.contact})
      : _domain = domain,
        _email = email,
        _linkedin = linkedin,
        _whatsapp = whatsapp,
        _facebook = facebook;

  factory _$CompanyCardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyCardDataImplFromJson(json);

  @override
  final String? name;
  @override
  final String? address;
  @override
  final String? location;
  @override
  final String? industry;
  final List<String>? _domain;
  @override
  @JsonKey()
  List<String>? get domain {
    final value = _domain;
    if (value == null) return null;
    if (_domain is EqualUnmodifiableListView) return _domain;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _email;
  @override
  @JsonKey()
  List<String>? get email {
    final value = _email;
    if (value == null) return null;
    if (_email is EqualUnmodifiableListView) return _email;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _linkedin;
  @override
  @JsonKey()
  List<String>? get linkedin {
    final value = _linkedin;
    if (value == null) return null;
    if (_linkedin is EqualUnmodifiableListView) return _linkedin;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _whatsapp;
  @override
  @JsonKey()
  List<String>? get whatsapp {
    final value = _whatsapp;
    if (value == null) return null;
    if (_whatsapp is EqualUnmodifiableListView) return _whatsapp;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _facebook;
  @override
  @JsonKey()
  List<String>? get facebook {
    final value = _facebook;
    if (value == null) return null;
    if (_facebook is EqualUnmodifiableListView) return _facebook;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(
      toJson: _companyCardDataContactToJson,
      fromJson: _companyCardDataContactFromJson)
  final Contact? contact;

  @override
  String toString() {
    return 'CompanyCardData(name: $name, address: $address, location: $location, industry: $industry, domain: $domain, email: $email, linkedin: $linkedin, whatsapp: $whatsapp, facebook: $facebook, contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyCardDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            const DeepCollectionEquality().equals(other._domain, _domain) &&
            const DeepCollectionEquality().equals(other._email, _email) &&
            const DeepCollectionEquality().equals(other._linkedin, _linkedin) &&
            const DeepCollectionEquality().equals(other._whatsapp, _whatsapp) &&
            const DeepCollectionEquality().equals(other._facebook, _facebook) &&
            (identical(other.contact, contact) || other.contact == contact));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      address,
      location,
      industry,
      const DeepCollectionEquality().hash(_domain),
      const DeepCollectionEquality().hash(_email),
      const DeepCollectionEquality().hash(_linkedin),
      const DeepCollectionEquality().hash(_whatsapp),
      const DeepCollectionEquality().hash(_facebook),
      contact);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyCardDataImplCopyWith<_$CompanyCardDataImpl> get copyWith =>
      __$$CompanyCardDataImplCopyWithImpl<_$CompanyCardDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyCardDataImplToJson(
      this,
    );
  }
}

abstract class _CompanyCardData implements CompanyCardData {
  const factory _CompanyCardData(
      {final String? name,
      final String? address,
      final String? location,
      final String? industry,
      final List<String>? domain,
      final List<String>? email,
      final List<String>? linkedin,
      final List<String>? whatsapp,
      final List<String>? facebook,
      @JsonKey(
          toJson: _companyCardDataContactToJson,
          fromJson: _companyCardDataContactFromJson)
      final Contact? contact}) = _$CompanyCardDataImpl;

  factory _CompanyCardData.fromJson(Map<String, dynamic> json) =
      _$CompanyCardDataImpl.fromJson;

  @override
  String? get name;
  @override
  String? get address;
  @override
  String? get location;
  @override
  String? get industry;
  @override
  List<String>? get domain;
  @override
  List<String>? get email;
  @override
  List<String>? get linkedin;
  @override
  List<String>? get whatsapp;
  @override
  List<String>? get facebook;
  @override
  @JsonKey(
      toJson: _companyCardDataContactToJson,
      fromJson: _companyCardDataContactFromJson)
  Contact? get contact;
  @override
  @JsonKey(ignore: true)
  _$$CompanyCardDataImplCopyWith<_$CompanyCardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return _Contact.fromJson(json);
}

/// @nodoc
mixin _$Contact {
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get mobile => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call({String? name, String? phone, String? mobile, String? position});
}

/// @nodoc
class _$ContactCopyWithImpl<$Res, $Val extends Contact>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? phone = freezed,
    Object? mobile = freezed,
    Object? position = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _value.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? phone, String? mobile, String? position});
}

/// @nodoc
class __$$ContactImplCopyWithImpl<$Res>
    extends _$ContactCopyWithImpl<$Res, _$ContactImpl>
    implements _$$ContactImplCopyWith<$Res> {
  __$$ContactImplCopyWithImpl(
      _$ContactImpl _value, $Res Function(_$ContactImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? phone = freezed,
    Object? mobile = freezed,
    Object? position = freezed,
  }) {
    return _then(_$ContactImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _value.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactImpl implements _Contact {
  const _$ContactImpl({this.name, this.phone, this.mobile, this.position});

  factory _$ContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactImplFromJson(json);

  @override
  final String? name;
  @override
  final String? phone;
  @override
  final String? mobile;
  @override
  final String? position;

  @override
  String toString() {
    return 'Contact(name: $name, phone: $phone, mobile: $mobile, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, phone, mobile, position);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      __$$ContactImplCopyWithImpl<_$ContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactImplToJson(
      this,
    );
  }
}

abstract class _Contact implements Contact {
  const factory _Contact(
      {final String? name,
      final String? phone,
      final String? mobile,
      final String? position}) = _$ContactImpl;

  factory _Contact.fromJson(Map<String, dynamic> json) = _$ContactImpl.fromJson;

  @override
  String? get name;
  @override
  String? get phone;
  @override
  String? get mobile;
  @override
  String? get position;
  @override
  @JsonKey(ignore: true)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
