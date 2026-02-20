import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/income.dart';
import '../../data/repositories/income_repository.dart';

part 'income_provider.g.dart';

@riverpod
class Incomes extends _$Incomes {
  @override
  FutureOr<List<Income>> build() async {
    return ref.read(incomeRepositoryProvider).getIncomes();
  }

  Future<void> add(Income income) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(incomeRepositoryProvider).addIncome(income);
      return ref.read(incomeRepositoryProvider).getIncomes();
    });
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(incomeRepositoryProvider).deleteIncome(id);
      return ref.read(incomeRepositoryProvider).getIncomes();
    });
  }
}
