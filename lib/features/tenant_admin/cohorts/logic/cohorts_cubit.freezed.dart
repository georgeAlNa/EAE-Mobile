// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cohorts_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CohortsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CohortsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CohortsState()';
}


}

/// @nodoc
class $CohortsStateCopyWith<$Res>  {
$CohortsStateCopyWith(CohortsState _, $Res Function(CohortsState) __);
}


/// Adds pattern-matching-related methods to [CohortsState].
extension CohortsStatePatterns on CohortsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _DetailsLoaded value)?  detailsLoaded,TResult Function( _MembersLoaded value)?  membersLoaded,TResult Function( _SaveSuccess value)?  saveSuccess,TResult Function( _MemberSaveSuccess value)?  memberSaveSuccess,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that);case _MembersLoaded() when membersLoaded != null:
return membersLoaded(_that);case _SaveSuccess() when saveSuccess != null:
return saveSuccess(_that);case _MemberSaveSuccess() when memberSaveSuccess != null:
return memberSaveSuccess(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _DetailsLoaded value)  detailsLoaded,required TResult Function( _MembersLoaded value)  membersLoaded,required TResult Function( _SaveSuccess value)  saveSuccess,required TResult Function( _MemberSaveSuccess value)  memberSaveSuccess,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _DetailsLoaded():
return detailsLoaded(_that);case _MembersLoaded():
return membersLoaded(_that);case _SaveSuccess():
return saveSuccess(_that);case _MemberSaveSuccess():
return memberSaveSuccess(_that);case _ActionSuccess():
return actionSuccess(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _DetailsLoaded value)?  detailsLoaded,TResult? Function( _MembersLoaded value)?  membersLoaded,TResult? Function( _SaveSuccess value)?  saveSuccess,TResult? Function( _MemberSaveSuccess value)?  memberSaveSuccess,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that);case _MembersLoaded() when membersLoaded != null:
return membersLoaded(_that);case _SaveSuccess() when saveSuccess != null:
return saveSuccess(_that);case _MemberSaveSuccess() when memberSaveSuccess != null:
return memberSaveSuccess(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( CohortsResponse response)?  loaded,TResult Function( CohortDetailsResponse response)?  detailsLoaded,TResult Function( CohortMembersResponse response)?  membersLoaded,TResult Function( CohortDetailsResponse response)?  saveSuccess,TResult Function( CohortMemberResponse response)?  memberSaveSuccess,TResult Function( CohortActionResponse response)?  actionSuccess,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.response);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that.response);case _MembersLoaded() when membersLoaded != null:
return membersLoaded(_that.response);case _SaveSuccess() when saveSuccess != null:
return saveSuccess(_that.response);case _MemberSaveSuccess() when memberSaveSuccess != null:
return memberSaveSuccess(_that.response);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.response);case _Error() when error != null:
return error(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( CohortsResponse response)  loaded,required TResult Function( CohortDetailsResponse response)  detailsLoaded,required TResult Function( CohortMembersResponse response)  membersLoaded,required TResult Function( CohortDetailsResponse response)  saveSuccess,required TResult Function( CohortMemberResponse response)  memberSaveSuccess,required TResult Function( CohortActionResponse response)  actionSuccess,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.response);case _DetailsLoaded():
return detailsLoaded(_that.response);case _MembersLoaded():
return membersLoaded(_that.response);case _SaveSuccess():
return saveSuccess(_that.response);case _MemberSaveSuccess():
return memberSaveSuccess(_that.response);case _ActionSuccess():
return actionSuccess(_that.response);case _Error():
return error(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( CohortsResponse response)?  loaded,TResult? Function( CohortDetailsResponse response)?  detailsLoaded,TResult? Function( CohortMembersResponse response)?  membersLoaded,TResult? Function( CohortDetailsResponse response)?  saveSuccess,TResult? Function( CohortMemberResponse response)?  memberSaveSuccess,TResult? Function( CohortActionResponse response)?  actionSuccess,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.response);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that.response);case _MembersLoaded() when membersLoaded != null:
return membersLoaded(_that.response);case _SaveSuccess() when saveSuccess != null:
return saveSuccess(_that.response);case _MemberSaveSuccess() when memberSaveSuccess != null:
return memberSaveSuccess(_that.response);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.response);case _Error() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CohortsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CohortsState.initial()';
}


}




/// @nodoc


class _Loading implements CohortsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CohortsState.loading()';
}


}




/// @nodoc


class _Loaded implements CohortsState {
  const _Loaded(this.response);
  

 final  CohortsResponse response;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'CohortsState.loaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $CohortsStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 CohortsResponse response
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_Loaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CohortsResponse,
  ));
}


}

/// @nodoc


