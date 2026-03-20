// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardSummaryNotifier)
final dashboardSummaryProvider = DashboardSummaryNotifierFamily._();

final class DashboardSummaryNotifierProvider
    extends $AsyncNotifierProvider<DashboardSummaryNotifier, DashboardSummary> {
  DashboardSummaryNotifierProvider._({
    required DashboardSummaryNotifierFamily super.from,
    required ({DateTime? startDate, DateTime? endDate}) super.argument,
  }) : super(
         retry: null,
         name: r'dashboardSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dashboardSummaryNotifierHash();

  @override
  String toString() {
    return r'dashboardSummaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DashboardSummaryNotifier create() => DashboardSummaryNotifier();

  @override
  bool operator ==(Object other) {
    return other is DashboardSummaryNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dashboardSummaryNotifierHash() =>
    r'a3fd59be623b1b284933b98ccd78ec361c5146c1';

final class DashboardSummaryNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DashboardSummaryNotifier,
          AsyncValue<DashboardSummary>,
          DashboardSummary,
          FutureOr<DashboardSummary>,
          ({DateTime? startDate, DateTime? endDate})
        > {
  DashboardSummaryNotifierFamily._()
    : super(
        retry: null,
        name: r'dashboardSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DashboardSummaryNotifierProvider call({
    DateTime? startDate,
    DateTime? endDate,
  }) => DashboardSummaryNotifierProvider._(
    argument: (startDate: startDate, endDate: endDate),
    from: this,
  );

  @override
  String toString() => r'dashboardSummaryProvider';
}

abstract class _$DashboardSummaryNotifier
    extends $AsyncNotifier<DashboardSummary> {
  late final _$args = ref.$arg as ({DateTime? startDate, DateTime? endDate});
  DateTime? get startDate => _$args.startDate;
  DateTime? get endDate => _$args.endDate;

  FutureOr<DashboardSummary> build({DateTime? startDate, DateTime? endDate});
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
    element.handleCreate(
      ref,
      () => build(startDate: _$args.startDate, endDate: _$args.endDate),
    );
  }
}
