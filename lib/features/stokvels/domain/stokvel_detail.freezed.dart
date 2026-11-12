// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stokvel_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StokvelDetail {

/// The stokvel (`GET /stokvels/{id}`).
 Stokvel get stokvel;/// The caller's membership: `id` and `role` from the same response.
 Membership get membership;/// The current cycle, `null` when there is none.
 StokvelCycle? get currentCycle;/// The current cycle's contributions, newest first.
 List<Contribution> get contributions;
/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StokvelDetailCopyWith<StokvelDetail> get copyWith => _$StokvelDetailCopyWithImpl<StokvelDetail>(this as StokvelDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StokvelDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StokvelDetail&&(identical(other.stokvel, _this.stokvel) || other.stokvel == _this.stokvel)&&(identical(other.membership, _this.membership) || other.membership == _this.membership)&&(identical(other.currentCycle, _this.currentCycle) || other.currentCycle == _this.currentCycle)&&const DeepCollectionEquality().equals(other.contributions, _this.contributions));
}


@override
int get hashCode {
  final _this = this as StokvelDetail;
  return Object.hash(runtimeType,_this.stokvel,_this.membership,_this.currentCycle,const DeepCollectionEquality().hash(_this.contributions));
}

@override
String toString() {
  final _this = this as StokvelDetail;
  return 'StokvelDetail(stokvel: ${_this.stokvel}, membership: ${_this.membership}, currentCycle: ${_this.currentCycle}, contributions: ${_this.contributions})';
}


}

/// @nodoc
abstract mixin class $StokvelDetailCopyWith<$Res>  {
  factory $StokvelDetailCopyWith(StokvelDetail value, $Res Function(StokvelDetail) _then) = _$StokvelDetailCopyWithImpl;
@useResult
$Res call({
 Stokvel stokvel, Membership membership, StokvelCycle? currentCycle, List<Contribution> contributions
});


$StokvelCopyWith<$Res> get stokvel;$MembershipCopyWith<$Res> get membership;$StokvelCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class _$StokvelDetailCopyWithImpl<$Res>
    implements $StokvelDetailCopyWith<$Res> {
  _$StokvelDetailCopyWithImpl(this._self, this._then);

  final StokvelDetail _self;
  final $Res Function(StokvelDetail) _then;

/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stokvel = null,Object? membership = null,Object? currentCycle = freezed,Object? contributions = null,}) {
  return _then(StokvelDetail(
stokvel: null == stokvel ? _self.stokvel : stokvel // ignore: cast_nullable_to_non_nullable
as Stokvel,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as StokvelCycle?,contributions: null == contributions ? _self.contributions : contributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,
  ));
}
/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCopyWith<$Res> get stokvel {
  
  return $StokvelCopyWith<$Res>(_self.stokvel, (value) {
    return _then(_self.copyWith(stokvel: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $StokvelCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [StokvelDetail].
extension StokvelDetailPatterns on StokvelDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StokvelDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StokvelDetail value)  $default,){
final _that = this;
switch (_that) {
case _StokvelDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StokvelDetail value)?  $default,){
final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Stokvel stokvel,  Membership membership,  StokvelCycle? currentCycle,  List<Contribution> contributions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
return $default(_that.stokvel,_that.membership,_that.currentCycle,_that.contributions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Stokvel stokvel,  Membership membership,  StokvelCycle? currentCycle,  List<Contribution> contributions)  $default,) {final _that = this;
switch (_that) {
case _StokvelDetail():
return $default(_that.stokvel,_that.membership,_that.currentCycle,_that.contributions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Stokvel stokvel,  Membership membership,  StokvelCycle? currentCycle,  List<Contribution> contributions)?  $default,) {final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
return $default(_that.stokvel,_that.membership,_that.currentCycle,_that.contributions);case _:
  return null;

}
}

}

/// @nodoc


class _StokvelDetail implements StokvelDetail {
  const _StokvelDetail({required this.stokvel, required this.membership, required this.currentCycle, required  List<Contribution> contributions}): _contributions = contributions;
  

/// The stokvel (`GET /stokvels/{id}`).
@override final  Stokvel stokvel;
/// The caller's membership: `id` and `role` from the same response.
@override final  Membership membership;
/// The current cycle, `null` when there is none.
@override final  StokvelCycle? currentCycle;
/// The current cycle's contributions, newest first.
 final  List<Contribution> _contributions;
/// The current cycle's contributions, newest first.
@override List<Contribution> get contributions {
  if (_contributions is EqualUnmodifiableListView) return _contributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contributions);
}


/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StokvelDetailCopyWith<_StokvelDetail> get copyWith => __$StokvelDetailCopyWithImpl<_StokvelDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StokvelDetail&&(identical(other.stokvel, stokvel) || other.stokvel == stokvel)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&const DeepCollectionEquality().equals(other.contributions, _contributions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stokvel,membership,currentCycle,const DeepCollectionEquality().hash(_contributions));
}

@override
String toString() {
    return 'StokvelDetail(stokvel: $stokvel, membership: $membership, currentCycle: $currentCycle, contributions: $contributions)';
}


}

