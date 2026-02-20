// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompanySummary {

 int get totalCompanies; int get activeCompanies; int get inactiveCompanies;
/// Create a copy of CompanySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanySummaryCopyWith<CompanySummary> get copyWith => _$CompanySummaryCopyWithImpl<CompanySummary>(this as CompanySummary, _$identity);

  /// Serializes this CompanySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanySummary&&(identical(other.totalCompanies, totalCompanies) || other.totalCompanies == totalCompanies)&&(identical(other.activeCompanies, activeCompanies) || other.activeCompanies == activeCompanies)&&(identical(other.inactiveCompanies, inactiveCompanies) || other.inactiveCompanies == inactiveCompanies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCompanies,activeCompanies,inactiveCompanies);

@override
String toString() {
  return 'CompanySummary(totalCompanies: $totalCompanies, activeCompanies: $activeCompanies, inactiveCompanies: $inactiveCompanies)';
}


}

/// @nodoc
abstract mixin class $CompanySummaryCopyWith<$Res>  {
  factory $CompanySummaryCopyWith(CompanySummary value, $Res Function(CompanySummary) _then) = _$CompanySummaryCopyWithImpl;
@useResult
$Res call({
 int totalCompanies, int activeCompanies, int inactiveCompanies
});




}
/// @nodoc
class _$CompanySummaryCopyWithImpl<$Res>
    implements $CompanySummaryCopyWith<$Res> {
  _$CompanySummaryCopyWithImpl(this._self, this._then);

  final CompanySummary _self;
  final $Res Function(CompanySummary) _then;

/// Create a copy of CompanySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCompanies = null,Object? activeCompanies = null,Object? inactiveCompanies = null,}) {
  return _then(_self.copyWith(
totalCompanies: null == totalCompanies ? _self.totalCompanies : totalCompanies // ignore: cast_nullable_to_non_nullable
as int,activeCompanies: null == activeCompanies ? _self.activeCompanies : activeCompanies // ignore: cast_nullable_to_non_nullable
as int,inactiveCompanies: null == inactiveCompanies ? _self.inactiveCompanies : inactiveCompanies // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanySummary].
extension CompanySummaryPatterns on CompanySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanySummary value)  $default,){
final _that = this;
switch (_that) {
case _CompanySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanySummary value)?  $default,){
final _that = this;
switch (_that) {
case _CompanySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCompanies,  int activeCompanies,  int inactiveCompanies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanySummary() when $default != null:
return $default(_that.totalCompanies,_that.activeCompanies,_that.inactiveCompanies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCompanies,  int activeCompanies,  int inactiveCompanies)  $default,) {final _that = this;
switch (_that) {
case _CompanySummary():
return $default(_that.totalCompanies,_that.activeCompanies,_that.inactiveCompanies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCompanies,  int activeCompanies,  int inactiveCompanies)?  $default,) {final _that = this;
switch (_that) {
case _CompanySummary() when $default != null:
return $default(_that.totalCompanies,_that.activeCompanies,_that.inactiveCompanies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanySummary implements CompanySummary {
  const _CompanySummary({required this.totalCompanies, required this.activeCompanies, required this.inactiveCompanies});
  factory _CompanySummary.fromJson(Map<String, dynamic> json) => _$CompanySummaryFromJson(json);

@override final  int totalCompanies;
@override final  int activeCompanies;
@override final  int inactiveCompanies;

/// Create a copy of CompanySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanySummaryCopyWith<_CompanySummary> get copyWith => __$CompanySummaryCopyWithImpl<_CompanySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanySummary&&(identical(other.totalCompanies, totalCompanies) || other.totalCompanies == totalCompanies)&&(identical(other.activeCompanies, activeCompanies) || other.activeCompanies == activeCompanies)&&(identical(other.inactiveCompanies, inactiveCompanies) || other.inactiveCompanies == inactiveCompanies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCompanies,activeCompanies,inactiveCompanies);

@override
String toString() {
  return 'CompanySummary(totalCompanies: $totalCompanies, activeCompanies: $activeCompanies, inactiveCompanies: $inactiveCompanies)';
}


}

/// @nodoc
abstract mixin class _$CompanySummaryCopyWith<$Res> implements $CompanySummaryCopyWith<$Res> {
  factory _$CompanySummaryCopyWith(_CompanySummary value, $Res Function(_CompanySummary) _then) = __$CompanySummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalCompanies, int activeCompanies, int inactiveCompanies
});




}
/// @nodoc
class __$CompanySummaryCopyWithImpl<$Res>
    implements _$CompanySummaryCopyWith<$Res> {
  __$CompanySummaryCopyWithImpl(this._self, this._then);

  final _CompanySummary _self;
  final $Res Function(_CompanySummary) _then;

/// Create a copy of CompanySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCompanies = null,Object? activeCompanies = null,Object? inactiveCompanies = null,}) {
  return _then(_CompanySummary(
totalCompanies: null == totalCompanies ? _self.totalCompanies : totalCompanies // ignore: cast_nullable_to_non_nullable
as int,activeCompanies: null == activeCompanies ? _self.activeCompanies : activeCompanies // ignore: cast_nullable_to_non_nullable
as int,inactiveCompanies: null == inactiveCompanies ? _self.inactiveCompanies : inactiveCompanies // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
