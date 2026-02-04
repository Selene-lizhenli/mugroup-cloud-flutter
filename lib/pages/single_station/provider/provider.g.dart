// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleStationHash() => r'fa0b23730799512cff76bd127be72ada94d82d63';

/// 独立站列表 Provider：页面加载后调用 [load] 拉取列表，通过 [singleStationProvider] 读取状态
///
/// Copied from [SingleStation].
@ProviderFor(SingleStation)
final singleStationProvider =
    AutoDisposeNotifierProvider<SingleStation, SingleStationState>.internal(
  SingleStation.new,
  name: r'singleStationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$singleStationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SingleStation = AutoDisposeNotifier<SingleStationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
