// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stock)
final stockProvider = StockProvider._();

final class StockProvider
    extends $AsyncNotifierProvider<Stock, List<StockItem>> {
  StockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockHash();

  @$internal
  @override
  Stock create() => Stock();
}

String _$stockHash() => r'7a7ebb3a58faf60191f17447c6610a14416f57cc';

abstract class _$Stock extends $AsyncNotifier<List<StockItem>> {
  FutureOr<List<StockItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<StockItem>>, List<StockItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StockItem>>, List<StockItem>>,
              AsyncValue<List<StockItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
