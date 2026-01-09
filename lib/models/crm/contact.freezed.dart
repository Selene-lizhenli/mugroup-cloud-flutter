// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return _Contact.fromJson(json);
}

/// @nodoc
mixin _$Contact {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;
  String? get birthday => throw _privateConstructorUsedError;
  @JsonKey(name: 'tel_number')
  String? get telNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int? get companyId => throw _privateConstructorUsedError;
  Company? get company => throw _privateConstructorUsedError;
  List<String>? get whatsapp => throw _privateConstructorUsedError;
  List<String>? get email => throw _privateConstructorUsedError;
  List<String>? get linkedin => throw _privateConstructorUsedError;
  List<String>? get facebook => throw _privateConstructorUsedError;
  User? get head => throw _privateConstructorUsedError;
  List<Log>? get logs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactCopyWith<Contact> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactCopyWith<$Res> {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) then) =
      _$ContactCopyWithImpl<$Res, Contact>;
  @useResult
  $Res call(
      {int? id,
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
      List<Log>? logs});

  $CompanyCopyWith<$Res>? get company;
  $UserCopyWith<$Res>? get head;
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
    Object? id = freezed,
    Object? name = freezed,
    Object? location = freezed,
    Object? position = freezed,
    Object? birthday = freezed,
    Object? telNumber = freezed,
    Object? companyId = freezed,
    Object? company = freezed,
    Object? whatsapp = freezed,
    Object? email = freezed,
    Object? linkedin = freezed,
    Object? facebook = freezed,
    Object? head = freezed,
    Object? logs = freezed,
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
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String?,
      telNumber: freezed == telNumber
          ? _value.telNumber
          : telNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Company?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      linkedin: freezed == linkedin
          ? _value.linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      head: freezed == head
          ? _value.head
          : head // ignore: cast_nullable_to_non_nullable
              as User?,
      logs: freezed == logs
          ? _value.logs
          : logs // ignore: cast_nullable_to_non_nullable
              as List<Log>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CompanyCopyWith<$Res>? get company {
    if (_value.company == null) {
      return null;
    }

    return $CompanyCopyWith<$Res>(_value.company!, (value) {
      return _then(_value.copyWith(company: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get head {
    if (_value.head == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.head!, (value) {
      return _then(_value.copyWith(head: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContactImplCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$$ContactImplCopyWith(
          _$ContactImpl value, $Res Function(_$ContactImpl) then) =
      __$$ContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
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
      List<Log>? logs});

  @override
  $CompanyCopyWith<$Res>? get company;
  @override
  $UserCopyWith<$Res>? get head;
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
    Object? id = freezed,
    Object? name = freezed,
    Object? location = freezed,
    Object? position = freezed,
    Object? birthday = freezed,
    Object? telNumber = freezed,
    Object? companyId = freezed,
    Object? company = freezed,
    Object? whatsapp = freezed,
    Object? email = freezed,
    Object? linkedin = freezed,
    Object? facebook = freezed,
    Object? head = freezed,
    Object? logs = freezed,
  }) {
    return _then(_$ContactImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == telNumber
          ? _value.telNumber
          : telNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Company?,
      freezed == whatsapp
          ? _value._whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == email
          ? _value._email
          : email // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == linkedin
          ? _value._linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == facebook
          ? _value._facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      freezed == head
          ? _value.head
          : head // ignore: cast_nullable_to_non_nullable
              as User?,
      freezed == logs
          ? _value._logs
          : logs // ignore: cast_nullable_to_non_nullable
              as List<Log>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactImpl implements _Contact {
  _$ContactImpl(
      this.id,
      this.name,
      this.location,
      this.position,
      this.birthday,
      @JsonKey(name: 'tel_number') this.telNumber,
      @JsonKey(name: 'company_id') this.companyId,
      this.company,
      final List<String>? whatsapp,
      final List<String>? email,
      final List<String>? linkedin,
      final List<String>? facebook,
      this.head,
      final List<Log>? logs)
      : _whatsapp = whatsapp,
        _email = email,
        _linkedin = linkedin,
        _facebook = facebook,
        _logs = logs;

  factory _$ContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? location;
  @override
  final String? position;
  @override
  final String? birthday;
  @override
  @JsonKey(name: 'tel_number')
  final String? telNumber;
  @override
  @JsonKey(name: 'company_id')
  final int? companyId;
  @override
  final Company? company;
  final List<String>? _whatsapp;
  @override
  List<String>? get whatsapp {
    final value = _whatsapp;
    if (value == null) return null;
    if (_whatsapp is EqualUnmodifiableListView) return _whatsapp;
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

  final List<String>? _linkedin;
  @override
  List<String>? get linkedin {
    final value = _linkedin;
    if (value == null) return null;
    if (_linkedin is EqualUnmodifiableListView) return _linkedin;
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

  @override
  final User? head;
  final List<Log>? _logs;
  @override
  List<Log>? get logs {
    final value = _logs;
    if (value == null) return null;
    if (_logs is EqualUnmodifiableListView) return _logs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, location: $location, position: $position, birthday: $birthday, telNumber: $telNumber, companyId: $companyId, company: $company, whatsapp: $whatsapp, email: $email, linkedin: $linkedin, facebook: $facebook, head: $head, logs: $logs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.telNumber, telNumber) ||
                other.telNumber == telNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.company, company) || other.company == company) &&
            const DeepCollectionEquality().equals(other._whatsapp, _whatsapp) &&
            const DeepCollectionEquality().equals(other._email, _email) &&
            const DeepCollectionEquality().equals(other._linkedin, _linkedin) &&
            const DeepCollectionEquality().equals(other._facebook, _facebook) &&
            (identical(other.head, head) || other.head == head) &&
            const DeepCollectionEquality().equals(other._logs, _logs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      location,
      position,
      birthday,
      telNumber,
      companyId,
      company,
      const DeepCollectionEquality().hash(_whatsapp),
      const DeepCollectionEquality().hash(_email),
      const DeepCollectionEquality().hash(_linkedin),
      const DeepCollectionEquality().hash(_facebook),
      head,
      const DeepCollectionEquality().hash(_logs));

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
  factory _Contact(
      final int? id,
      final String? name,
      final String? location,
      final String? position,
      final String? birthday,
      @JsonKey(name: 'tel_number') final String? telNumber,
      @JsonKey(name: 'company_id') final int? companyId,
      final Company? company,
      final List<String>? whatsapp,
      final List<String>? email,
      final List<String>? linkedin,
      final List<String>? facebook,
      final User? head,
      final List<Log>? logs) = _$ContactImpl;

  factory _Contact.fromJson(Map<String, dynamic> json) = _$ContactImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  String? get location;
  @override
  String? get position;
  @override
  String? get birthday;
  @override
  @JsonKey(name: 'tel_number')
  String? get telNumber;
  @override
  @JsonKey(name: 'company_id')
  int? get companyId;
  @override
  Company? get company;
  @override
  List<String>? get whatsapp;
  @override
  List<String>? get email;
  @override
  List<String>? get linkedin;
  @override
  List<String>? get facebook;
  @override
  User? get head;
  @override
  List<Log>? get logs;
  @override
  @JsonKey(ignore: true)
  _$$ContactImplCopyWith<_$ContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