/// @nodoc
abstract mixin class _$StokvelDetailCopyWith<$Res> implements $StokvelDetailCopyWith<$Res> {
  factory _$StokvelDetailCopyWith(_StokvelDetail value, $Res Function(_StokvelDetail) _then) = __$StokvelDetailCopyWithImpl;
@override @useResult
$Res call({
 Stokvel stokvel, Membership membership, StokvelCycle? currentCycle, List<Contribution> contributions
});


@override $StokvelCopyWith<$Res> get stokvel;@override $MembershipCopyWith<$Res> get membership;@override $StokvelCycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class __$StokvelDetailCopyWithImpl<$Res>
    implements _$StokvelDetailCopyWith<$Res> {
  __$StokvelDetailCopyWithImpl(this._self, this._then);

  final _StokvelDetail _self;
  final $Res Function(_StokvelDetail) _then;

/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stokvel = null,Object? membership = null,Object? currentCycle = freezed,Object? contributions = null,}) {
  return _then(_StokvelDetail(
stokvel: null == stokvel ? _self.stokvel : stokvel // ignore: cast_nullable_to_non_nullable
as Stokvel,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as StokvelCycle?,contributions: null == contributions ? _self._contributions : contributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,
  ));
}

/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCopyWith<$Res> get stokvel {
  
  return $StokvelCopyWith<$Res>(_self.stokvel, (value) {
    return _then(_self.copyWith(stokvel: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $StokvelCycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}

/// @nodoc
mixin _$CycleDetail {

/// The stokvel the cycle belongs to.
 Stokvel get stokvel;/// The cycle.
 StokvelCycle get cycle;/// The cycle's contributions, newest first.
 List<Contribution> get contributions;
/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleDetailCopyWith<CycleDetail> get copyWith => _$CycleDetailCopyWithImpl<CycleDetail>(this as CycleDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CycleDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CycleDetail&&(identical(other.stokvel, _this.stokvel) || other.stokvel == _this.stokvel)&&(identical(other.cycle, _this.cycle) || other.cycle == _this.cycle)&&const DeepCollectionEquality().equals(other.contributions, _this.contributions));
}


@override
int get hashCode {
  final _this = this as CycleDetail;
  return Object.hash(runtimeType,_this.stokvel,_this.cycle,const DeepCollectionEquality().hash(_this.contributions));
}

@override
String toString() {
  final _this = this as CycleDetail;
  return 'CycleDetail(stokvel: ${_this.stokvel}, cycle: ${_this.cycle}, contributions: ${_this.contributions})';
}


}

/// @nodoc
abstract mixin class $CycleDetailCopyWith<$Res>  {
  factory $CycleDetailCopyWith(CycleDetail value, $Res Function(CycleDetail) _then) = _$CycleDetailCopyWithImpl;
@useResult
$Res call({
 Stokvel stokvel, StokvelCycle cycle, List<Contribution> contributions
});


$StokvelCopyWith<$Res> get stokvel;$StokvelCycleCopyWith<$Res> get cycle;

}
/// @nodoc
class _$CycleDetailCopyWithImpl<$Res>
    implements $CycleDetailCopyWith<$Res> {
  _$CycleDetailCopyWithImpl(this._self, this._then);

  final CycleDetail _self;
  final $Res Function(CycleDetail) _then;

/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stokvel = null,Object? cycle = null,Object? contributions = null,}) {
  return _then(CycleDetail(
stokvel: null == stokvel ? _self.stokvel : stokvel // ignore: cast_nullable_to_non_nullable
as Stokvel,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as StokvelCycle,contributions: null == contributions ? _self.contributions : contributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,
  ));
}
/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCopyWith<$Res> get stokvel {
  
  return $StokvelCopyWith<$Res>(_self.stokvel, (value) {
    return _then(_self.copyWith(stokvel: value));
  });
}/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCycleCopyWith<$Res> get cycle {
  
  return $StokvelCycleCopyWith<$Res>(_self.cycle, (value) {
    return _then(_self.copyWith(cycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [CycleDetail].
extension CycleDetailPatterns on CycleDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CycleDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CycleDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CycleDetail value)  $default,){
final _that = this;
switch (_that) {
case _CycleDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CycleDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CycleDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Stokvel stokvel,  StokvelCycle cycle,  List<Contribution> contributions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CycleDetail() when $default != null:
return $default(_that.stokvel,_that.cycle,_that.contributions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Stokvel stokvel,  StokvelCycle cycle,  List<Contribution> contributions)  $default,) {final _that = this;
switch (_that) {
case _CycleDetail():
return $default(_that.stokvel,_that.cycle,_that.contributions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Stokvel stokvel,  StokvelCycle cycle,  List<Contribution> contributions)?  $default,) {final _that = this;
switch (_that) {
case _CycleDetail() when $default != null:
return $default(_that.stokvel,_that.cycle,_that.contributions);case _:
  return null;

}
}

}

/// @nodoc


class _CycleDetail implements CycleDetail {
  const _CycleDetail({required this.stokvel, required this.cycle, required  List<Contribution> contributions}): _contributions = contributions;
  

/// The stokvel the cycle belongs to.
@override final  Stokvel stokvel;
/// The cycle.
@override final  StokvelCycle cycle;
/// The cycle's contributions, newest first.
 final  List<Contribution> _contributions;
/// The cycle's contributions, newest first.
@override List<Contribution> get contributions {
  if (_contributions is EqualUnmodifiableListView) return _contributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contributions);
}


/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleDetailCopyWith<_CycleDetail> get copyWith => __$CycleDetailCopyWithImpl<_CycleDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CycleDetail&&(identical(other.stokvel, stokvel) || other.stokvel == stokvel)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&const DeepCollectionEquality().equals(other.contributions, _contributions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stokvel,cycle,const DeepCollectionEquality().hash(_contributions));
}

@override
String toString() {
    return 'CycleDetail(stokvel: $stokvel, cycle: $cycle, contributions: $contributions)';
}


}

/// @nodoc
abstract mixin class _$CycleDetailCopyWith<$Res> implements $CycleDetailCopyWith<$Res> {
  factory _$CycleDetailCopyWith(_CycleDetail value, $Res Function(_CycleDetail) _then) = __$CycleDetailCopyWithImpl;
@override @useResult
$Res call({
 Stokvel stokvel, StokvelCycle cycle, List<Contribution> contributions
});


@override $StokvelCopyWith<$Res> get stokvel;@override $StokvelCycleCopyWith<$Res> get cycle;

}
/// @nodoc
class __$CycleDetailCopyWithImpl<$Res>
    implements _$CycleDetailCopyWith<$Res> {
  __$CycleDetailCopyWithImpl(this._self, this._then);

  final _CycleDetail _self;
  final $Res Function(_CycleDetail) _then;

/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stokvel = null,Object? cycle = null,Object? contributions = null,}) {
  return _then(_CycleDetail(
stokvel: null == stokvel ? _self.stokvel : stokvel // ignore: cast_nullable_to_non_nullable
as Stokvel,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as StokvelCycle,contributions: null == contributions ? _self._contributions : contributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,
  ));
}

/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCopyWith<$Res> get stokvel {
  
  return $StokvelCopyWith<$Res>(_self.stokvel, (value) {
    return _then(_self.copyWith(stokvel: value));
  });
}/// Create a copy of CycleDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCycleCopyWith<$Res> get cycle {
  
  return $StokvelCycleCopyWith<$Res>(_self.cycle, (value) {
    return _then(_self.copyWith(cycle: value));
  });
}
}

/// @nodoc
mixin _$Stokvel {

/// `id`.
 String get id;/// `name`.
 String get name;/// `contributionAmountCents`. The API's `contributionAmount` is a
/// double and is never read.
 Cents get contributionAmount;/// `memberCount`.
 int get memberCount;
/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StokvelCopyWith<Stokvel> get copyWith => _$StokvelCopyWithImpl<Stokvel>(this as Stokvel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Stokvel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stokvel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.contributionAmount, _this.contributionAmount) || other.contributionAmount == _this.contributionAmount)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount));
}


