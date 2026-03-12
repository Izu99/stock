// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardTransaction {

 String get id; String get title; double get amount; DateTime get date; String get type;
/// Create a copy of DashboardTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTransactionCopyWith<DashboardTransaction> get copyWith => _$DashboardTransactionCopyWithImpl<DashboardTransaction>(this as DashboardTransaction, _$identity);

  /// Serializes this DashboardTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,amount,date,type);

@override
String toString() {
  return 'DashboardTransaction(id: $id, title: $title, amount: $amount, date: $date, type: $type)';
}


}

/// @nodoc
abstract mixin class $DashboardTransactionCopyWith<$Res>  {
  factory $DashboardTransactionCopyWith(DashboardTransaction value, $Res Function(DashboardTransaction) _then) = _$DashboardTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String title, double amount, DateTime date, String type
});




}
/// @nodoc
class _$DashboardTransactionCopyWithImpl<$Res>
    implements $DashboardTransactionCopyWith<$Res> {
  _$DashboardTransactionCopyWithImpl(this._self, this._then);

  final DashboardTransaction _self;
  final $Res Function(DashboardTransaction) _then;

/// Create a copy of DashboardTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? date = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardTransaction].
extension DashboardTransactionPatterns on DashboardTransaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTransaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTransaction value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTransaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTransaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  double amount,  DateTime date,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardTransaction() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.date,_that.type);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  double amount,  DateTime date,  String type)  $default,) {final _that = this;
switch (_that) {
case _DashboardTransaction():
return $default(_that.id,_that.title,_that.amount,_that.date,_that.type);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  double amount,  DateTime date,  String type)?  $default,) {final _that = this;
switch (_that) {
case _DashboardTransaction() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.date,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardTransaction implements DashboardTransaction {
  const _DashboardTransaction({required this.id, required this.title, required this.amount, required this.date, required this.type});
  factory _DashboardTransaction.fromJson(Map<String, dynamic> json) => _$DashboardTransactionFromJson(json);

@override final  String id;
@override final  String title;
@override final  double amount;
@override final  DateTime date;
@override final  String type;

/// Create a copy of DashboardTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTransactionCopyWith<_DashboardTransaction> get copyWith => __$DashboardTransactionCopyWithImpl<_DashboardTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,amount,date,type);

@override
String toString() {
  return 'DashboardTransaction(id: $id, title: $title, amount: $amount, date: $date, type: $type)';
}


}

/// @nodoc
abstract mixin class _$DashboardTransactionCopyWith<$Res> implements $DashboardTransactionCopyWith<$Res> {
  factory _$DashboardTransactionCopyWith(_DashboardTransaction value, $Res Function(_DashboardTransaction) _then) = __$DashboardTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, double amount, DateTime date, String type
});




}
/// @nodoc
class __$DashboardTransactionCopyWithImpl<$Res>
    implements _$DashboardTransactionCopyWith<$Res> {
  __$DashboardTransactionCopyWithImpl(this._self, this._then);

  final _DashboardTransaction _self;
  final $Res Function(_DashboardTransaction) _then;

/// Create a copy of DashboardTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? date = null,Object? type = null,}) {
  return _then(_DashboardTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DashboardSummary {

 double get totalStockValue; double get todaySales; double get monthlySales; double get totalExpenses; double get otherIncome; double get profit; int get totalItems; int get lowStockCount; List<DashboardTransaction> get recentTransactions; List<Map<String, dynamic>>? get salesHistory; List<Map<String, dynamic>>? get topItems;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);

  /// Serializes this DashboardSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.totalStockValue, totalStockValue) || other.totalStockValue == totalStockValue)&&(identical(other.todaySales, todaySales) || other.todaySales == todaySales)&&(identical(other.monthlySales, monthlySales) || other.monthlySales == monthlySales)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.otherIncome, otherIncome) || other.otherIncome == otherIncome)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&const DeepCollectionEquality().equals(other.recentTransactions, recentTransactions)&&const DeepCollectionEquality().equals(other.salesHistory, salesHistory)&&const DeepCollectionEquality().equals(other.topItems, topItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalStockValue,todaySales,monthlySales,totalExpenses,otherIncome,profit,totalItems,lowStockCount,const DeepCollectionEquality().hash(recentTransactions),const DeepCollectionEquality().hash(salesHistory),const DeepCollectionEquality().hash(topItems));

@override
String toString() {
  return 'DashboardSummary(totalStockValue: $totalStockValue, todaySales: $todaySales, monthlySales: $monthlySales, totalExpenses: $totalExpenses, otherIncome: $otherIncome, profit: $profit, totalItems: $totalItems, lowStockCount: $lowStockCount, recentTransactions: $recentTransactions, salesHistory: $salesHistory, topItems: $topItems)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 double totalStockValue, double todaySales, double monthlySales, double totalExpenses, double otherIncome, double profit, int totalItems, int lowStockCount, List<DashboardTransaction> recentTransactions, List<Map<String, dynamic>>? salesHistory, List<Map<String, dynamic>>? topItems
});




}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalStockValue = null,Object? todaySales = null,Object? monthlySales = null,Object? totalExpenses = null,Object? otherIncome = null,Object? profit = null,Object? totalItems = null,Object? lowStockCount = null,Object? recentTransactions = null,Object? salesHistory = freezed,Object? topItems = freezed,}) {
  return _then(_self.copyWith(
totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,todaySales: null == todaySales ? _self.todaySales : todaySales // ignore: cast_nullable_to_non_nullable
as double,monthlySales: null == monthlySales ? _self.monthlySales : monthlySales // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,otherIncome: null == otherIncome ? _self.otherIncome : otherIncome // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,recentTransactions: null == recentTransactions ? _self.recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<DashboardTransaction>,salesHistory: freezed == salesHistory ? _self.salesHistory : salesHistory // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,topItems: freezed == topItems ? _self.topItems : topItems // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalStockValue,  double todaySales,  double monthlySales,  double totalExpenses,  double otherIncome,  double profit,  int totalItems,  int lowStockCount,  List<DashboardTransaction> recentTransactions,  List<Map<String, dynamic>>? salesHistory,  List<Map<String, dynamic>>? topItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.totalStockValue,_that.todaySales,_that.monthlySales,_that.totalExpenses,_that.otherIncome,_that.profit,_that.totalItems,_that.lowStockCount,_that.recentTransactions,_that.salesHistory,_that.topItems);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalStockValue,  double todaySales,  double monthlySales,  double totalExpenses,  double otherIncome,  double profit,  int totalItems,  int lowStockCount,  List<DashboardTransaction> recentTransactions,  List<Map<String, dynamic>>? salesHistory,  List<Map<String, dynamic>>? topItems)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.totalStockValue,_that.todaySales,_that.monthlySales,_that.totalExpenses,_that.otherIncome,_that.profit,_that.totalItems,_that.lowStockCount,_that.recentTransactions,_that.salesHistory,_that.topItems);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalStockValue,  double todaySales,  double monthlySales,  double totalExpenses,  double otherIncome,  double profit,  int totalItems,  int lowStockCount,  List<DashboardTransaction> recentTransactions,  List<Map<String, dynamic>>? salesHistory,  List<Map<String, dynamic>>? topItems)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.totalStockValue,_that.todaySales,_that.monthlySales,_that.totalExpenses,_that.otherIncome,_that.profit,_that.totalItems,_that.lowStockCount,_that.recentTransactions,_that.salesHistory,_that.topItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummary implements DashboardSummary {
  const _DashboardSummary({required this.totalStockValue, required this.todaySales, required this.monthlySales, required this.totalExpenses, required this.otherIncome, required this.profit, this.totalItems = 0, this.lowStockCount = 0, final  List<DashboardTransaction> recentTransactions = const [], final  List<Map<String, dynamic>>? salesHistory, final  List<Map<String, dynamic>>? topItems}): _recentTransactions = recentTransactions,_salesHistory = salesHistory,_topItems = topItems;
  factory _DashboardSummary.fromJson(Map<String, dynamic> json) => _$DashboardSummaryFromJson(json);

@override final  double totalStockValue;
@override final  double todaySales;
@override final  double monthlySales;
@override final  double totalExpenses;
@override final  double otherIncome;
@override final  double profit;
@override@JsonKey() final  int totalItems;
@override@JsonKey() final  int lowStockCount;
 final  List<DashboardTransaction> _recentTransactions;
@override@JsonKey() List<DashboardTransaction> get recentTransactions {
  if (_recentTransactions is EqualUnmodifiableListView) return _recentTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentTransactions);
}

 final  List<Map<String, dynamic>>? _salesHistory;
@override List<Map<String, dynamic>>? get salesHistory {
  final value = _salesHistory;
  if (value == null) return null;
  if (_salesHistory is EqualUnmodifiableListView) return _salesHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Map<String, dynamic>>? _topItems;
@override List<Map<String, dynamic>>? get topItems {
  final value = _topItems;
  if (value == null) return null;
  if (_topItems is EqualUnmodifiableListView) return _topItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.totalStockValue, totalStockValue) || other.totalStockValue == totalStockValue)&&(identical(other.todaySales, todaySales) || other.todaySales == todaySales)&&(identical(other.monthlySales, monthlySales) || other.monthlySales == monthlySales)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.otherIncome, otherIncome) || other.otherIncome == otherIncome)&&(identical(other.profit, profit) || other.profit == profit)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&const DeepCollectionEquality().equals(other._recentTransactions, _recentTransactions)&&const DeepCollectionEquality().equals(other._salesHistory, _salesHistory)&&const DeepCollectionEquality().equals(other._topItems, _topItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalStockValue,todaySales,monthlySales,totalExpenses,otherIncome,profit,totalItems,lowStockCount,const DeepCollectionEquality().hash(_recentTransactions),const DeepCollectionEquality().hash(_salesHistory),const DeepCollectionEquality().hash(_topItems));

