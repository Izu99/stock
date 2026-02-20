// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockItem {

@JsonKey(name: '_id') String get id; String? get companyId; String get name; double get buyPrice; double get sellPrice; double get quantity; ItemUnit get unit; String get category; String? get subcategory; DateTime get date; String? get note;
/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockItemCopyWith<StockItem> get copyWith => _$StockItemCopyWithImpl<StockItem>(this as StockItem, _$identity);

  /// Serializes this StockItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockItem&&(identical(other.id, id) || other.id == id)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.buyPrice, buyPrice) || other.buyPrice == buyPrice)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyId,name,buyPrice,sellPrice,quantity,unit,category,subcategory,date,note);

@override
String toString() {
  return 'StockItem(id: $id, companyId: $companyId, name: $name, buyPrice: $buyPrice, sellPrice: $sellPrice, quantity: $quantity, unit: $unit, category: $category, subcategory: $subcategory, date: $date, note: $note)';
}


}

/// @nodoc
abstract mixin class $StockItemCopyWith<$Res>  {
  factory $StockItemCopyWith(StockItem value, $Res Function(StockItem) _then) = _$StockItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String? companyId, String name, double buyPrice, double sellPrice, double quantity, ItemUnit unit, String category, String? subcategory, DateTime date, String? note
});




}
/// @nodoc
class _$StockItemCopyWithImpl<$Res>
    implements $StockItemCopyWith<$Res> {
  _$StockItemCopyWithImpl(this._self, this._then);

  final StockItem _self;
  final $Res Function(StockItem) _then;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? companyId = freezed,Object? name = null,Object? buyPrice = null,Object? sellPrice = null,Object? quantity = null,Object? unit = null,Object? category = null,Object? subcategory = freezed,Object? date = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,buyPrice: null == buyPrice ? _self.buyPrice : buyPrice // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ItemUnit,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockItem].
extension StockItemPatterns on StockItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockItem value)  $default,){
final _that = this;
switch (_that) {
case _StockItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockItem value)?  $default,){
final _that = this;
switch (_that) {
case _StockItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? companyId,  String name,  double buyPrice,  double sellPrice,  double quantity,  ItemUnit unit,  String category,  String? subcategory,  DateTime date,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that.id,_that.companyId,_that.name,_that.buyPrice,_that.sellPrice,_that.quantity,_that.unit,_that.category,_that.subcategory,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? companyId,  String name,  double buyPrice,  double sellPrice,  double quantity,  ItemUnit unit,  String category,  String? subcategory,  DateTime date,  String? note)  $default,) {final _that = this;
switch (_that) {
case _StockItem():
return $default(_that.id,_that.companyId,_that.name,_that.buyPrice,_that.sellPrice,_that.quantity,_that.unit,_that.category,_that.subcategory,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String? companyId,  String name,  double buyPrice,  double sellPrice,  double quantity,  ItemUnit unit,  String category,  String? subcategory,  DateTime date,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _StockItem() when $default != null:
return $default(_that.id,_that.companyId,_that.name,_that.buyPrice,_that.sellPrice,_that.quantity,_that.unit,_that.category,_that.subcategory,_that.date,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockItem implements StockItem {
  const _StockItem({@JsonKey(name: '_id') required this.id, this.companyId, required this.name, required this.buyPrice, required this.sellPrice, required this.quantity, required this.unit, required this.category, this.subcategory, required this.date, this.note});
  factory _StockItem.fromJson(Map<String, dynamic> json) => _$StockItemFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String? companyId;
@override final  String name;
@override final  double buyPrice;
@override final  double sellPrice;
@override final  double quantity;
@override final  ItemUnit unit;
@override final  String category;
@override final  String? subcategory;
@override final  DateTime date;
@override final  String? note;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockItemCopyWith<_StockItem> get copyWith => __$StockItemCopyWithImpl<_StockItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockItem&&(identical(other.id, id) || other.id == id)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.buyPrice, buyPrice) || other.buyPrice == buyPrice)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category)&&(identical(other.subcategory, subcategory) || other.subcategory == subcategory)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,companyId,name,buyPrice,sellPrice,quantity,unit,category,subcategory,date,note);

@override
String toString() {
  return 'StockItem(id: $id, companyId: $companyId, name: $name, buyPrice: $buyPrice, sellPrice: $sellPrice, quantity: $quantity, unit: $unit, category: $category, subcategory: $subcategory, date: $date, note: $note)';
}


}

/// @nodoc
abstract mixin class _$StockItemCopyWith<$Res> implements $StockItemCopyWith<$Res> {
  factory _$StockItemCopyWith(_StockItem value, $Res Function(_StockItem) _then) = __$StockItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String? companyId, String name, double buyPrice, double sellPrice, double quantity, ItemUnit unit, String category, String? subcategory, DateTime date, String? note
});




}
/// @nodoc
class __$StockItemCopyWithImpl<$Res>
    implements _$StockItemCopyWith<$Res> {
  __$StockItemCopyWithImpl(this._self, this._then);

  final _StockItem _self;
  final $Res Function(_StockItem) _then;

/// Create a copy of StockItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? companyId = freezed,Object? name = null,Object? buyPrice = null,Object? sellPrice = null,Object? quantity = null,Object? unit = null,Object? category = null,Object? subcategory = freezed,Object? date = null,Object? note = freezed,}) {
  return _then(_StockItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,buyPrice: null == buyPrice ? _self.buyPrice : buyPrice // ignore: cast_nullable_to_non_nullable
as double,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as ItemUnit,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,subcategory: freezed == subcategory ? _self.subcategory : subcategory // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
