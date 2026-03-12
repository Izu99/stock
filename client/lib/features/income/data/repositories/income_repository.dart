import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/income.dart';

part 'income_repository.g.dart';

abstract class IncomeRepository {
  Future<List<Income>> getIncomes();
  Future<Income> addIncome(Income income);
  Future<void> deleteIncome(String id);
}

class IncomeRepositoryImpl implements IncomeRepository {
  final ApiClient _apiClient;

  IncomeRepositoryImpl(this._apiClient);

  @override
  Future<List<Income>> getIncomes() async {
    final response = await _apiClient.dio.get('income');
    return (response.data as List).map((e) => Income.fromJson(e)).toList();
  }

  @override
  Future<Income> addIncome(Income income) async {
    final response = await _apiClient.dio.post('income', data: income.toJson());
    return Income.fromJson(response.data);
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _apiClient.dio.delete('income/$id');
  }
}

@riverpod
IncomeRepository incomeRepository(Ref ref) {
  return IncomeRepositoryImpl(ref.watch(apiClientProvider));
}
