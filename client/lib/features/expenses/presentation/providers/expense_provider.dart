import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/expense.dart';
import '../../data/repositories/expense_repository.dart';

part 'expense_provider.g.dart';

@riverpod
class Expenses extends _$Expenses {
  @override
  FutureOr<List<Expense>> build() async {
    return ref.read(expenseRepositoryProvider).getExpenses();
  }

  Future<void> add(Expense expense) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(expenseRepositoryProvider).addExpense(expense);
      return ref.read(expenseRepositoryProvider).getExpenses();
    });
  }

  Future<void> updateExpense(Expense expense) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(expenseRepositoryProvider).updateExpense(expense);
      return ref.read(expenseRepositoryProvider).getExpenses();
    });
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(expenseRepositoryProvider).deleteExpense(id);
      return ref.read(expenseRepositoryProvider).getExpenses();
    });
  }
}
