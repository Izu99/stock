import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_summary.freezed.dart';
part 'company_summary.g.dart';

@freezed
abstract class CompanySummary with _$CompanySummary {
  const factory CompanySummary({
    required int totalCompanies,
    required int activeCompanies,
    required int inactiveCompanies,
  }) = _CompanySummary;

  factory CompanySummary.fromJson(Map<String, dynamic> json) => _$CompanySummaryFromJson(json);
}