@override
int get hashCode {
  final _this = this as Stokvel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.contributionAmount,_this.memberCount);
}

@override
String toString() {
  final _this = this as Stokvel;
  return 'Stokvel(id: ${_this.id}, name: ${_this.name}, contributionAmount: ${_this.contributionAmount}, memberCount: ${_this.memberCount})';
}


}

/// @nodoc
abstract mixin class $StokvelCopyWith<$Res>  {
  factory $StokvelCopyWith(Stokvel value, $Res Function(Stokvel) _then) = _$StokvelCopyWithImpl;
@useResult
$Res call({
 String id, String name, Cents contributionAmount, int memberCount
});




}
/// @nodoc
class _$StokvelCopyWithImpl<$Res>
    implements $StokvelCopyWith<$Res> {
  _$StokvelCopyWithImpl(this._self, this._then);

  final Stokvel _self;
  final $Res Function(Stokvel) _then;

/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contributionAmount = null,Object? memberCount = null,}) {
  return _then(Stokvel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as Cents,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Stokvel].
extension StokvelPatterns on Stokvel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stokvel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stokvel value)  $default,){
final _that = this;
switch (_that) {
case _Stokvel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stokvel value)?  $default,){
final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Cents contributionAmount,  int memberCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
return $default(_that.id,_that.name,_that.contributionAmount,_that.memberCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Cents contributionAmount,  int memberCount)  $default,) {final _that = this;
switch (_that) {
case _Stokvel():
return $default(_that.id,_that.name,_that.contributionAmount,_that.memberCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Cents contributionAmount,  int memberCount)?  $default,) {final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
return $default(_that.id,_that.name,_that.contributionAmount,_that.memberCount);case _:
  return null;

}
}

}

