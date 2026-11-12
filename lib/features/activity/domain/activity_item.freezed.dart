// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityItem {

/// The contribution's id.
 String get id;/// The stokvel it happened in.
 String get stokvelId;/// That stokvel's name.
 String get stokvelName;/// The cycle it belongs to, so the item can open it.
 String get cycleId;/// Who contributed.
 String get memberName;/// How much.
 Cents get amount;/// The contribution's status.
 ContributionStatus get status;/// When it was recorded, an instant.
 DateTime get occurredAt;
/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityItemCopyWith<ActivityItem> get copyWith => _$ActivityItemCopyWithImpl<ActivityItem>(this as ActivityItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ActivityItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.stokvelId, _this.stokvelId) || other.stokvelId == _this.stokvelId)&&(identical(other.stokvelName, _this.stokvelName) || other.stokvelName == _this.stokvelName)&&(identical(other.cycleId, _this.cycleId) || other.cycleId == _this.cycleId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt));
}


@override
int get hashCode {
  final _this = this as ActivityItem;
  return Object.hash(runtimeType,_this.id,_this.stokvelId,_this.stokvelName,_this.cycleId,_this.memberName,_this.amount,_this.status,_this.occurredAt);
}

@override
String toString() {
  final _this = this as ActivityItem;
  return 'ActivityItem(id: ${_this.id}, stokvelId: ${_this.stokvelId}, stokvelName: ${_this.stokvelName}, cycleId: ${_this.cycleId}, memberName: ${_this.memberName}, amount: ${_this.amount}, status: ${_this.status}, occurredAt: ${_this.occurredAt})';
}


}

/// @nodoc
abstract mixin class $ActivityItemCopyWith<$Res>  {
  factory $ActivityItemCopyWith(ActivityItem value, $Res Function(ActivityItem) _then) = _$ActivityItemCopyWithImpl;
@useResult
$Res call({
 String id, String stokvelId, String stokvelName, String cycleId, String memberName, Cents amount, ContributionStatus status, DateTime occurredAt
});




}
/// @nodoc
class _$ActivityItemCopyWithImpl<$Res>
    implements $ActivityItemCopyWith<$Res> {
  _$ActivityItemCopyWithImpl(this._self, this._then);

  final ActivityItem _self;
  final $Res Function(ActivityItem) _then;

/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? stokvelId = null,Object? stokvelName = null,Object? cycleId = null,Object? memberName = null,Object? amount = null,Object? status = null,Object? occurredAt = null,}) {
  return _then(ActivityItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as String,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributionStatus,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityItem].
extension ActivityItemPatterns on ActivityItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityItem value)  $default,){
final _that = this;
switch (_that) {
case _ActivityItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityItem value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String stokvelId,  String stokvelName,  String cycleId,  String memberName,  Cents amount,  ContributionStatus status,  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
return $default(_that.id,_that.stokvelId,_that.stokvelName,_that.cycleId,_that.memberName,_that.amount,_that.status,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String stokvelId,  String stokvelName,  String cycleId,  String memberName,  Cents amount,  ContributionStatus status,  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _ActivityItem():
return $default(_that.id,_that.stokvelId,_that.stokvelName,_that.cycleId,_that.memberName,_that.amount,_that.status,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String stokvelId,  String stokvelName,  String cycleId,  String memberName,  Cents amount,  ContributionStatus status,  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivityItem() when $default != null:
return $default(_that.id,_that.stokvelId,_that.stokvelName,_that.cycleId,_that.memberName,_that.amount,_that.status,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityItem implements ActivityItem {
  const _ActivityItem({required this.id, required this.stokvelId, required this.stokvelName, required this.cycleId, required this.memberName, required this.amount, required this.status, required this.occurredAt});
  

/// The contribution's id.
@override final  String id;
/// The stokvel it happened in.
@override final  String stokvelId;
/// That stokvel's name.
@override final  String stokvelName;
/// The cycle it belongs to, so the item can open it.
@override final  String cycleId;
/// Who contributed.
@override final  String memberName;
/// How much.
@override final  Cents amount;
/// The contribution's status.
@override final  ContributionStatus status;
/// When it was recorded, an instant.
@override final  DateTime occurredAt;

/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityItemCopyWith<_ActivityItem> get copyWith => __$ActivityItemCopyWithImpl<_ActivityItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityItem&&(identical(other.id, id) || other.id == id)&&(identical(other.stokvelId, stokvelId) || other.stokvelId == stokvelId)&&(identical(other.stokvelName, stokvelName) || other.stokvelName == stokvelName)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,stokvelId,stokvelName,cycleId,memberName,amount,status,occurredAt);
}

@override
String toString() {
    return 'ActivityItem(id: $id, stokvelId: $stokvelId, stokvelName: $stokvelName, cycleId: $cycleId, memberName: $memberName, amount: $amount, status: $status, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$ActivityItemCopyWith<$Res> implements $ActivityItemCopyWith<$Res> {
  factory _$ActivityItemCopyWith(_ActivityItem value, $Res Function(_ActivityItem) _then) = __$ActivityItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String stokvelId, String stokvelName, String cycleId, String memberName, Cents amount, ContributionStatus status, DateTime occurredAt
});




}
/// @nodoc
class __$ActivityItemCopyWithImpl<$Res>
    implements _$ActivityItemCopyWith<$Res> {
  __$ActivityItemCopyWithImpl(this._self, this._then);

  final _ActivityItem _self;
  final $Res Function(_ActivityItem) _then;

/// Create a copy of ActivityItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? stokvelId = null,Object? stokvelName = null,Object? cycleId = null,Object? memberName = null,Object? amount = null,Object? status = null,Object? occurredAt = null,}) {
  return _then(_ActivityItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as String,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributionStatus,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
