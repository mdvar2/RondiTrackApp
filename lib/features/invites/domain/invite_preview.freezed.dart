// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvitePreview {

/// The code in the link.
 String get code;/// `stokvelId`.
 String get stokvelId;/// `name`.
 String get stokvelName;/// `contributionAmountCents`.
 Cents get contributionAmount;/// `schedule`, in words.
 String get schedule;/// `rules`, in words.
 String get rules;/// `memberCount`.
 int get memberCount;
/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitePreviewCopyWith<InvitePreview> get copyWith => _$InvitePreviewCopyWithImpl<InvitePreview>(this as InvitePreview, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InvitePreview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitePreview&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.stokvelId, _this.stokvelId) || other.stokvelId == _this.stokvelId)&&(identical(other.stokvelName, _this.stokvelName) || other.stokvelName == _this.stokvelName)&&(identical(other.contributionAmount, _this.contributionAmount) || other.contributionAmount == _this.contributionAmount)&&(identical(other.schedule, _this.schedule) || other.schedule == _this.schedule)&&(identical(other.rules, _this.rules) || other.rules == _this.rules)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount));
}


@override
int get hashCode {
  final _this = this as InvitePreview;
  return Object.hash(runtimeType,_this.code,_this.stokvelId,_this.stokvelName,_this.contributionAmount,_this.schedule,_this.rules,_this.memberCount);
}

@override
String toString() {
  final _this = this as InvitePreview;
  return 'InvitePreview(code: ${_this.code}, stokvelId: ${_this.stokvelId}, stokvelName: ${_this.stokvelName}, contributionAmount: ${_this.contributionAmount}, schedule: ${_this.schedule}, rules: ${_this.rules}, memberCount: ${_this.memberCount})';
}


}

/// @nodoc
abstract mixin class $InvitePreviewCopyWith<$Res>  {
  factory $InvitePreviewCopyWith(InvitePreview value, $Res Function(InvitePreview) _then) = _$InvitePreviewCopyWithImpl;
@useResult
$Res call({
 String code, String stokvelId, String stokvelName, Cents contributionAmount, String schedule, String rules, int memberCount
});




}
/// @nodoc
class _$InvitePreviewCopyWithImpl<$Res>
    implements $InvitePreviewCopyWith<$Res> {
  _$InvitePreviewCopyWithImpl(this._self, this._then);

  final InvitePreview _self;
  final $Res Function(InvitePreview) _then;

/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? stokvelId = null,Object? stokvelName = null,Object? contributionAmount = null,Object? schedule = null,Object? rules = null,Object? memberCount = null,}) {
  return _then(InvitePreview(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as String,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as Cents,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitePreview].
extension InvitePreviewPatterns on InvitePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitePreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitePreview value)  $default,){
final _that = this;
switch (_that) {
case _InvitePreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitePreview value)?  $default,){
final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String stokvelId,  String stokvelName,  Cents contributionAmount,  String schedule,  String rules,  int memberCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
return $default(_that.code,_that.stokvelId,_that.stokvelName,_that.contributionAmount,_that.schedule,_that.rules,_that.memberCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String stokvelId,  String stokvelName,  Cents contributionAmount,  String schedule,  String rules,  int memberCount)  $default,) {final _that = this;
switch (_that) {
case _InvitePreview():
return $default(_that.code,_that.stokvelId,_that.stokvelName,_that.contributionAmount,_that.schedule,_that.rules,_that.memberCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String stokvelId,  String stokvelName,  Cents contributionAmount,  String schedule,  String rules,  int memberCount)?  $default,) {final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
return $default(_that.code,_that.stokvelId,_that.stokvelName,_that.contributionAmount,_that.schedule,_that.rules,_that.memberCount);case _:
  return null;

}
}

}

/// @nodoc


class _InvitePreview implements InvitePreview {
  const _InvitePreview({required this.code, required this.stokvelId, required this.stokvelName, required this.contributionAmount, required this.schedule, required this.rules, required this.memberCount});
  

/// The code in the link.
@override final  String code;
/// `stokvelId`.
@override final  String stokvelId;
/// `name`.
@override final  String stokvelName;
/// `contributionAmountCents`.
@override final  Cents contributionAmount;
/// `schedule`, in words.
@override final  String schedule;
/// `rules`, in words.
@override final  String rules;
/// `memberCount`.
@override final  int memberCount;

/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitePreviewCopyWith<_InvitePreview> get copyWith => __$InvitePreviewCopyWithImpl<_InvitePreview>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitePreview&&(identical(other.code, code) || other.code == code)&&(identical(other.stokvelId, stokvelId) || other.stokvelId == stokvelId)&&(identical(other.stokvelName, stokvelName) || other.stokvelName == stokvelName)&&(identical(other.contributionAmount, contributionAmount) || other.contributionAmount == contributionAmount)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.rules, rules) || other.rules == rules)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,stokvelId,stokvelName,contributionAmount,schedule,rules,memberCount);
}

@override
String toString() {
    return 'InvitePreview(code: $code, stokvelId: $stokvelId, stokvelName: $stokvelName, contributionAmount: $contributionAmount, schedule: $schedule, rules: $rules, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class _$InvitePreviewCopyWith<$Res> implements $InvitePreviewCopyWith<$Res> {
  factory _$InvitePreviewCopyWith(_InvitePreview value, $Res Function(_InvitePreview) _then) = __$InvitePreviewCopyWithImpl;
@override @useResult
$Res call({
 String code, String stokvelId, String stokvelName, Cents contributionAmount, String schedule, String rules, int memberCount
});




}
/// @nodoc
class __$InvitePreviewCopyWithImpl<$Res>
    implements _$InvitePreviewCopyWith<$Res> {
  __$InvitePreviewCopyWithImpl(this._self, this._then);

  final _InvitePreview _self;
  final $Res Function(_InvitePreview) _then;

/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? stokvelId = null,Object? stokvelName = null,Object? contributionAmount = null,Object? schedule = null,Object? rules = null,Object? memberCount = null,}) {
  return _then(_InvitePreview(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as String,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as Cents,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
