// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardSummaryNotifier)
final dashboardSummaryProvider = DashboardSummaryNotifierProvider._();

final class DashboardSummaryNotifierProvider
    extends $AsyncNotifierProvider<DashboardSummaryNotifier, DashboardSummary> {
  DashboardSummaryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSummaryNotifierHash();

  @$internal
  @override
  DashboardSummaryNotifier create() => DashboardSummaryNotifier();
}

String _$dashboardSummaryNotifierHash() =>
    r'92c31a36b7242442e8394ebbffe26974f6e0e7d3';

abstract class _$DashboardSummaryNotifier
    extends $AsyncNotifier<DashboardSummary> {
  FutureOr<DashboardSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DashboardSummary>, DashboardSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardSummary>, DashboardSummary>,
              AsyncValue<DashboardSummary>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
