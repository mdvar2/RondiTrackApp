// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PayoutOrder {

/// `stokvelId`.
 String get stokvelId;/// `cycleId`.
 String get cycleId;/// `items`, in the API's order (the rotation). Empty when the cycle has
/// no payout order.
 List<PayoutEntry> get entries;
/// Create a copy of PayoutOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutOrderCopyWith<PayoutOrder> get copyWith => _$PayoutOrderCopyWithImpl<PayoutOrder>(this as PayoutOrder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PayoutOrder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutOrder&&(identical(other.stokvelId, _this.stokvelId) || other.stokvelId == _this.stokvelId)&&(identical(other.cycleId, _this.cycleId) || other.cycleId == _this.cycleId)&&const DeepCollectionEquality().equals(other.entries, _this.entries));
}


@override
int get hashCode {
  final _this = this as PayoutOrder;
  return Object.hash(runtimeType,_this.stokvelId,_this.cycleId,const DeepCollectionEquality().hash(_this.entries));
}

@override
String toString() {
  final _this = this as PayoutOrder;
  return 'PayoutOrder(stokvelId: ${_this.stokvelId}, cycleId: ${_this.cycleId}, entries: ${_this.entries})';
}


}

/// @nodoc
abstract mixin class $PayoutOrderCopyWith<$Res>  {
  factory $PayoutOrderCopyWith(PayoutOrder value, $Res Function(PayoutOrder) _then) = _$PayoutOrderCopyWithImpl;
@useResult
$Res call({
 String stokvelId, String cycleId, List<PayoutEntry> entries
});




}
/// @nodoc
class _$PayoutOrderCopyWithImpl<$Res>
    implements $PayoutOrderCopyWith<$Res> {
  _$PayoutOrderCopyWithImpl(this._self, this._then);

  final PayoutOrder _self;
  final $Res Function(PayoutOrder) _then;

/// Create a copy of PayoutOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stokvelId = null,Object? cycleId = null,Object? entries = null,}) {
  return _then(PayoutOrder(
stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<PayoutEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutOrder].
extension PayoutOrderPatterns on PayoutOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutOrder value)  $default,){
final _that = this;
switch (_that) {
case _PayoutOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stokvelId,  String cycleId,  List<PayoutEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutOrder() when $default != null:
return $default(_that.stokvelId,_that.cycleId,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stokvelId,  String cycleId,  List<PayoutEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _PayoutOrder():
return $default(_that.stokvelId,_that.cycleId,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stokvelId,  String cycleId,  List<PayoutEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _PayoutOrder() when $default != null:
return $default(_that.stokvelId,_that.cycleId,_that.entries);case _:
  return null;

}
}

}

/// @nodoc


class _PayoutOrder implements PayoutOrder {
  const _PayoutOrder({required this.stokvelId, required this.cycleId, required  List<PayoutEntry> entries}): _entries = entries;
  

/// `stokvelId`.
@override final  String stokvelId;
/// `cycleId`.
@override final  String cycleId;
/// `items`, in the API's order (the rotation). Empty when the cycle has
/// no payout order.
 final  List<PayoutEntry> _entries;
/// `items`, in the API's order (the rotation). Empty when the cycle has
/// no payout order.
@override List<PayoutEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of PayoutOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutOrderCopyWith<_PayoutOrder> get copyWith => __$PayoutOrderCopyWithImpl<_PayoutOrder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutOrder&&(identical(other.stokvelId, stokvelId) || other.stokvelId == stokvelId)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&const DeepCollectionEquality().equals(other.entries, _entries));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stokvelId,cycleId,const DeepCollectionEquality().hash(_entries));
}

@override
String toString() {
    return 'PayoutOrder(stokvelId: $stokvelId, cycleId: $cycleId, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$PayoutOrderCopyWith<$Res> implements $PayoutOrderCopyWith<$Res> {
  factory _$PayoutOrderCopyWith(_PayoutOrder value, $Res Function(_PayoutOrder) _then) = __$PayoutOrderCopyWithImpl;
@override @useResult
$Res call({
 String stokvelId, String cycleId, List<PayoutEntry> entries
});




}
/// @nodoc
class __$PayoutOrderCopyWithImpl<$Res>
    implements _$PayoutOrderCopyWith<$Res> {
  __$PayoutOrderCopyWithImpl(this._self, this._then);

  final _PayoutOrder _self;
  final $Res Function(_PayoutOrder) _then;

/// Create a copy of PayoutOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stokvelId = null,Object? cycleId = null,Object? entries = null,}) {
  return _then(_PayoutOrder(
stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<PayoutEntry>,
  ));
}


}

