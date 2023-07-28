// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observar_parle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totalBrutoHash() => r'1ceebcf22d96aac1bfc2863ddcdbcf733ad11ad8';

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

typedef TotalBrutoRef = AutoDisposeProviderRef<int>;

/// See also [totalBruto].
@ProviderFor(totalBruto)
const totalBrutoProvider = TotalBrutoFamily();

/// See also [totalBruto].
class TotalBrutoFamily extends Family<int> {
  /// See also [totalBruto].
  const TotalBrutoFamily();

  /// See also [totalBruto].
  ParleTotalBrutoProvider call(
    String jornal,
    String date,
  ) {
    return ParleTotalBrutoProvider(
      jornal,
      date,
    );
  }

  @override
  ParleTotalBrutoProvider getProviderOverride(
    covariant ParleTotalBrutoProvider provider,
  ) {
    return call(
      provider.jornal,
      provider.date,
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
  String? get name => r'totalBrutoProvider';
}

/// See also [totalBruto].
class ParleTotalBrutoProvider extends AutoDisposeProvider<int> {
  /// See also [totalBruto].
  ParleTotalBrutoProvider(
    this.jornal,
    this.date,
  ) : super.internal(
          (ref) => totalBruto(
            ref,
            jornal,
            date,
          ),
          from: totalBrutoProvider,
          name: r'totalBrutoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$totalBrutoHash,
          dependencies: TotalBrutoFamily._dependencies,
          allTransitiveDependencies:
              TotalBrutoFamily._allTransitiveDependencies,
        );

  final String jornal;
  final String date;

  @override
  bool operator ==(Object other) {
    return other is ParleTotalBrutoProvider &&
        other.jornal == jornal &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, jornal.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
