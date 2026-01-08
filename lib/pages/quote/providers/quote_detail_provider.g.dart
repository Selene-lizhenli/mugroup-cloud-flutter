// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quoteDetailHash() => r'bd43de5d1fdbbe87b43ba35331717f8136269c0b';

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

abstract class _$QuoteDetail
    extends BuildlessAutoDisposeAsyncNotifier<QuotationList> {
  late final int quoteId;

  FutureOr<QuotationList> build(
    int quoteId,
  );
}

/// See also [QuoteDetail].
@ProviderFor(QuoteDetail)
const quoteDetailProvider = QuoteDetailFamily();

/// See also [QuoteDetail].
class QuoteDetailFamily extends Family<AsyncValue<QuotationList>> {
  /// See also [QuoteDetail].
  const QuoteDetailFamily();

  /// See also [QuoteDetail].
  QuoteDetailProvider call(
    int quoteId,
  ) {
    return QuoteDetailProvider(
      quoteId,
    );
  }

  @override
  QuoteDetailProvider getProviderOverride(
    covariant QuoteDetailProvider provider,
  ) {
    return call(
      provider.quoteId,
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
  String? get name => r'quoteDetailProvider';
}

/// See also [QuoteDetail].
class QuoteDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<QuoteDetail, QuotationList> {
  /// See also [QuoteDetail].
  QuoteDetailProvider(
    int quoteId,
  ) : this._internal(
          () => QuoteDetail()..quoteId = quoteId,
          from: quoteDetailProvider,
          name: r'quoteDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quoteDetailHash,
          dependencies: QuoteDetailFamily._dependencies,
          allTransitiveDependencies:
              QuoteDetailFamily._allTransitiveDependencies,
          quoteId: quoteId,
        );

  QuoteDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quoteId,
  }) : super.internal();

  final int quoteId;

  @override
  FutureOr<QuotationList> runNotifierBuild(
    covariant QuoteDetail notifier,
  ) {
    return notifier.build(
      quoteId,
    );
  }

  @override
  Override overrideWith(QuoteDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuoteDetailProvider._internal(
        () => create()..quoteId = quoteId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quoteId: quoteId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<QuoteDetail, QuotationList>
      createElement() {
    return _QuoteDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteDetailProvider && other.quoteId == quoteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quoteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuoteDetailRef on AutoDisposeAsyncNotifierProviderRef<QuotationList> {
  /// The parameter `quoteId` of this provider.
  int get quoteId;
}

class _QuoteDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<QuoteDetail, QuotationList>
    with QuoteDetailRef {
  _QuoteDetailProviderElement(super.provider);

  @override
  int get quoteId => (origin as QuoteDetailProvider).quoteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
