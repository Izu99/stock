import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stock/features/admin/data/models/company.dart';
import 'package:stock/features/admin/data/models/company_summary.dart';
import 'package:stock/features/admin/data/repositories/company_repository.dart';

part 'admin_provider.g.dart';

@Riverpod(keepAlive: true)
Future<CompanySummary> companySummary(Ref ref) {
  return ref.watch(companyRepositoryProvider).getCompanySummary();
}

@Riverpod(keepAlive: true)
class Companies extends _$Companies {
  Timer? _pollingTimer;

  @override
  FutureOr<List<Company>> build() {
    // Start polling when the provider is first built
    _startPolling();

    // Clean up timer when provider is disposed
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });

    return ref.watch(companyRepositoryProvider).getCompanies();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      // Background refresh without showing loading state
      if (state.isLoading)
        return; // Don't poll if we are already explicitly loading

      try {
        final companies = await ref
            .read(companyRepositoryProvider)
            .getCompanies();
        state = AsyncData(companies);
        // Also refresh summary in background
        ref.invalidate(companySummaryProvider);
      } catch (e) {
        // Silently fail on polling errors to not disturb the UI
      }
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final companies = await ref
          .read(companyRepositoryProvider)
          .getCompanies();
      ref.invalidate(companySummaryProvider);
      return companies;
    });
    state = result;
    if (result.hasError) throw result.error!;
  }

  Future<void> add(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await ref.read(companyRepositoryProvider).registerCompany(data);
      final companies = await ref
          .read(companyRepositoryProvider)
          .getCompanies();
      // Ensure summary is updated immediately
      ref.invalidate(companySummaryProvider);
      return companies;
    });
    state = result;
    if (result.hasError) throw result.error!;
  }

  Future<void> updateCompany(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await ref.read(companyRepositoryProvider).updateCompany(id, data);
      final companies = await ref
          .read(companyRepositoryProvider)
          .getCompanies();
      ref.invalidate(companySummaryProvider);
      return companies;
    });
    state = result;
    if (result.hasError) throw result.error!;
  }

  Future<void> toggleStatus(String id, bool isActive) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await ref
          .read(companyRepositoryProvider)
          .updateCompanyStatus(id, isActive);
      final companies = await ref
          .read(companyRepositoryProvider)
          .getCompanies();
      ref.invalidate(companySummaryProvider);
      return companies;
    });
    state = result;
    if (result.hasError) throw result.error!;
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await ref.read(companyRepositoryProvider).deleteCompany(id);
      final companies = await ref
          .read(companyRepositoryProvider)
          .getCompanies();
      ref.invalidate(companySummaryProvider);
      return companies;
    });
    state = result;
    if (result.hasError) throw result.error!;
  }
}
