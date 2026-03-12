import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/enums.dart';

part 'stock_item.freezed.dart';
part 'stock_item.g.dart';

@freezed
abstract class StockItem with _$StockItem {
  const factory StockItem({
    @JsonKey(name: '_id') required String id,
    String? companyId,
    required String name,
    required double buyPrice,
    required double sellPrice,
    required double quantity,
    @Default(5.0) double lowStockThreshold,
    String? barcode,
    required ItemUnit unit,
    required String category,
    String? subcategory,
    required DateTime date,
    String? note,
  }) = _StockItem;

  factory StockItem.fromJson(Map<String, dynamic> json) =>
      _$StockItemFromJson(json);
}
