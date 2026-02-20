import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/stock_item.dart';
import '../../data/repositories/stock_repository.dart';

part 'stock_provider.g.dart';

@riverpod
class Stock extends _$Stock {
  @override
  FutureOr<List<StockItem>> build() async {
    return ref.read(stockRepositoryProvider).getStockItems();
  }

  Future<void> addItem(StockItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(stockRepositoryProvider).addStockItem(item);
      return ref.read(stockRepositoryProvider).getStockItems();
    });
  }

  Future<void> updateItem(StockItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(stockRepositoryProvider).updateStockItem(item);
      return ref.read(stockRepositoryProvider).getStockItems();
    });
  }

  Future<void> deleteItem(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(stockRepositoryProvider).deleteStockItem(id);
      return ref.read(stockRepositoryProvider).getStockItems();
    });
  }
}
