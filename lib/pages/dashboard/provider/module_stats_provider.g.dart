// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$moduleStatsHash() => r'beedceb1141d0bf7e620c4f7bff721aae631f388';

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

abstract class _$ModuleStats
    extends BuildlessAutoDisposeNotifier<ModuleStatsState> {
  late final String moduleId;

  ModuleStatsState build(
    String moduleId,
  );
}

/// 模块统计数据 Provider（按模块ID区分）
///
/// Copied from [ModuleStats].
@ProviderFor(ModuleStats)
const moduleStatsProvider = ModuleStatsFamily();

/// 模块统计数据 Provider（按模块ID区分）
///
/// Copied from [ModuleStats].
class ModuleStatsFamily extends Family<ModuleStatsState> {
  /// 模块统计数据 Provider（按模块ID区分）
  ///
  /// Copied from [ModuleStats].
  const ModuleStatsFamily();

  /// 模块统计数据 Provider（按模块ID区分）
  ///
  /// Copied from [ModuleStats].
  ModuleStatsProvider call(
    String moduleId,
  ) {
    return ModuleStatsProvider(
      moduleId,
    );
  }

  @override
  ModuleStatsProvider getProviderOverride(
    covariant ModuleStatsProvider provider,
  ) {
    return call(
      provider.moduleId,
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
  String? get name => r'moduleStatsProvider';
}

/// 模块统计数据 Provider（按模块ID区分）
///
/// Copied from [ModuleStats].
class ModuleStatsProvider
    extends AutoDisposeNotifierProviderImpl<ModuleStats, ModuleStatsState> {
  /// 模块统计数据 Provider（按模块ID区分）
  ///
  /// Copied from [ModuleStats].
  ModuleStatsProvider(
    String moduleId,
  ) : this._internal(
          () => ModuleStats()..moduleId = moduleId,
          from: moduleStatsProvider,
          name: r'moduleStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$moduleStatsHash,
          dependencies: ModuleStatsFamily._dependencies,
          allTransitiveDependencies:
              ModuleStatsFamily._allTransitiveDependencies,
          moduleId: moduleId,
        );

  ModuleStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.moduleId,
  }) : super.internal();

  final String moduleId;

  @override
  ModuleStatsState runNotifierBuild(
    covariant ModuleStats notifier,
  ) {
    return notifier.build(
      moduleId,
    );
  }

  @override
  Override overrideWith(ModuleStats Function() create) {
    return ProviderOverride(
      origin: this,
      override: ModuleStatsProvider._internal(
        () => create()..moduleId = moduleId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        moduleId: moduleId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ModuleStats, ModuleStatsState>
      createElement() {
    return _ModuleStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ModuleStatsProvider && other.moduleId == moduleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, moduleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ModuleStatsRef on AutoDisposeNotifierProviderRef<ModuleStatsState> {
  /// The parameter `moduleId` of this provider.
  String get moduleId;
}

class _ModuleStatsProviderElement
    extends AutoDisposeNotifierProviderElement<ModuleStats, ModuleStatsState>
    with ModuleStatsRef {
  _ModuleStatsProviderElement(super.provider);

  @override
  String get moduleId => (origin as ModuleStatsProvider).moduleId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
