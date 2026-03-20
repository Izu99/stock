import 'package:freezed_annotation/freezed_annotation.dart';
import 'sale_item.dart';

part 'sale.freezed.dart';
part 'sale.g.dart';

@freezed
abstract class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: '_id') required String id,
    String? companyId,
    required List<SaleItem> items,
    required double totalAmount,
    required double totalProfit,
    required String billId,
    required DateTime date,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}
