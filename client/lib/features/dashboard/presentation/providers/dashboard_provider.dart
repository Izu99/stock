import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/dashboard_summary.dart';
import '../../data/repositories/dashboard_repository.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardSummaryNotifier extends _$DashboardSummaryNotifier {
  @override
  FutureOr<DashboardSummary> build() {
    return ref.watch(dashboardRepositoryProvider).getSummary();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(dashboardRepositoryProvider).getSummary());
  }
}
