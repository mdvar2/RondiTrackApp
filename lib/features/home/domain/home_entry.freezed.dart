// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEntry {

/// `stokvelId` and `role`.
 Membership get membership;/// `stokvelName`.
 String get stokvelName;/// `currentCycle`, `null` when the stokvel has no cycle this month.
 HomeCycle? get currentCycle;/// `amountPaid`: what this person has paid in the current cycle.
 Cents get amountPaid;/// `amountOwed`: what this person still owes in the current cycle.
 Cents get amountOwed;/// `arrearsCents`: this person's recorded arrears in the stokvel.
 Cents get arrears;/// `nextPayoutDate`, an instant. The API always sends `null` today.
 DateTime? get nextPayoutDate;
/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeEntryCopyWith<HomeEntry> get copyWith => _$HomeEntryCopyWithImpl<HomeEntry>(this as HomeEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEntry&&(identical(other.membership, _this.membership) || other.membership == _this.membership)&&(identical(other.stokvelName, _this.stokvelName) || other.stokvelName == _this.stokvelName)&&(identical(other.currentCycle, _this.currentCycle) || other.currentCycle == _this.currentCycle)&&(identical(other.amountPaid, _this.amountPaid) || other.amountPaid == _this.amountPaid)&&(identical(other.amountOwed, _this.amountOwed) || other.amountOwed == _this.amountOwed)&&(identical(other.arrears, _this.arrears) || other.arrears == _this.arrears)&&(identical(other.nextPayoutDate, _this.nextPayoutDate) || other.nextPayoutDate == _this.nextPayoutDate));
}


@override
int get hashCode {
  final _this = this as HomeEntry;
  return Object.hash(runtimeType,_this.membership,_this.stokvelName,_this.currentCycle,_this.amountPaid,_this.amountOwed,_this.arrears,_this.nextPayoutDate);
}

@override
String toString() {
  final _this = this as HomeEntry;
  return 'HomeEntry(membership: ${_this.membership}, stokvelName: ${_this.stokvelName}, currentCycle: ${_this.currentCycle}, amountPaid: ${_this.amountPaid}, amountOwed: ${_this.amountOwed}, arrears: ${_this.arrears}, nextPayoutDate: ${_this.nextPayoutDate})';
}


}

/// @nodoc
abstract mixin class $HomeEntryCopyWith<$Res>  {
  factory $HomeEntryCopyWith(HomeEntry value, $Res Function(HomeEntry) _then) = _$HomeEntryCopyWithImpl;
@useResult
$Res call({
 Membership membership, String stokvelName, HomeCycle? currentCycle, Cents amountPaid, Cents amountOwed, Cents arrears, DateTime? nextPayoutDate
});


$MembershipCopyWith<$Res> get membership;$HomeCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class _$HomeEntryCopyWithImpl<$Res>
    implements $HomeEntryCopyWith<$Res> {
  _$HomeEntryCopyWithImpl(this._self, this._then);

  final HomeEntry _self;
  final $Res Function(HomeEntry) _then;

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membership = null,Object? stokvelName = null,Object? currentCycle = freezed,Object? amountPaid = null,Object? amountOwed = null,Object? arrears = null,Object? nextPayoutDate = freezed,}) {
  return _then(HomeEntry(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as HomeCycle?,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as Cents,amountOwed: null == amountOwed ? _self.amountOwed : amountOwed // ignore: cast_nullable_to_non_nullable
as Cents,arrears: null == arrears ? _self.arrears : arrears // ignore: cast_nullable_to_non_nullable
as Cents,nextPayoutDate: freezed == nextPayoutDate ? _self.nextPayoutDate : nextPayoutDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $HomeCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeEntry].
extension HomeEntryPatterns on HomeEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeEntry value)  $default,){
final _that = this;
switch (_that) {
case _HomeEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Membership membership,  String stokvelName,  HomeCycle? currentCycle,  Cents amountPaid,  Cents amountOwed,  Cents arrears,  DateTime? nextPayoutDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
return $default(_that.membership,_that.stokvelName,_that.currentCycle,_that.amountPaid,_that.amountOwed,_that.arrears,_that.nextPayoutDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Membership membership,  String stokvelName,  HomeCycle? currentCycle,  Cents amountPaid,  Cents amountOwed,  Cents arrears,  DateTime? nextPayoutDate)  $default,) {final _that = this;
switch (_that) {
case _HomeEntry():
return $default(_that.membership,_that.stokvelName,_that.currentCycle,_that.amountPaid,_that.amountOwed,_that.arrears,_that.nextPayoutDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Membership membership,  String stokvelName,  HomeCycle? currentCycle,  Cents amountPaid,  Cents amountOwed,  Cents arrears,  DateTime? nextPayoutDate)?  $default,) {final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
return $default(_that.membership,_that.stokvelName,_that.currentCycle,_that.amountPaid,_that.amountOwed,_that.arrears,_that.nextPayoutDate);case _:
  return null;

}
}

}

