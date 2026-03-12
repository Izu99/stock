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
    r'94830075dc082f67091273e359fad305ac0ff09c';

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