/// @nodoc


class _Stokvel implements Stokvel {
  const _Stokvel({required this.id, required this.name, required this.contributionAmount, required this.memberCount});
  

/// `id`.
@override final  String id;
/// `name`.
@override final  String name;
/// `contributionAmountCents`. The API's `contributionAmount` is a
/// double and is never read.
@override final  Cents contributionAmount;
/// `memberCount`.
@override final  int memberCount;

/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StokvelCopyWith<_Stokvel> get copyWith => __$StokvelCopyWithImpl<_Stokvel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stokvel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contributionAmount, contributionAmount) || other.contributionAmount == contributionAmount)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,contributionAmount,memberCount);
}

@override
String toString() {
    return 'Stokvel(id: $id, name: $name, contributionAmount: $contributionAmount, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class _$StokvelCopyWith<$Res> implements $StokvelCopyWith<$Res> {
  factory _$StokvelCopyWith(_Stokvel value, $Res Function(_Stokvel) _then) = __$StokvelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Cents contributionAmount, int memberCount
});




}
/// @nodoc
class __$StokvelCopyWithImpl<$Res>
    implements _$StokvelCopyWith<$Res> {
  __$StokvelCopyWithImpl(this._self, this._then);

  final _Stokvel _self;
  final $Res Function(_Stokvel) _then;

/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contributionAmount = null,Object? memberCount = null,}) {
  return _then(_Stokvel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as Cents,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StokvelCycle {

/// `id`, from `GET /stokvels/{id}/cycles`. The detail response's
/// `currentCycle` has no id; see README "Contract notes".
 String get id;/// `period`, such as `2026-11`.
 String get period;/// `status`.
 CycleStatus get status;/// `dueDate`, date-only, `null` when the cycle has no end date.
 CalendarDate? get dueDate;/// `membersPaid`.
 int get membersPaid;/// `collectedCents`.
 Cents get collected;/// `targetCents`.
 Cents get target;
/// Create a copy of StokvelCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StokvelCycleCopyWith<StokvelCycle> get copyWith => _$StokvelCycleCopyWithImpl<StokvelCycle>(this as StokvelCycle, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StokvelCycle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StokvelCycle&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.membersPaid, _this.membersPaid) || other.membersPaid == _this.membersPaid)&&(identical(other.collected, _this.collected) || other.collected == _this.collected)&&(identical(other.target, _this.target) || other.target == _this.target));
}


@override
int get hashCode {
  final _this = this as StokvelCycle;
  return Object.hash(runtimeType,_this.id,_this.period,_this.status,_this.dueDate,_this.membersPaid,_this.collected,_this.target);
}

@override
String toString() {
  final _this = this as StokvelCycle;
  return 'StokvelCycle(id: ${_this.id}, period: ${_this.period}, status: ${_this.status}, dueDate: ${_this.dueDate}, membersPaid: ${_this.membersPaid}, collected: ${_this.collected}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $StokvelCycleCopyWith<$Res>  {
  factory $StokvelCycleCopyWith(StokvelCycle value, $Res Function(StokvelCycle) _then) = _$StokvelCycleCopyWithImpl;
@useResult
$Res call({
 String id, String period, CycleStatus status, CalendarDate? dueDate, int membersPaid, Cents collected, Cents target
});




}
/// @nodoc
class _$StokvelCycleCopyWithImpl<$Res>
    implements $StokvelCycleCopyWith<$Res> {
  _$StokvelCycleCopyWithImpl(this._self, this._then);

  final StokvelCycle _self;
  final $Res Function(StokvelCycle) _then;

/// Create a copy of StokvelCycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? period = null,Object? status = null,Object? dueDate = freezed,Object? membersPaid = null,Object? collected = null,Object? target = null,}) {
  return _then(StokvelCycle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CycleStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,membersPaid: null == membersPaid ? _self.membersPaid : membersPaid // ignore: cast_nullable_to_non_nullable
as int,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as Cents,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}

}


/// Adds pattern-matching-related methods to [StokvelCycle].
extension StokvelCyclePatterns on StokvelCycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StokvelCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StokvelCycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StokvelCycle value)  $default,){
final _that = this;
switch (_that) {
case _StokvelCycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StokvelCycle value)?  $default,){
final _that = this;
switch (_that) {
case _StokvelCycle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String period,  CycleStatus status,  CalendarDate? dueDate,  int membersPaid,  Cents collected,  Cents target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StokvelCycle() when $default != null:
return $default(_that.id,_that.period,_that.status,_that.dueDate,_that.membersPaid,_that.collected,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String period,  CycleStatus status,  CalendarDate? dueDate,  int membersPaid,  Cents collected,  Cents target)  $default,) {final _that = this;
switch (_that) {
case _StokvelCycle():
return $default(_that.id,_that.period,_that.status,_that.dueDate,_that.membersPaid,_that.collected,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String period,  CycleStatus status,  CalendarDate? dueDate,  int membersPaid,  Cents collected,  Cents target)?  $default,) {final _that = this;
switch (_that) {
case _StokvelCycle() when $default != null:
return $default(_that.id,_that.period,_that.status,_that.dueDate,_that.membersPaid,_that.collected,_that.target);case _:
  return null;

}
}

}

/// @nodoc


class _StokvelCycle implements StokvelCycle {
  const _StokvelCycle({required this.id, required this.period, required this.status, required this.dueDate, required this.membersPaid, required this.collected, required this.target});
  

/// `id`, from `GET /stokvels/{id}/cycles`. The detail response's
/// `currentCycle` has no id; see README "Contract notes".
@override final  String id;
/// `period`, such as `2026-11`.
@override final  String period;
/// `status`.
@override final  CycleStatus status;
/// `dueDate`, date-only, `null` when the cycle has no end date.
@override final  CalendarDate? dueDate;
/// `membersPaid`.
@override final  int membersPaid;
/// `collectedCents`.
@override final  Cents collected;
/// `targetCents`.
@override final  Cents target;

/// Create a copy of StokvelCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StokvelCycleCopyWith<_StokvelCycle> get copyWith => __$StokvelCycleCopyWithImpl<_StokvelCycle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StokvelCycle&&(identical(other.id, id) || other.id == id)&&(identical(other.period, period) || other.period == period)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.membersPaid, membersPaid) || other.membersPaid == membersPaid)&&(identical(other.collected, collected) || other.collected == collected)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,period,status,dueDate,membersPaid,collected,target);
}

@override
String toString() {
    return 'StokvelCycle(id: $id, period: $period, status: $status, dueDate: $dueDate, membersPaid: $membersPaid, collected: $collected, target: $target)';
}


}

