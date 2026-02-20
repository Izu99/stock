import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/sale.dart';
import '../../data/repositories/sales_repository.dart';

part 'sales_provider.g.dart';

@riverpod
class SalesNotifier extends _$SalesNotifier {
  @override
  FutureOr<List<Sale>> build() {
    return ref.watch(salesRepositoryProvider).getSales();
  }

  Future<void> createSale(String itemId, double quantity) async {
    state = const AsyncLoading();
    try {
      await ref.read(salesRepositoryProvider).createSale(itemId, quantity);
      // Check if the provider is still mounted before invalidating
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> processCart(List<({String itemId, double quantity})> items) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(salesRepositoryProvider);
      for (final item in items) {
        await repo.createSale(item.itemId, item.quantity);
      }
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