@override
String toString() {
  return 'DashboardSummary(totalStockValue: $totalStockValue, todaySales: $todaySales, monthlySales: $monthlySales, totalExpenses: $totalExpenses, otherIncome: $otherIncome, profit: $profit, totalItems: $totalItems, lowStockCount: $lowStockCount, recentTransactions: $recentTransactions, salesHistory: $salesHistory, topItems: $topItems)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 double totalStockValue, double todaySales, double monthlySales, double totalExpenses, double otherIncome, double profit, int totalItems, int lowStockCount, List<DashboardTransaction> recentTransactions, List<Map<String, dynamic>>? salesHistory, List<Map<String, dynamic>>? topItems
});




}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalStockValue = null,Object? todaySales = null,Object? monthlySales = null,Object? totalExpenses = null,Object? otherIncome = null,Object? profit = null,Object? totalItems = null,Object? lowStockCount = null,Object? recentTransactions = null,Object? salesHistory = freezed,Object? topItems = freezed,}) {
  return _then(_DashboardSummary(
totalStockValue: null == totalStockValue ? _self.totalStockValue : totalStockValue // ignore: cast_nullable_to_non_nullable
as double,todaySales: null == todaySales ? _self.todaySales : todaySales // ignore: cast_nullable_to_non_nullable
as double,monthlySales: null == monthlySales ? _self.monthlySales : monthlySales // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,otherIncome: null == otherIncome ? _self.otherIncome : otherIncome // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,recentTransactions: null == recentTransactions ? _self._recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<DashboardTransaction>,salesHistory: freezed == salesHistory ? _self._salesHistory : salesHistory // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,topItems: freezed == topItems ? _self._topItems : topItems // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,
  ));
}


}

// dart format on
