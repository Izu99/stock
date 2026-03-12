import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/dashboard_summary.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../../../features/stock/presentation/providers/stock_provider.dart';

part 'dashboard_provider.g.dart';

@riverpod
class DashboardSummaryNotifier extends _$DashboardSummaryNotifier {
  @override
  FutureOr<DashboardSummary> build() async {
    final baseSummary = await ref
        .watch(dashboardRepositoryProvider)
        .getSummary();
    final stockItems = await ref.watch(stockProvider.future);

    // Calculate stock statistics
    final totalItems = stockItems.length;
    final lowStockCount = stockItems
        .where((item) => item.quantity <= item.lowStockThreshold)
        .length;

    return baseSummary.copyWith(
      totalItems: totalItems,
      lowStockCount: lowStockCount,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final baseSummary = await ref
          .read(dashboardRepositoryProvider)
          .getSummary();
      final stockItems = await ref.read(stockProvider.future);

      final totalItems = stockItems.length;
      final lowStockCount = stockItems
          .where((item) => item.quantity <= item.lowStockThreshold)
          .length;

      return baseSummary.copyWith(
        totalItems: totalItems,
        lowStockCount: lowStockCount,
      );
    });
  }
}
