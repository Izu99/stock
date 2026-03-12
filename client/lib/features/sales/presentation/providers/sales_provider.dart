import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/sale.dart';
import '../../data/repositories/sales_repository.dart';

part 'sales_provider.g.dart';

@Riverpod(keepAlive: true)
class SalesNotifier extends _$SalesNotifier {
  @override
  FutureOr<List<Sale>> build() {
    return ref.watch(salesRepositoryProvider).getSales();
  }

  Future<void> createSale(String itemId, double quantity) async {
    state = const AsyncLoading();
    try {
      await ref.read(salesRepositoryProvider).createSale(itemId, quantity);
      ref.invalidateSelf();
    } catch (e, st) {
      if (ref.exists(salesProvider)) {
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> processCart(
    List<({String itemId, double quantity})> items,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(salesRepositoryProvider);
      for (final item in items) {
        await repo.createSale(item.itemId, item.quantity);
      }
      return ref.read(salesRepositoryProvider).getSales();
    });
  }
}
