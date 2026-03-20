import 'dart:developer' as dev;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/widgets/api_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/sale.dart';

part 'sales_repository.g.dart';

abstract class SalesRepository {
  Future<List<Sale>> getSales();
  Future<Sale> createSaleBill({
    required List<Map<String, dynamic>> items,
    required String billId,
  });
  Future<String> getNextBillId();
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
  Future<Sale> createSaleBill({
    required List<Map<String, dynamic>> items,
    required String billId,
  }) async {
    dev.log(
      '🛒 [SalesRepo] Creating sale bill - billId: $billId, itemCount: ${items.length}',
    );
    try {
      final data = <String, dynamic>{
        'items': items,
        'billId': billId,
      };

      final response = await _apiClient.dio.post('sales', data: data);
      final sale = Sale.fromJson(response.data);
      dev.log(
        '✅ [SalesRepo] Sale created - id: ${sale.id}, billId: ${sale.billId}, total: ${sale.totalAmount}',
      );
      return sale;
    } catch (e) {
      dev.log('❌ [SalesRepo] Error creating sale bill: $e');
      rethrow;
    }
  }

  @override
  Future<String> getNextBillId() async {
    try {
      final response = await _apiClient.dio.get('sales/next-bill-id');
      final data = response.data['data'] as String;
      return data;
    } catch (e) {
      dev.log('❌ [SalesRepo] Error fetching next bill id: $e');
      return '001'; // Default fallback
    }
  }
}


@riverpod
SalesRepository salesRepository(Ref ref) {
  return SalesRepositoryImpl(ref.watch(apiClientProvider));
}
