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
      final repo = ref.read(salesRepositoryProvider);
      final billId = await repo.getNextBillId();
      await repo.createSaleBill(
        items: [{'itemId': itemId, 'quantity': quantity}],
        billId: billId,
      );
      ref.invalidateSelf();
    } catch (e, st) {
      if (ref.exists(salesProvider)) {
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> processCart(
    List<({String itemId, double quantity})> items,
    String billId,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(salesRepositoryProvider);
      final checkoutItems = items.map((e) => {
        'itemId': e.itemId,
        'quantity': e.quantity,
      }).toList();
      
      await repo.createSaleBill(
        items: checkoutItems,
        billId: billId,
      );
      return repo.getSales();
    });
  }

}