class _DetailsLoaded implements CohortsState {
  const _DetailsLoaded(this.response);
  

 final  CohortDetailsResponse response;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailsLoadedCopyWith<_DetailsLoaded> get copyWith => __$DetailsLoadedCopyWithImpl<_DetailsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailsLoaded&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'CohortsState.detailsLoaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$DetailsLoadedCopyWith<$Res> implements $CohortsStateCopyWith<$Res> {
  factory _$DetailsLoadedCopyWith(_DetailsLoaded value, $Res Function(_DetailsLoaded) _then) = __$DetailsLoadedCopyWithImpl;
@useResult
$Res call({
 CohortDetailsResponse response
});




}
/// @nodoc
class __$DetailsLoadedCopyWithImpl<$Res>
    implements _$DetailsLoadedCopyWith<$Res> {
  __$DetailsLoadedCopyWithImpl(this._self, this._then);

  final _DetailsLoaded _self;
  final $Res Function(_DetailsLoaded) _then;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_DetailsLoaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CohortDetailsResponse,
  ));
}


}

/// @nodoc


class _MembersLoaded implements CohortsState {
  const _MembersLoaded(this.response);
  

 final  CohortMembersResponse response;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembersLoadedCopyWith<_MembersLoaded> get copyWith => __$MembersLoadedCopyWithImpl<_MembersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembersLoaded&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'CohortsState.membersLoaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$MembersLoadedCopyWith<$Res> implements $CohortsStateCopyWith<$Res> {
  factory _$MembersLoadedCopyWith(_MembersLoaded value, $Res Function(_MembersLoaded) _then) = __$MembersLoadedCopyWithImpl;
@useResult
$Res call({
 CohortMembersResponse response
});




}
/// @nodoc
class __$MembersLoadedCopyWithImpl<$Res>
    implements _$MembersLoadedCopyWith<$Res> {
  __$MembersLoadedCopyWithImpl(this._self, this._then);

  final _MembersLoaded _self;
  final $Res Function(_MembersLoaded) _then;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_MembersLoaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CohortMembersResponse,
  ));
}


}

/// @nodoc


class _SaveSuccess implements CohortsState {
  const _SaveSuccess(this.response);
  

 final  CohortDetailsResponse response;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveSuccessCopyWith<_SaveSuccess> get copyWith => __$SaveSuccessCopyWithImpl<_SaveSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'CohortsState.saveSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$SaveSuccessCopyWith<$Res> implements $CohortsStateCopyWith<$Res> {
  factory _$SaveSuccessCopyWith(_SaveSuccess value, $Res Function(_SaveSuccess) _then) = __$SaveSuccessCopyWithImpl;
@useResult
$Res call({
 CohortDetailsResponse response
});




}
/// @nodoc
class __$SaveSuccessCopyWithImpl<$Res>
    implements _$SaveSuccessCopyWith<$Res> {
  __$SaveSuccessCopyWithImpl(this._self, this._then);

  final _SaveSuccess _self;
  final $Res Function(_SaveSuccess) _then;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_SaveSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CohortDetailsResponse,
  ));
}


}

/// @nodoc


class _MemberSaveSuccess implements CohortsState {
  const _MemberSaveSuccess(this.response);
  

 final  CohortMemberResponse response;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberSaveSuccessCopyWith<_MemberSaveSuccess> get copyWith => __$MemberSaveSuccessCopyWithImpl<_MemberSaveSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberSaveSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'CohortsState.memberSaveSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$MemberSaveSuccessCopyWith<$Res> implements $CohortsStateCopyWith<$Res> {
  factory _$MemberSaveSuccessCopyWith(_MemberSaveSuccess value, $Res Function(_MemberSaveSuccess) _then) = __$MemberSaveSuccessCopyWithImpl;
@useResult
$Res call({
 CohortMemberResponse response
});




}
/// @nodoc
class __$MemberSaveSuccessCopyWithImpl<$Res>
    implements _$MemberSaveSuccessCopyWith<$Res> {
  __$MemberSaveSuccessCopyWithImpl(this._self, this._then);

  final _MemberSaveSuccess _self;
  final $Res Function(_MemberSaveSuccess) _then;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_MemberSaveSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CohortMemberResponse,
  ));
}


}

/// @nodoc


class _ActionSuccess implements CohortsState {
  const _ActionSuccess(this.response);
  

 final  CohortActionResponse response;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionSuccessCopyWith<_ActionSuccess> get copyWith => __$ActionSuccessCopyWithImpl<_ActionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'CohortsState.actionSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $CohortsStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 CohortActionResponse response
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_ActionSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CohortActionResponse,
  ));
}


}

/// @nodoc


class _Error implements CohortsState {
  const _Error({required this.error});
  

 final  String error;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'CohortsState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CohortsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of CohortsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
