import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../models/company.dart';
import '../models/company_summary.dart';

part 'company_repository.g.dart';

abstract class CompanyRepository {
  Future<List<Company>> getCompanies();
  Future<CompanySummary> getCompanySummary();
  Future<bool> checkAvailability(String type, String value);
  Future<Company> registerCompany(Map<String, dynamic> companyData);
  Future<Company> updateCompany(String id, Map<String, dynamic> companyData);
  Future<Company> updateCompanyStatus(String id, bool isActive);
  Future<void> deleteCompany(String id);
}

class CompanyRepositoryImpl implements CompanyRepository {
  final ApiClient _apiClient;

  CompanyRepositoryImpl(this._apiClient);

  @override
  Future<List<Company>> getCompanies() async {
    final response = await _apiClient.dio.get(
      'companies',
      queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
    );
    return (response.data as List).map((e) => Company.fromJson(e)).toList();
  }

  @override
  Future<CompanySummary> getCompanySummary() async {
    final response = await _apiClient.dio.get(
      'companies/summary',
      queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
    );
    return CompanySummary.fromJson(response.data);
  }

  @override
  Future<bool> checkAvailability(String type, String value) async {
    final response = await _apiClient.dio.get(
      'companies/check-availability',
      queryParameters: {'type': type, 'value': value},
    );
    return response.data['available'] ?? false;
  }

  @override
  Future<Company> registerCompany(Map<String, dynamic> companyData) async {
    final response = await _apiClient.dio.post('companies', data: companyData);
    return Company.fromJson(response.data);
  }

  @override
  Future<Company> updateCompany(
    String id,
    Map<String, dynamic> companyData,
  ) async {
    final response = await _apiClient.dio.put(
      'companies/$id',
      data: companyData,
    );
    return Company.fromJson(response.data);
  }

  @override
  Future<Company> updateCompanyStatus(String id, bool isActive) async {
    final response = await _apiClient.dio.patch(
      'companies/$id/status',
      data: {'isActive': isActive},
    );
    return Company.fromJson(response.data);
  }

  @override
  Future<void> deleteCompany(String id) async {
    await _apiClient.dio.delete('companies/$id');
  }
}

@riverpod
CompanyRepository companyRepository(Ref ref) {
  return CompanyRepositoryImpl(ref.watch(apiClientProvider));
}
