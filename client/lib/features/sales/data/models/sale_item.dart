import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_item.freezed.dart';
part 'sale_item.g.dart';

@freezed
abstract class SaleItem with _$SaleItem {
  const factory SaleItem({
    @JsonKey(name: 'item') required String itemId,
    required String itemName,
    required double quantity,
    required double sellPrice,
    required double subtotal,
    required double profit,
  }) = _SaleItem;

  factory SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);
}