/// @nodoc


class _HomeEntry extends HomeEntry {
  const _HomeEntry({required this.membership, required this.stokvelName, required this.currentCycle, required this.amountPaid, required this.amountOwed, required this.arrears, required this.nextPayoutDate}): super._();
  

/// `stokvelId` and `role`.
@override final  Membership membership;
/// `stokvelName`.
@override final  String stokvelName;
/// `currentCycle`, `null` when the stokvel has no cycle this month.
@override final  HomeCycle? currentCycle;
/// `amountPaid`: what this person has paid in the current cycle.
@override final  Cents amountPaid;
/// `amountOwed`: what this person still owes in the current cycle.
@override final  Cents amountOwed;
/// `arrearsCents`: this person's recorded arrears in the stokvel.
@override final  Cents arrears;
/// `nextPayoutDate`, an instant. The API always sends `null` today.
@override final  DateTime? nextPayoutDate;

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeEntryCopyWith<_HomeEntry> get copyWith => __$HomeEntryCopyWithImpl<_HomeEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeEntry&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.stokvelName, stokvelName) || other.stokvelName == stokvelName)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.amountOwed, amountOwed) || other.amountOwed == amountOwed)&&(identical(other.arrears, arrears) || other.arrears == arrears)&&(identical(other.nextPayoutDate, nextPayoutDate) || other.nextPayoutDate == nextPayoutDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,membership,stokvelName,currentCycle,amountPaid,amountOwed,arrears,nextPayoutDate);
}

@override
String toString() {
    return 'HomeEntry(membership: $membership, stokvelName: $stokvelName, currentCycle: $currentCycle, amountPaid: $amountPaid, amountOwed: $amountOwed, arrears: $arrears, nextPayoutDate: $nextPayoutDate)';
}


}

