import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/expense.dart';

part 'expense_repository.g.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<Expense> addExpense(Expense expense);
  Future<Expense> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ApiClient _apiClient;

  ExpenseRepositoryImpl(this._apiClient);

  @override
  Future<List<Expense>> getExpenses() async {
    final response = await _apiClient.dio.get('/expenses');
    return (response.data as List).map((e) => Expense.fromJson(e)).toList();
  }

  @override
  Future<Expense> addExpense(Expense expense) async {
    final response = await _apiClient.dio.post('/expenses', data: expense.toJson());
    return Expense.fromJson(response.data);
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    final response = await _apiClient.dio.put('/expenses/${expense.id}', data: expense.toJson());
    return Expense.fromJson(response.data);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _apiClient.dio.delete('/expenses/$id');
  }
}

@riverpod
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepositoryImpl(ref.watch(apiClientProvider));
}
