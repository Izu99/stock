// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleItem {

@JsonKey(name: 'item') String get itemId; String get itemName; double get quantity; double get sellPrice; double get subtotal; double get profit;
/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaleItemCopyWith<SaleItem> get copyWith => _$SaleItemCopyWithImpl<SaleItem>(this as SaleItem, _$identity);

  /// Serializes this SaleItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaleItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.profit, profit) || other.profit == profit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,itemName,quantity,sellPrice,subtotal,profit);

@override
String toString() {
  return 'SaleItem(itemId: $itemId, itemName: $itemName, quantity: $quantity, sellPrice: $sellPrice, subtotal: $subtotal, profit: $profit)';
}


}

/// @nodoc
abstract mixin class $SaleItemCopyWith<$Res>  {
  factory $SaleItemCopyWith(SaleItem value, $Res Function(SaleItem) _then) = _$SaleItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'item') String itemId, String itemName, double quantity, double sellPrice, double subtotal, double profit
});




}
/// @nodoc
class _$SaleItemCopyWithImpl<$Res>
    implements $SaleItemCopyWith<$Res> {
  _$SaleItemCopyWithImpl(this._self, this._then);

  final SaleItem _self;
  final $Res Function(SaleItem) _then;

/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? itemName = null,Object? quantity = null,Object? sellPrice = null,Object? subtotal = null,Object? profit = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SaleItem].
extension SaleItemPatterns on SaleItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaleItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaleItem value)  $default,){
final _that = this;
switch (_that) {
case _SaleItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaleItem value)?  $default,){
final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'item')  String itemId,  String itemName,  double quantity,  double sellPrice,  double subtotal,  double profit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
return $default(_that.itemId,_that.itemName,_that.quantity,_that.sellPrice,_that.subtotal,_that.profit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'item')  String itemId,  String itemName,  double quantity,  double sellPrice,  double subtotal,  double profit)  $default,) {final _that = this;
switch (_that) {
case _SaleItem():
return $default(_that.itemId,_that.itemName,_that.quantity,_that.sellPrice,_that.subtotal,_that.profit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'item')  String itemId,  String itemName,  double quantity,  double sellPrice,  double subtotal,  double profit)?  $default,) {final _that = this;
switch (_that) {
case _SaleItem() when $default != null:
return $default(_that.itemId,_that.itemName,_that.quantity,_that.sellPrice,_that.subtotal,_that.profit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaleItem implements SaleItem {
  const _SaleItem({@JsonKey(name: 'item') required this.itemId, required this.itemName, required this.quantity, required this.sellPrice, required this.subtotal, required this.profit});
  factory _SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);

@override@JsonKey(name: 'item') final  String itemId;
@override final  String itemName;
@override final  double quantity;
@override final  double sellPrice;
@override final  double subtotal;
@override final  double profit;

/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaleItemCopyWith<_SaleItem> get copyWith => __$SaleItemCopyWithImpl<_SaleItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaleItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaleItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.profit, profit) || other.profit == profit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,itemName,quantity,sellPrice,subtotal,profit);

@override
String toString() {
  return 'SaleItem(itemId: $itemId, itemName: $itemName, quantity: $quantity, sellPrice: $sellPrice, subtotal: $subtotal, profit: $profit)';
}


}

/// @nodoc
abstract mixin class _$SaleItemCopyWith<$Res> implements $SaleItemCopyWith<$Res> {
  factory _$SaleItemCopyWith(_SaleItem value, $Res Function(_SaleItem) _then) = __$SaleItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'item') String itemId, String itemName, double quantity, double sellPrice, double subtotal, double profit
});




}
/// @nodoc
class __$SaleItemCopyWithImpl<$Res>
    implements _$SaleItemCopyWith<$Res> {
  __$SaleItemCopyWithImpl(this._self, this._then);

  final _SaleItem _self;
  final $Res Function(_SaleItem) _then;

/// Create a copy of SaleItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? itemName = null,Object? quantity = null,Object? sellPrice = null,Object? subtotal = null,Object? profit = null,}) {
  return _then(_SaleItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,profit: null == profit ? _self.profit : profit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
