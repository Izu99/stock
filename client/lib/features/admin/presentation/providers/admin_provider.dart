import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Stock/features/admin/data/models/company.dart';
import 'package:Stock/features/admin/data/models/company_summary.dart';
import 'package:Stock/features/admin/data/repositories/company_repository.dart';

part 'admin_provider.g.dart';

@riverpod
Future<CompanySummary> companySummary(Ref ref) {
  return ref.watch(companyRepositoryProvider).getCompanySummary();
}

@Riverpod(keepAlive: true)
class Companies extends _$Companies {
  @override
  FutureOr<List<Company>> build() {
    return ref.watch(companyRepositoryProvider).getCompanies();
  }

  Future<void> add(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(companyRepositoryProvider).registerCompany(data);
      return ref.read(companyRepositoryProvider).getCompanies();
    });
    ref.invalidate(companySummaryProvider);
  }

  Future<void> toggleStatus(String id, bool isActive) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(companyRepositoryProvider).updateCompanyStatus(id, isActive);
      return ref.read(companyRepositoryProvider).getCompanies();
    });
    ref.invalidate(companySummaryProvider);
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(companyRepositoryProvider).deleteCompany(id);
      return ref.read(companyRepositoryProvider).getCompanies();
    });
    ref.invalidate(companySummaryProvider);
  }
}
