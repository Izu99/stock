// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CompanySummary _$CompanySummaryFromJson(Map<String, dynamic> json) =>
    _CompanySummary(
      totalCompanies: (json['totalCompanies'] as num).toInt(),
      activeCompanies: (json['activeCompanies'] as num).toInt(),
      inactiveCompanies: (json['inactiveCompanies'] as num).toInt(),
    );

Map<String, dynamic> _$CompanySummaryToJson(_CompanySummary instance) =>
    <String, dynamic>{
      'totalCompanies': instance.totalCompanies,
      'activeCompanies': instance.activeCompanies,
      'inactiveCompanies': instance.inactiveCompanies,
    };
