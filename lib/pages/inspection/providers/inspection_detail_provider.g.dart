// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inspectionDetailHash() => r'50349822090e644c84396b6af10fc4d65dc6d28f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$InspectionDetail
    extends BuildlessAutoDisposeAsyncNotifier<Inspection> {
  late final int inspectionId;

  FutureOr<Inspection> build(
    int inspectionId,
  );
}

/// See also [InspectionDetail].
@ProviderFor(InspectionDetail)
const inspectionDetailProvider = InspectionDetailFamily();

/// See also [InspectionDetail].
class InspectionDetailFamily extends Family<AsyncValue<Inspection>> {
  /// See also [InspectionDetail].
  const InspectionDetailFamily();

  /// See also [InspectionDetail].
  InspectionDetailProvider call(
    int inspectionId,
  ) {
    return InspectionDetailProvider(
      inspectionId,
    );
  }

  @override
  InspectionDetailProvider getProviderOverride(
    covariant InspectionDetailProvider provider,
  ) {
    return call(
      provider.inspectionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'inspectionDetailProvider';
}

/// See also [InspectionDetail].
class InspectionDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<InspectionDetail, Inspection> {
  /// See also [InspectionDetail].
  InspectionDetailProvider(
    int inspectionId,
  ) : this._internal(
          () => InspectionDetail()..inspectionId = inspectionId,
          from: inspectionDetailProvider,
          name: r'inspectionDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inspectionDetailHash,
          dependencies: InspectionDetailFamily._dependencies,
          allTransitiveDependencies:
              InspectionDetailFamily._allTransitiveDependencies,
          inspectionId: inspectionId,
        );

  InspectionDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.inspectionId,
  }) : super.internal();

  final int inspectionId;

  @override
  FutureOr<Inspection> runNotifierBuild(
    covariant InspectionDetail notifier,
  ) {
    return notifier.build(
      inspectionId,
    );
  }

  @override
  Override overrideWith(InspectionDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: InspectionDetailProvider._internal(
        () => create()..inspectionId = inspectionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        inspectionId: inspectionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<InspectionDetail, Inspection>
      createElement() {
    return _InspectionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InspectionDetailProvider &&
        other.inspectionId == inspectionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, inspectionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InspectionDetailRef on AutoDisposeAsyncNotifierProviderRef<Inspection> {
  /// The parameter `inspectionId` of this provider.
  int get inspectionId;
}

class _InspectionDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<InspectionDetail,
        Inspection> with InspectionDetailRef {
  _InspectionDetailProviderElement(super.provider);

  @override
  int get inspectionId => (origin as InspectionDetailProvider).inspectionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
