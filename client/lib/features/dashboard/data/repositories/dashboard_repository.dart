import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/dashboard_summary.dart';

part 'dashboard_repository.g.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> getSummary({DateTime? startDate, DateTime? endDate});
}

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepositoryImpl(this._apiClient);

  @override
  Future<DashboardSummary> getSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Map<String, dynamic> queryParameters = {};
    if (startDate != null) {
      queryParameters['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParameters['endDate'] = endDate.toIso8601String();
    }

    final response = await _apiClient.dio.get(
      'dashboard/summary',
      queryParameters: queryParameters,
    );
    return DashboardSummary.fromJson(response.data);
  }
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(ref.watch(apiClientProvider));
}
