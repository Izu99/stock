import 'dart:developer' as dev;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/sale.dart';

part 'sales_repository.g.dart';

abstract class SalesRepository {
  Future<List<Sale>> getSales();
  Future<Sale> createSale(String itemId, double quantity, {double? sellPrice});
}

class SalesRepositoryImpl implements SalesRepository {
  final ApiClient _apiClient;

  SalesRepositoryImpl(this._apiClient);

  @override
  Future<List<Sale>> getSales() async {
    dev.log('📊 [SalesRepo] Fetching sales...');
    final response = await _apiClient.dio.get('sales');
    final sales = (response.data as List).map((e) => Sale.fromJson(e)).toList();
    dev.log('✅ [SalesRepo] Fetched ${sales.length} sales');
    return sales;
  }

  @override
  Future<Sale> createSale(
    String itemId,
    double quantity, {
    double? sellPrice,
  }) async {
    dev.log(
      '🛒 [SalesRepo] Creating sale - itemId: $itemId, qty: $quantity, customPrice: $sellPrice',
    );
    try {
      final data = <String, dynamic>{'itemId': itemId, 'quantity': quantity};
      if (sellPrice != null) {
        data['sellPrice'] = sellPrice;
      }

      final response = await _apiClient.dio.post('sales', data: data);
      final sale = Sale.fromJson(response.data);
      dev.log(
        '✅ [SalesRepo] Sale created - id: ${sale.id}, item: ${sale.itemName}, subtotal: ${sale.subtotal}',
      );
      return sale;
    } catch (e) {
      dev.log('❌ [SalesRepo] Error creating sale: $e');
      rethrow;
    }
  }
}

@riverpod
SalesRepository salesRepository(Ref ref) {
  return SalesRepositoryImpl(ref.watch(apiClientProvider));
}
