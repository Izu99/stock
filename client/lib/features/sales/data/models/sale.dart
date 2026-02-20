import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale.freezed.dart';
part 'sale.g.dart';

@freezed
abstract class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: '_id') required String id,
    String? companyId,
    @JsonKey(name: 'item') required String itemId,
    required String itemName,
    required double quantity,
    required double sellPrice,
    required double subtotal,
    required double profit,
    required DateTime date,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}
