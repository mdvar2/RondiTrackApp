// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle_close_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CycleClosePreview {

/// `cycleId`.
 String get cycleId;/// `period`, such as `2026-11`.
 String get period;/// `asOfDate`: the Johannesburg day the preview was worked out for.
 CalendarDate get asOf;/// `version`, kept exactly as sent: the close request must send it
/// back, and a stale one is refused.
 ConcurrencyToken get version;/// `arrears`: who would be recorded short, and by how much.
 List<CloseArrear> get arrears;/// `totalCents`.
 Cents get total;
/// Create a copy of CycleClosePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleClosePreviewCopyWith<CycleClosePreview> get copyWith => _$CycleClosePreviewCopyWithImpl<CycleClosePreview>(this as CycleClosePreview, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CycleClosePreview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleClosePreview&&(identical(other.cycleId, _this.cycleId) || other.cycleId == _this.cycleId)&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.asOf, _this.asOf) || other.asOf == _this.asOf)&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.arrears, _this.arrears)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as CycleClosePreview;
  return Object.hash(runtimeType,_this.cycleId,_this.period,_this.asOf,_this.version,const DeepCollectionEquality().hash(_this.arrears),_this.total);
}

@override
String toString() {
  final _this = this as CycleClosePreview;
  return 'CycleClosePreview(cycleId: ${_this.cycleId}, period: ${_this.period}, asOf: ${_this.asOf}, version: ${_this.version}, arrears: ${_this.arrears}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $CycleClosePreviewCopyWith<$Res>  {
  factory $CycleClosePreviewCopyWith(CycleClosePreview value, $Res Function(CycleClosePreview) _then) = _$CycleClosePreviewCopyWithImpl;
@useResult
$Res call({
 String cycleId, String period, CalendarDate asOf, ConcurrencyToken version, List<CloseArrear> arrears, Cents total
});




}
/// @nodoc
class _$CycleClosePreviewCopyWithImpl<$Res>
    implements $CycleClosePreviewCopyWith<$Res> {
  _$CycleClosePreviewCopyWithImpl(this._self, this._then);

  final CycleClosePreview _self;
  final $Res Function(CycleClosePreview) _then;

/// Create a copy of CycleClosePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cycleId = null,Object? period = null,Object? asOf = null,Object? version = null,Object? arrears = null,Object? total = null,}) {
  return _then(CycleClosePreview(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as CalendarDate,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as ConcurrencyToken,arrears: null == arrears ? _self.arrears : arrears // ignore: cast_nullable_to_non_nullable
as List<CloseArrear>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}

}


/// Adds pattern-matching-related methods to [CycleClosePreview].
extension CycleClosePreviewPatterns on CycleClosePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleClosePreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleClosePreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleClosePreview value)  $default,){
final _that = this;
switch (_that) {
case _CycleClosePreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleClosePreview value)?  $default,){
final _that = this;
switch (_that) {
case _CycleClosePreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cycleId,  String period,  CalendarDate asOf,  ConcurrencyToken version,  List<CloseArrear> arrears,  Cents total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleClosePreview() when $default != null:
return $default(_that.cycleId,_that.period,_that.asOf,_that.version,_that.arrears,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cycleId,  String period,  CalendarDate asOf,  ConcurrencyToken version,  List<CloseArrear> arrears,  Cents total)  $default,) {final _that = this;
switch (_that) {
case _CycleClosePreview():
return $default(_that.cycleId,_that.period,_that.asOf,_that.version,_that.arrears,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cycleId,  String period,  CalendarDate asOf,  ConcurrencyToken version,  List<CloseArrear> arrears,  Cents total)?  $default,) {final _that = this;
switch (_that) {
case _CycleClosePreview() when $default != null:
return $default(_that.cycleId,_that.period,_that.asOf,_that.version,_that.arrears,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _CycleClosePreview implements CycleClosePreview {
  const _CycleClosePreview({required this.cycleId, required this.period, required this.asOf, required this.version, required  List<CloseArrear> arrears, required this.total}): _arrears = arrears;
  

/// `cycleId`.
@override final  String cycleId;
/// `period`, such as `2026-11`.
@override final  String period;
/// `asOfDate`: the Johannesburg day the preview was worked out for.
@override final  CalendarDate asOf;
/// `version`, kept exactly as sent: the close request must send it
/// back, and a stale one is refused.
@override final  ConcurrencyToken version;
/// `arrears`: who would be recorded short, and by how much.
 final  List<CloseArrear> _arrears;
/// `arrears`: who would be recorded short, and by how much.
@override List<CloseArrear> get arrears {
  if (_arrears is EqualUnmodifiableListView) return _arrears;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_arrears);
}

/// `totalCents`.
@override final  Cents total;

/// Create a copy of CycleClosePreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleClosePreviewCopyWith<_CycleClosePreview> get copyWith => __$CycleClosePreviewCopyWithImpl<_CycleClosePreview>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleClosePreview&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.period, period) || other.period == period)&&(identical(other.asOf, asOf) || other.asOf == asOf)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.arrears, _arrears)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,cycleId,period,asOf,version,const DeepCollectionEquality().hash(_arrears),total);
}

@override
String toString() {
    return 'CycleClosePreview(cycleId: $cycleId, period: $period, asOf: $asOf, version: $version, arrears: $arrears, total: $total)';
}


}

/// @nodoc
abstract mixin class _$CycleClosePreviewCopyWith<$Res> implements $CycleClosePreviewCopyWith<$Res> {
  factory _$CycleClosePreviewCopyWith(_CycleClosePreview value, $Res Function(_CycleClosePreview) _then) = __$CycleClosePreviewCopyWithImpl;
@override @useResult
$Res call({
 String cycleId, String period, CalendarDate asOf, ConcurrencyToken version, List<CloseArrear> arrears, Cents total
});




}
/// @nodoc
class __$CycleClosePreviewCopyWithImpl<$Res>
    implements _$CycleClosePreviewCopyWith<$Res> {
  __$CycleClosePreviewCopyWithImpl(this._self, this._then);

  final _CycleClosePreview _self;
  final $Res Function(_CycleClosePreview) _then;

/// Create a copy of CycleClosePreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cycleId = null,Object? period = null,Object? asOf = null,Object? version = null,Object? arrears = null,Object? total = null,}) {
  return _then(_CycleClosePreview(
cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as CalendarDate,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as ConcurrencyToken,arrears: null == arrears ? _self._arrears : arrears // ignore: cast_nullable_to_non_nullable
as List<CloseArrear>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}


}

/// @nodoc
mixin _$CloseArrear {

/// `userId`.
 String get userId;/// `userName`.
 String get memberName;/// `amountCents`.
 Cents get amount;
/// Create a copy of CloseArrear
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloseArrearCopyWith<CloseArrear> get copyWith => _$CloseArrearCopyWithImpl<CloseArrear>(this as CloseArrear, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CloseArrear;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloseArrear&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}


@override
int get hashCode {
  final _this = this as CloseArrear;
  return Object.hash(runtimeType,_this.userId,_this.memberName,_this.amount);
}

@override
String toString() {
  final _this = this as CloseArrear;
  return 'CloseArrear(userId: ${_this.userId}, memberName: ${_this.memberName}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $CloseArrearCopyWith<$Res>  {
  factory $CloseArrearCopyWith(CloseArrear value, $Res Function(CloseArrear) _then) = _$CloseArrearCopyWithImpl;
@useResult
$Res call({
 String userId, String memberName, Cents amount
});




}
/// @nodoc
class _$CloseArrearCopyWithImpl<$Res>
    implements $CloseArrearCopyWith<$Res> {
  _$CloseArrearCopyWithImpl(this._self, this._then);

  final CloseArrear _self;
  final $Res Function(CloseArrear) _then;

/// Create a copy of CloseArrear
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? memberName = null,Object? amount = null,}) {
  return _then(CloseArrear(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}

}


/// Adds pattern-matching-related methods to [CloseArrear].
extension CloseArrearPatterns on CloseArrear {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloseArrear value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloseArrear() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloseArrear value)  $default,){
final _that = this;
switch (_that) {
case _CloseArrear():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloseArrear value)?  $default,){
final _that = this;
switch (_that) {
case _CloseArrear() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String memberName,  Cents amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloseArrear() when $default != null:
return $default(_that.userId,_that.memberName,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String memberName,  Cents amount)  $default,) {final _that = this;
switch (_that) {
case _CloseArrear():
return $default(_that.userId,_that.memberName,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String memberName,  Cents amount)?  $default,) {final _that = this;
switch (_that) {
case _CloseArrear() when $default != null:
return $default(_that.userId,_that.memberName,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _CloseArrear implements CloseArrear {
  const _CloseArrear({required this.userId, required this.memberName, required this.amount});
  

/// `userId`.
@override final  String userId;
/// `userName`.
@override final  String memberName;
/// `amountCents`.
@override final  Cents amount;

/// Create a copy of CloseArrear
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloseArrearCopyWith<_CloseArrear> get copyWith => __$CloseArrearCopyWithImpl<_CloseArrear>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloseArrear&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,memberName,amount);
}

@override
String toString() {
    return 'CloseArrear(userId: $userId, memberName: $memberName, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$CloseArrearCopyWith<$Res> implements $CloseArrearCopyWith<$Res> {
  factory _$CloseArrearCopyWith(_CloseArrear value, $Res Function(_CloseArrear) _then) = __$CloseArrearCopyWithImpl;
@override @useResult
$Res call({
 String userId, String memberName, Cents amount
});




}
/// @nodoc
class __$CloseArrearCopyWithImpl<$Res>
    implements _$CloseArrearCopyWith<$Res> {
  __$CloseArrearCopyWithImpl(this._self, this._then);

  final _CloseArrear _self;
  final $Res Function(_CloseArrear) _then;

/// Create a copy of CloseArrear
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? memberName = null,Object? amount = null,}) {
  return _then(_CloseArrear(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}


}

// dart format on
