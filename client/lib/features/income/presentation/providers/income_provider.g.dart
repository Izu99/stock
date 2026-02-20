// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Incomes)
final incomesProvider = IncomesProvider._();

final class IncomesProvider
    extends $AsyncNotifierProvider<Incomes, List<Income>> {
  IncomesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomesHash();

  @$internal
  @override
  Incomes create() => Incomes();
}

String _$incomesHash() => r'67c74f2bcec5c21f5cd3e2e8dd9a0abf76239212';

abstract class _$Incomes extends $AsyncNotifier<List<Income>> {
  FutureOr<List<Income>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Income>>, List<Income>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Income>>, List<Income>>,
              AsyncValue<List<Income>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
