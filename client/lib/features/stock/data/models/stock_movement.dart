import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/enums.dart';

part 'stock_movement.freezed.dart';
part 'stock_movement.g.dart';

@freezed
abstract class StockMovement with _$StockMovement {
  const factory StockMovement({
    @JsonKey(name: '_id') required String id,
    required String itemId,
    required String itemName,
    required double quantity,
    required StockMovementType type,
    required DateTime date,
    String? note,
  }) = _StockMovement;

  factory StockMovement.fromJson(Map<String, dynamic> json) =>
      _$StockMovementFromJson(json);
}