/// @nodoc
abstract mixin class _$HomeEntryCopyWith<$Res> implements $HomeEntryCopyWith<$Res> {
  factory _$HomeEntryCopyWith(_HomeEntry value, $Res Function(_HomeEntry) _then) = __$HomeEntryCopyWithImpl;
@override @useResult
$Res call({
 Membership membership, String stokvelName, HomeCycle? currentCycle, Cents amountPaid, Cents amountOwed, Cents arrears, DateTime? nextPayoutDate
});


@override $MembershipCopyWith<$Res> get membership;@override $HomeCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class __$HomeEntryCopyWithImpl<$Res>
    implements _$HomeEntryCopyWith<$Res> {
  __$HomeEntryCopyWithImpl(this._self, this._then);

  final _HomeEntry _self;
  final $Res Function(_HomeEntry) _then;

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membership = null,Object? stokvelName = null,Object? currentCycle = freezed,Object? amountPaid = null,Object? amountOwed = null,Object? arrears = null,Object? nextPayoutDate = freezed,}) {
  return _then(_HomeEntry(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as HomeCycle?,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as Cents,amountOwed: null == amountOwed ? _self.amountOwed : amountOwed // ignore: cast_nullable_to_non_nullable
as Cents,arrears: null == arrears ? _self.arrears : arrears // ignore: cast_nullable_to_non_nullable
as Cents,nextPayoutDate: freezed == nextPayoutDate ? _self.nextPayoutDate : nextPayoutDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $HomeCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}

/// @nodoc
mixin _$HomeCycle {

/// `period`, such as `2026-11`.
 String get period;/// `status`.
 CycleStatus get status;/// `dueDate`, a date-only value, `null` when the cycle has no end date.
 CalendarDate? get dueDate;
/// Create a copy of HomeCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeCycleCopyWith<HomeCycle> get copyWith => _$HomeCycleCopyWithImpl<HomeCycle>(this as HomeCycle, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeCycle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeCycle&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate));
}


@override
int get hashCode {
  final _this = this as HomeCycle;
  return Object.hash(runtimeType,_this.period,_this.status,_this.dueDate);
}

@override
String toString() {
  final _this = this as HomeCycle;
  return 'HomeCycle(period: ${_this.period}, status: ${_this.status}, dueDate: ${_this.dueDate})';
}


}

/// @nodoc
abstract mixin class $HomeCycleCopyWith<$Res>  {
  factory $HomeCycleCopyWith(HomeCycle value, $Res Function(HomeCycle) _then) = _$HomeCycleCopyWithImpl;
@useResult
$Res call({
 String period, CycleStatus status, CalendarDate? dueDate
});




}
/// @nodoc
class _$HomeCycleCopyWithImpl<$Res>
    implements $HomeCycleCopyWith<$Res> {
  _$HomeCycleCopyWithImpl(this._self, this._then);

  final HomeCycle _self;
  final $Res Function(HomeCycle) _then;

/// Create a copy of HomeCycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? status = null,Object? dueDate = freezed,}) {
  return _then(HomeCycle(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CycleStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeCycle].
extension HomeCyclePatterns on HomeCycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeCycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeCycle value)  $default,){
final _that = this;
switch (_that) {
case _HomeCycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeCycle value)?  $default,){
final _that = this;
switch (_that) {
case _HomeCycle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  CycleStatus status,  CalendarDate? dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeCycle() when $default != null:
return $default(_that.period,_that.status,_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  CycleStatus status,  CalendarDate? dueDate)  $default,) {final _that = this;
switch (_that) {
case _HomeCycle():
return $default(_that.period,_that.status,_that.dueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  CycleStatus status,  CalendarDate? dueDate)?  $default,) {final _that = this;
switch (_that) {
case _HomeCycle() when $default != null:
return $default(_that.period,_that.status,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc


class _HomeCycle implements HomeCycle {
  const _HomeCycle({required this.period, required this.status, required this.dueDate});
  

/// `period`, such as `2026-11`.
@override final  String period;
/// `status`.
@override final  CycleStatus status;
/// `dueDate`, a date-only value, `null` when the cycle has no end date.
@override final  CalendarDate? dueDate;

/// Create a copy of HomeCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeCycleCopyWith<_HomeCycle> get copyWith => __$HomeCycleCopyWithImpl<_HomeCycle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeCycle&&(identical(other.period, period) || other.period == period)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,period,status,dueDate);
}

@override
String toString() {
    return 'HomeCycle(period: $period, status: $status, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$HomeCycleCopyWith<$Res> implements $HomeCycleCopyWith<$Res> {
  factory _$HomeCycleCopyWith(_HomeCycle value, $Res Function(_HomeCycle) _then) = __$HomeCycleCopyWithImpl;
@override @useResult
$Res call({
 String period, CycleStatus status, CalendarDate? dueDate
});




}
/// @nodoc
class __$HomeCycleCopyWithImpl<$Res>
    implements _$HomeCycleCopyWith<$Res> {
  __$HomeCycleCopyWithImpl(this._self, this._then);

  final _HomeCycle _self;
  final $Res Function(_HomeCycle) _then;

/// Create a copy of HomeCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? status = null,Object? dueDate = freezed,}) {
  return _then(_HomeCycle(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CycleStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,
  ));
}


}

// dart format on
