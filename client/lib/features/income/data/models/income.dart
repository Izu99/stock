import 'package:freezed_annotation/freezed_annotation.dart';

part 'income.freezed.dart';
part 'income.g.dart';

@freezed
abstract class Income with _$Income {
  const factory Income({
    @JsonKey(name: '_id') required String id,
    String? companyId,
    required String title,
    required double amount,
    required DateTime date,
    String? note,
  }) = _Income;

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);
}
