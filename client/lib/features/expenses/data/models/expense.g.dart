// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['_id'] as String,
  companyId: json['companyId'] as String?,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
  date: DateTime.parse(json['date'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  '_id': instance.id,
  'companyId': instance.companyId,
  'title': instance.title,
  'amount': instance.amount,
  'category': _$ExpenseCategoryEnumMap[instance.category]!,
  'date': instance.date.toIso8601String(),
  'note': instance.note,
};

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.hardware: 'hardware',
  ExpenseCategory.other: 'other',
};
