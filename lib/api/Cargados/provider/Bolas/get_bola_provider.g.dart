// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bola_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getBolasCargadasHash() => r'ce2651af0282debd21c22f11142eef1dc17a224a';

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

typedef GetBolasCargadasRef = AutoDisposeFutureProviderRef<List<BolaCargadaModel>>;

/// See also [getBolasCargadas].
@ProviderFor(getBolasCargadas)
const getBolasCargadasProvider = GetBolasCargadasFamily();

/// See also [getBolasCargadas].
class GetBolasCargadasFamily extends Family<AsyncValue<List<BolaCargadaModel>>> {
  /// See also [getBolasCargadas].
  const GetBolasCargadasFamily();

  /// See also [getBolasCargadas].
  GetBolasCargadasProvider call(
    String jornal,
    String date,
  ) {
    return GetBolasCargadasProvider(
      jornal,
      date,
    );
  }

  @override
  GetBolasCargadasProvider getProviderOverride(
    covariant GetBolasCargadasProvider provider,
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
  String? get name => r'getBolasCargadasProvider';
}

/// See also [getBolasCargadas].
class GetBolasCargadasProvider
    extends AutoDisposeFutureProvider<List<BolaCargadaModel>> {
  /// See also [getBolasCargadas].
  GetBolasCargadasProvider(
    this.jornal,
    this.date,
  ) : super.internal(
          (ref) => getBolasCargadasref(
            ref,
            jornal,
            date,
          ),
          from: getBolasCargadasProvider,
          name: r'getBolasCargadasProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBolasCargadasHash,
          dependencies: GetBolasCargadasFamily._dependencies,
          allTransitiveDependencies:
              GetBolasCargadasFamily._allTransitiveDependencies,
        );

  final String jornal;
  final String date;

  @override
  bool operator ==(Object other) {
    return other is GetBolasCargadasProvider &&
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