/// @nodoc
abstract mixin class _$StokvelCycleCopyWith<$Res> implements $StokvelCycleCopyWith<$Res> {
  factory _$StokvelCycleCopyWith(_StokvelCycle value, $Res Function(_StokvelCycle) _then) = __$StokvelCycleCopyWithImpl;
@override @useResult
$Res call({
 String id, String period, CycleStatus status, CalendarDate? dueDate, int membersPaid, Cents collected, Cents target
});




}
/// @nodoc
class __$StokvelCycleCopyWithImpl<$Res>
    implements _$StokvelCycleCopyWith<$Res> {
  __$StokvelCycleCopyWithImpl(this._self, this._then);

  final _StokvelCycle _self;
  final $Res Function(_StokvelCycle) _then;

/// Create a copy of StokvelCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? period = null,Object? status = null,Object? dueDate = freezed,Object? membersPaid = null,Object? collected = null,Object? target = null,}) {
  return _then(_StokvelCycle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CycleStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,membersPaid: null == membersPaid ? _self.membersPaid : membersPaid // ignore: cast_nullable_to_non_nullable
as int,collected: null == collected ? _self.collected : collected // ignore: cast_nullable_to_non_nullable
as Cents,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}


}

/// @nodoc
mixin _$Contribution {

/// `id`.
 String get id;/// `userId`.
 String get userId;/// `userName`.
 String get memberName;/// `memberRole`.
 StokvelRole get memberRole;/// `amount`, in cents.
 Cents get amount;/// `status`.
 ContributionStatus get status;/// `recordedAtUtc`, an instant.
 DateTime get recordedAt;
/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContributionCopyWith<Contribution> get copyWith => _$ContributionCopyWithImpl<Contribution>(this as Contribution, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Contribution;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contribution&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.memberRole, _this.memberRole) || other.memberRole == _this.memberRole)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.recordedAt, _this.recordedAt) || other.recordedAt == _this.recordedAt));
}


