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
        isAutoDispose: true,
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

String _$companySummaryHash() => r'6f03dc4d202a11dcd8a413711d9b235d4301a2eb';

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

String _$companiesHash() => r'efed8e23dc0bba36455dd500f8a8a4f49287689b';

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
