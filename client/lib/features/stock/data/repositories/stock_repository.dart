import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/stock_item.dart';

part 'stock_repository.g.dart';

abstract class StockRepository {
  Future<List<StockItem>> getStockItems();
  Future<StockItem> addStockItem(StockItem item);
  Future<StockItem> updateStockItem(StockItem item);
  Future<void> deleteStockItem(String id);
}

class StockRepositoryImpl implements StockRepository {
  final ApiClient _apiClient;

  StockRepositoryImpl(this._apiClient);

  @override
  Future<List<StockItem>> getStockItems() async {
    final response = await _apiClient.dio.get('/stock');
    return (response.data as List).map((e) => StockItem.fromJson(e)).toList();
  }

  @override
  Future<StockItem> addStockItem(StockItem item) async {
    final response = await _apiClient.dio.post('/stock', data: item.toJson());
    return StockItem.fromJson(response.data);
  }

  @override
  Future<StockItem> updateStockItem(StockItem item) async {
    final response = await _apiClient.dio.put('/stock/${item.id}', data: item.toJson());
    return StockItem.fromJson(response.data);
  }

  @override
  Future<void> deleteStockItem(String id) async {
    await _apiClient.dio.delete('/stock/$id');
  }
}

@riverpod
StockRepository stockRepository(Ref ref) {
  return StockRepositoryImpl(ref.watch(apiClientProvider));
}
