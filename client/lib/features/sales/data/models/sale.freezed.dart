// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sale {

@JsonKey(name: '_id') String get id; String? get companyId; List<SaleItem> get items; double get totalAmount; double get totalProfit; String get billId; DateTime get date;
/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleCopyWith<Sale> get copyWith => _$SaleCopyWithImpl<Sale>(this as Sale, _$identity);

  /// Serializes this Sale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyId,const DeepCollectionEquality().hash(items),totalAmount,totalProfit,billId,date);

@override
String toString() {
  return 'Sale(id: $id, companyId: $companyId, items: $items, totalAmount: $totalAmount, totalProfit: $totalProfit, billId: $billId, date: $date)';
}


}

/// @nodoc
abstract mixin class $SaleCopyWith<$Res>  {
  factory $SaleCopyWith(Sale value, $Res Function(Sale) _then) = _$SaleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String? companyId, List<SaleItem> items, double totalAmount, double totalProfit, String billId, DateTime date
});




}
/// @nodoc
class _$SaleCopyWithImpl<$Res>
    implements $SaleCopyWith<$Res> {
  _$SaleCopyWithImpl(this._self, this._then);

  final Sale _self;
  final $Res Function(Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? companyId = freezed,Object? items = null,Object? totalAmount = null,Object? totalProfit = null,Object? billId = null,Object? date = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,billId: null == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Sale].
extension SalePatterns on Sale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sale value)  $default,){
final _that = this;
switch (_that) {
case _Sale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sale value)?  $default,){
final _that = this;
switch (_that) {
case _Sale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? companyId,  List<SaleItem> items,  double totalAmount,  double totalProfit,  String billId,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.companyId,_that.items,_that.totalAmount,_that.totalProfit,_that.billId,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? companyId,  List<SaleItem> items,  double totalAmount,  double totalProfit,  String billId,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _Sale():
return $default(_that.id,_that.companyId,_that.items,_that.totalAmount,_that.totalProfit,_that.billId,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String? companyId,  List<SaleItem> items,  double totalAmount,  double totalProfit,  String billId,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _Sale() when $default != null:
return $default(_that.id,_that.companyId,_that.items,_that.totalAmount,_that.totalProfit,_that.billId,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sale implements Sale {
  const _Sale({@JsonKey(name: '_id') required this.id, this.companyId, required final  List<SaleItem> items, required this.totalAmount, required this.totalProfit, required this.billId, required this.date}): _items = items;
  factory _Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String? companyId;
 final  List<SaleItem> _items;
@override List<SaleItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double totalAmount;
@override final  double totalProfit;
@override final  String billId;
@override final  DateTime date;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleCopyWith<_Sale> get copyWith => __$SaleCopyWithImpl<_Sale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sale&&(identical(other.id, id) || other.id == id)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalProfit, totalProfit) || other.totalProfit == totalProfit)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyId,const DeepCollectionEquality().hash(_items),totalAmount,totalProfit,billId,date);

@override
String toString() {
  return 'Sale(id: $id, companyId: $companyId, items: $items, totalAmount: $totalAmount, totalProfit: $totalProfit, billId: $billId, date: $date)';
}


}

/// @nodoc
abstract mixin class _$SaleCopyWith<$Res> implements $SaleCopyWith<$Res> {
  factory _$SaleCopyWith(_Sale value, $Res Function(_Sale) _then) = __$SaleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String? companyId, List<SaleItem> items, double totalAmount, double totalProfit, String billId, DateTime date
});




}
/// @nodoc
class __$SaleCopyWithImpl<$Res>
    implements _$SaleCopyWith<$Res> {
  __$SaleCopyWithImpl(this._self, this._then);

  final _Sale _self;
  final $Res Function(_Sale) _then;

/// Create a copy of Sale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? companyId = freezed,Object? items = null,Object? totalAmount = null,Object? totalProfit = null,Object? billId = null,Object? date = null,}) {
  return _then(_Sale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SaleItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,totalProfit: null == totalProfit ? _self.totalProfit : totalProfit // ignore: cast_nullable_to_non_nullable
as double,billId: null == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
