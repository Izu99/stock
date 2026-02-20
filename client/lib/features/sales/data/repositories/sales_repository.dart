import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/sale.dart';

part 'sales_repository.g.dart';

abstract class SalesRepository {
  Future<List<Sale>> getSales();
  Future<Sale> createSale(String itemId, double quantity);
}

class SalesRepositoryImpl implements SalesRepository {
  final ApiClient _apiClient;

  SalesRepositoryImpl(this._apiClient);

  @override
  Future<List<Sale>> getSales() async {
    final response = await _apiClient.dio.get('/sales');
    return (response.data as List).map((e) => Sale.fromJson(e)).toList();
  }

  @override
  Future<Sale> createSale(String itemId, double quantity) async {
    final response = await _apiClient.dio.post('/sales', data: {
      'itemId': itemId,
      'quantity': quantity,
    });
    return Sale.fromJson(response.data);
  }
}

@riverpod
SalesRepository salesRepository(Ref ref) {
  return SalesRepositoryImpl(ref.watch(apiClientProvider));
}
