// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(companySummary)
final companySummaryProvider = CompanySummaryProvider._();

final class CompanySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<CompanySummary>,
          CompanySummary,
          FutureOr<CompanySummary>
        >
    with $FutureModifier<CompanySummary>, $FutureProvider<CompanySummary> {
  CompanySummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companySummaryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companySummaryHash();

  @$internal
  @override
  $FutureProviderElement<CompanySummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CompanySummary> create(Ref ref) {
    return companySummary(ref);
  }
}

String _$companySummaryHash() => r'dcbfb157cb628e1a81086e379ce2ea7731f01397';

@ProviderFor(Companies)
final companiesProvider = CompaniesProvider._();

final class CompaniesProvider
    extends $AsyncNotifierProvider<Companies, List<Company>> {
  CompaniesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companiesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companiesHash();

  @$internal
  @override
  Companies create() => Companies();
}

String _$companiesHash() => r'187aea52d932153620c05c13f494ee6ab6a0b98f';

abstract class _$Companies extends $AsyncNotifier<List<Company>> {
  FutureOr<List<Company>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Company>>, List<Company>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Company>>, List<Company>>,
              AsyncValue<List<Company>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
