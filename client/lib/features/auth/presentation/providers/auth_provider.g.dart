// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Auth)
final authProvider = AuthProvider._();

final class AuthProvider extends $AsyncNotifierProvider<Auth, User?> {
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();
}

String _$authHash() => r'1dc8bcac2c862230763b3af0a0edcc27a0871ec5';

abstract class _$Auth extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(companyDetails)
final companyDetailsProvider = CompanyDetailsProvider._();

final class CompanyDetailsProvider
    extends
        $FunctionalProvider<AsyncValue<Company?>, Company?, FutureOr<Company?>>
    with $FutureModifier<Company?>, $FutureProvider<Company?> {
  CompanyDetailsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyDetailsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyDetailsHash();

  @$internal
  @override
  $FutureProviderElement<Company?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Company?> create(Ref ref) {
    return companyDetails(ref);
  }
}

String _$companyDetailsHash() => r'500e47f53eee77594cbdc80a343cab250e583a22';