/// @nodoc
mixin _$PayoutEntry {

/// `position`, 1-based, as the API numbers it. Shown, never sorted on.
 int get position;/// `userId`.
 String get userId;/// `memberName`.
 String get memberName;/// `amountCents`: the payout for a paid member, the cycle's pot for the
/// rest. The API's number, never computed here.
 Cents get amount;/// `paidAtUtc`, an instant; `null` unless `status` is
/// [PayoutStatus.paid].
 DateTime? get paidAt;/// `status`.
 PayoutStatus get status;
/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutEntryCopyWith<PayoutEntry> get copyWith => _$PayoutEntryCopyWithImpl<PayoutEntry>(this as PayoutEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PayoutEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutEntry&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as PayoutEntry;
  return Object.hash(runtimeType,_this.position,_this.userId,_this.memberName,_this.amount,_this.paidAt,_this.status);
}

@override
String toString() {
  final _this = this as PayoutEntry;
  return 'PayoutEntry(position: ${_this.position}, userId: ${_this.userId}, memberName: ${_this.memberName}, amount: ${_this.amount}, paidAt: ${_this.paidAt}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $PayoutEntryCopyWith<$Res>  {
  factory $PayoutEntryCopyWith(PayoutEntry value, $Res Function(PayoutEntry) _then) = _$PayoutEntryCopyWithImpl;
@useResult
$Res call({
 int position, String userId, String memberName, Cents amount, DateTime? paidAt, PayoutStatus status
});




}
/// @nodoc
class _$PayoutEntryCopyWithImpl<$Res>
    implements $PayoutEntryCopyWith<$Res> {
  _$PayoutEntryCopyWithImpl(this._self, this._then);

  final PayoutEntry _self;
  final $Res Function(PayoutEntry) _then;

/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? userId = null,Object? memberName = null,Object? amount = null,Object? paidAt = freezed,Object? status = null,}) {
  return _then(PayoutEntry(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PayoutStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutEntry].
extension PayoutEntryPatterns on PayoutEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutEntry value)  $default,){
final _that = this;
switch (_that) {
case _PayoutEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int position,  String userId,  String memberName,  Cents amount,  DateTime? paidAt,  PayoutStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
return $default(_that.position,_that.userId,_that.memberName,_that.amount,_that.paidAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int position,  String userId,  String memberName,  Cents amount,  DateTime? paidAt,  PayoutStatus status)  $default,) {final _that = this;
switch (_that) {
case _PayoutEntry():
return $default(_that.position,_that.userId,_that.memberName,_that.amount,_that.paidAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int position,  String userId,  String memberName,  Cents amount,  DateTime? paidAt,  PayoutStatus status)?  $default,) {final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
return $default(_that.position,_that.userId,_that.memberName,_that.amount,_that.paidAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _PayoutEntry implements PayoutEntry {
  const _PayoutEntry({required this.position, required this.userId, required this.memberName, required this.amount, required this.paidAt, required this.status});
  

/// `position`, 1-based, as the API numbers it. Shown, never sorted on.
@override final  int position;
/// `userId`.
@override final  String userId;
/// `memberName`.
@override final  String memberName;
/// `amountCents`: the payout for a paid member, the cycle's pot for the
/// rest. The API's number, never computed here.
@override final  Cents amount;
/// `paidAtUtc`, an instant; `null` unless `status` is
/// [PayoutStatus.paid].
@override final  DateTime? paidAt;
/// `status`.
@override final  PayoutStatus status;

/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutEntryCopyWith<_PayoutEntry> get copyWith => __$PayoutEntryCopyWithImpl<_PayoutEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutEntry&&(identical(other.position, position) || other.position == position)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,position,userId,memberName,amount,paidAt,status);
}

@override
String toString() {
    return 'PayoutEntry(position: $position, userId: $userId, memberName: $memberName, amount: $amount, paidAt: $paidAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PayoutEntryCopyWith<$Res> implements $PayoutEntryCopyWith<$Res> {
  factory _$PayoutEntryCopyWith(_PayoutEntry value, $Res Function(_PayoutEntry) _then) = __$PayoutEntryCopyWithImpl;
@override @useResult
$Res call({
 int position, String userId, String memberName, Cents amount, DateTime? paidAt, PayoutStatus status
});




}
/// @nodoc
class __$PayoutEntryCopyWithImpl<$Res>
    implements _$PayoutEntryCopyWith<$Res> {
  __$PayoutEntryCopyWithImpl(this._self, this._then);

  final _PayoutEntry _self;
  final $Res Function(_PayoutEntry) _then;

/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? userId = null,Object? memberName = null,Object? amount = null,Object? paidAt = freezed,Object? status = null,}) {
  return _then(_PayoutEntry(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PayoutStatus,
  ));
}


}

// dart format on