@override
int get hashCode {
  final _this = this as Contribution;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.memberName,_this.memberRole,_this.amount,_this.status,_this.recordedAt);
}

@override
String toString() {
  final _this = this as Contribution;
  return 'Contribution(id: ${_this.id}, userId: ${_this.userId}, memberName: ${_this.memberName}, memberRole: ${_this.memberRole}, amount: ${_this.amount}, status: ${_this.status}, recordedAt: ${_this.recordedAt})';
}


}

/// @nodoc
abstract mixin class $ContributionCopyWith<$Res>  {
  factory $ContributionCopyWith(Contribution value, $Res Function(Contribution) _then) = _$ContributionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String memberName, StokvelRole memberRole, Cents amount, ContributionStatus status, DateTime recordedAt
});




}
/// @nodoc
class _$ContributionCopyWithImpl<$Res>
    implements $ContributionCopyWith<$Res> {
  _$ContributionCopyWithImpl(this._self, this._then);

  final Contribution _self;
  final $Res Function(Contribution) _then;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? memberName = null,Object? memberRole = null,Object? amount = null,Object? status = null,Object? recordedAt = null,}) {
  return _then(Contribution(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberRole: null == memberRole ? _self.memberRole : memberRole // ignore: cast_nullable_to_non_nullable
as StokvelRole,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributionStatus,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Contribution].
extension ContributionPatterns on Contribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contribution value)  $default,){
final _that = this;
switch (_that) {
case _Contribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contribution value)?  $default,){
final _that = this;
switch (_that) {
case _Contribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String memberName,  StokvelRole memberRole,  Cents amount,  ContributionStatus status,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contribution() when $default != null:
return $default(_that.id,_that.userId,_that.memberName,_that.memberRole,_that.amount,_that.status,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String memberName,  StokvelRole memberRole,  Cents amount,  ContributionStatus status,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _Contribution():
return $default(_that.id,_that.userId,_that.memberName,_that.memberRole,_that.amount,_that.status,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String memberName,  StokvelRole memberRole,  Cents amount,  ContributionStatus status,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _Contribution() when $default != null:
return $default(_that.id,_that.userId,_that.memberName,_that.memberRole,_that.amount,_that.status,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Contribution implements Contribution {
  const _Contribution({required this.id, required this.userId, required this.memberName, required this.memberRole, required this.amount, required this.status, required this.recordedAt});
  

/// `id`.
@override final  String id;
/// `userId`.
@override final  String userId;
/// `userName`.
@override final  String memberName;
/// `memberRole`.
@override final  StokvelRole memberRole;
/// `amount`, in cents.
@override final  Cents amount;
/// `status`.
@override final  ContributionStatus status;
/// `recordedAtUtc`, an instant.
@override final  DateTime recordedAt;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContributionCopyWith<_Contribution> get copyWith => __$ContributionCopyWithImpl<_Contribution>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contribution&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.memberRole, memberRole) || other.memberRole == memberRole)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,memberName,memberRole,amount,status,recordedAt);
}

@override
String toString() {
    return 'Contribution(id: $id, userId: $userId, memberName: $memberName, memberRole: $memberRole, amount: $amount, status: $status, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$ContributionCopyWith<$Res> implements $ContributionCopyWith<$Res> {
  factory _$ContributionCopyWith(_Contribution value, $Res Function(_Contribution) _then) = __$ContributionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String memberName, StokvelRole memberRole, Cents amount, ContributionStatus status, DateTime recordedAt
});




}
/// @nodoc
class __$ContributionCopyWithImpl<$Res>
    implements _$ContributionCopyWith<$Res> {
  __$ContributionCopyWithImpl(this._self, this._then);

  final _Contribution _self;
  final $Res Function(_Contribution) _then;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? memberName = null,Object? memberRole = null,Object? amount = null,Object? status = null,Object? recordedAt = null,}) {
  return _then(_Contribution(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,memberRole: null == memberRole ? _self.memberRole : memberRole // ignore: cast_nullable_to_non_nullable
as StokvelRole,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributionStatus,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
