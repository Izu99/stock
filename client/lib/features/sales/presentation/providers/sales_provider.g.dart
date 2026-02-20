// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SalesNotifier)
final salesProvider = SalesNotifierProvider._();

final class SalesNotifierProvider
    extends $AsyncNotifierProvider<SalesNotifier, List<Sale>> {
  SalesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesNotifierHash();

  @$internal
  @override
  SalesNotifier create() => SalesNotifier();
}

String _$salesNotifierHash() => r'1685fbdacc765bc18bcb1bd9d6194292e9b27940';

abstract class _$SalesNotifier extends $AsyncNotifier<List<Sale>> {
  FutureOr<List<Sale>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Sale>>, List<Sale>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Sale>>, List<Sale>>,
              AsyncValue<List<Sale>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
