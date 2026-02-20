import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../models/company.dart';
import '../models/company_summary.dart';

part 'company_repository.g.dart';

abstract class CompanyRepository {
  Future<List<Company>> getCompanies();
  Future<CompanySummary> getCompanySummary();
  Future<Company> registerCompany(Map<String, dynamic> companyData);
  Future<Company> updateCompanyStatus(String id, bool isActive);
  Future<void> deleteCompany(String id);
}

class CompanyRepositoryImpl implements CompanyRepository {
  final ApiClient _apiClient;

  CompanyRepositoryImpl(this._apiClient);

  @override
  Future<List<Company>> getCompanies() async {
    final response = await _apiClient.dio.get('/companies');
    return (response.data as List).map((e) => Company.fromJson(e)).toList();
  }

  @override
  Future<CompanySummary> getCompanySummary() async {
    final response = await _apiClient.dio.get('/companies/summary');
    return CompanySummary.fromJson(response.data);
  }

  @override
  Future<Company> registerCompany(Map<String, dynamic> companyData) async {
    final response = await _apiClient.dio.post('/companies', data: companyData);
    return Company.fromJson(response.data);
  }

  @override
  Future<Company> updateCompanyStatus(String id, bool isActive) async {
    final response = await _apiClient.dio.patch('/companies/$id/status', data: {'isActive': isActive});
    return Company.fromJson(response.data);
  }

  @override
  Future<void> deleteCompany(String id) async {
    await _apiClient.dio.delete('/companies/$id');
  }
}

@riverpod
CompanyRepository companyRepository(Ref ref) {
  return CompanyRepositoryImpl(ref.watch(apiClientProvider));
}
