// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_sessions_and_enrollment_management_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LiveSessionsAndEnrollmentManagementState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveSessionsAndEnrollmentManagementState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState()';
}


}

/// @nodoc
class $LiveSessionsAndEnrollmentManagementStateCopyWith<$Res>  {
$LiveSessionsAndEnrollmentManagementStateCopyWith(LiveSessionsAndEnrollmentManagementState _, $Res Function(LiveSessionsAndEnrollmentManagementState) __);
}


/// Adds pattern-matching-related methods to [LiveSessionsAndEnrollmentManagementState].
extension LiveSessionsAndEnrollmentManagementStatePatterns on LiveSessionsAndEnrollmentManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _EnrollmentsLoading value)?  enrollmentsLoading,TResult Function( _Loaded value)?  loaded,TResult Function( _LoadError value)?  loadError,TResult Function( _CreateLoading value)?  createLoading,TResult Function( _CreateSuccess value)?  createSuccess,TResult Function( _CreateError value)?  createError,TResult Function( _DeleteLoading value)?  deleteLoading,TResult Function( _DeleteSuccess value)?  deleteSuccess,TResult Function( _DeleteError value)?  deleteError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _EnrollmentsLoading() when enrollmentsLoading != null:
return enrollmentsLoading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _LoadError() when loadError != null:
return loadError(_that);case _CreateLoading() when createLoading != null:
return createLoading(_that);case _CreateSuccess() when createSuccess != null:
return createSuccess(_that);case _CreateError() when createError != null:
return createError(_that);case _DeleteLoading() when deleteLoading != null:
return deleteLoading(_that);case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that);case _DeleteError() when deleteError != null:
return deleteError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _EnrollmentsLoading value)  enrollmentsLoading,required TResult Function( _Loaded value)  loaded,required TResult Function( _LoadError value)  loadError,required TResult Function( _CreateLoading value)  createLoading,required TResult Function( _CreateSuccess value)  createSuccess,required TResult Function( _CreateError value)  createError,required TResult Function( _DeleteLoading value)  deleteLoading,required TResult Function( _DeleteSuccess value)  deleteSuccess,required TResult Function( _DeleteError value)  deleteError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _EnrollmentsLoading():
return enrollmentsLoading(_that);case _Loaded():
return loaded(_that);case _LoadError():
return loadError(_that);case _CreateLoading():
return createLoading(_that);case _CreateSuccess():
return createSuccess(_that);case _CreateError():
return createError(_that);case _DeleteLoading():
return deleteLoading(_that);case _DeleteSuccess():
return deleteSuccess(_that);case _DeleteError():
return deleteError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _EnrollmentsLoading value)?  enrollmentsLoading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _LoadError value)?  loadError,TResult? Function( _CreateLoading value)?  createLoading,TResult? Function( _CreateSuccess value)?  createSuccess,TResult? Function( _CreateError value)?  createError,TResult? Function( _DeleteLoading value)?  deleteLoading,TResult? Function( _DeleteSuccess value)?  deleteSuccess,TResult? Function( _DeleteError value)?  deleteError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _EnrollmentsLoading() when enrollmentsLoading != null:
return enrollmentsLoading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _LoadError() when loadError != null:
return loadError(_that);case _CreateLoading() when createLoading != null:
return createLoading(_that);case _CreateSuccess() when createSuccess != null:
return createSuccess(_that);case _CreateError() when createError != null:
return createError(_that);case _DeleteLoading() when deleteLoading != null:
return deleteLoading(_that);case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that);case _DeleteError() when deleteError != null:
return deleteError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  enrollmentsLoading,TResult Function( EnrollmentsResponse response)?  loaded,TResult Function( String error)?  loadError,TResult Function()?  createLoading,TResult Function( EnrollmentResponse response)?  createSuccess,TResult Function( String error)?  createError,TResult Function()?  deleteLoading,TResult Function( EnrollmentActionResponse response)?  deleteSuccess,TResult Function( String error)?  deleteError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _EnrollmentsLoading() when enrollmentsLoading != null:
return enrollmentsLoading();case _Loaded() when loaded != null:
return loaded(_that.response);case _LoadError() when loadError != null:
return loadError(_that.error);case _CreateLoading() when createLoading != null:
return createLoading();case _CreateSuccess() when createSuccess != null:
return createSuccess(_that.response);case _CreateError() when createError != null:
return createError(_that.error);case _DeleteLoading() when deleteLoading != null:
return deleteLoading();case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that.response);case _DeleteError() when deleteError != null:
return deleteError(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  enrollmentsLoading,required TResult Function( EnrollmentsResponse response)  loaded,required TResult Function( String error)  loadError,required TResult Function()  createLoading,required TResult Function( EnrollmentResponse response)  createSuccess,required TResult Function( String error)  createError,required TResult Function()  deleteLoading,required TResult Function( EnrollmentActionResponse response)  deleteSuccess,required TResult Function( String error)  deleteError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _EnrollmentsLoading():
return enrollmentsLoading();case _Loaded():
return loaded(_that.response);case _LoadError():
return loadError(_that.error);case _CreateLoading():
return createLoading();case _CreateSuccess():
return createSuccess(_that.response);case _CreateError():
return createError(_that.error);case _DeleteLoading():
return deleteLoading();case _DeleteSuccess():
return deleteSuccess(_that.response);case _DeleteError():
return deleteError(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  enrollmentsLoading,TResult? Function( EnrollmentsResponse response)?  loaded,TResult? Function( String error)?  loadError,TResult? Function()?  createLoading,TResult? Function( EnrollmentResponse response)?  createSuccess,TResult? Function( String error)?  createError,TResult? Function()?  deleteLoading,TResult? Function( EnrollmentActionResponse response)?  deleteSuccess,TResult? Function( String error)?  deleteError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _EnrollmentsLoading() when enrollmentsLoading != null:
return enrollmentsLoading();case _Loaded() when loaded != null:
return loaded(_that.response);case _LoadError() when loadError != null:
return loadError(_that.error);case _CreateLoading() when createLoading != null:
return createLoading();case _CreateSuccess() when createSuccess != null:
return createSuccess(_that.response);case _CreateError() when createError != null:
return createError(_that.error);case _DeleteLoading() when deleteLoading != null:
return deleteLoading();case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that.response);case _DeleteError() when deleteError != null:
return deleteError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements LiveSessionsAndEnrollmentManagementState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.initial()';
}


}




/// @nodoc


class _EnrollmentsLoading implements LiveSessionsAndEnrollmentManagementState {
  const _EnrollmentsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrollmentsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.enrollmentsLoading()';
}


}




/// @nodoc


class _Loaded implements LiveSessionsAndEnrollmentManagementState {
  const _Loaded(this.response);
  

 final  EnrollmentsResponse response;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
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
  return 'LiveSessionsAndEnrollmentManagementState.loaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $LiveSessionsAndEnrollmentManagementStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 EnrollmentsResponse response
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_Loaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as EnrollmentsResponse,
  ));
}


}

/// @nodoc


class _LoadError implements LiveSessionsAndEnrollmentManagementState {
  const _LoadError({required this.error});
  

 final  String error;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadErrorCopyWith<_LoadError> get copyWith => __$LoadErrorCopyWithImpl<_LoadError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.loadError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoadErrorCopyWith<$Res> implements $LiveSessionsAndEnrollmentManagementStateCopyWith<$Res> {
  factory _$LoadErrorCopyWith(_LoadError value, $Res Function(_LoadError) _then) = __$LoadErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$LoadErrorCopyWithImpl<$Res>
    implements _$LoadErrorCopyWith<$Res> {
  __$LoadErrorCopyWithImpl(this._self, this._then);

  final _LoadError _self;
  final $Res Function(_LoadError) _then;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_LoadError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CreateLoading implements LiveSessionsAndEnrollmentManagementState {
  const _CreateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.createLoading()';
}


}




/// @nodoc


class _CreateSuccess implements LiveSessionsAndEnrollmentManagementState {
  const _CreateSuccess(this.response);
  

 final  EnrollmentResponse response;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateSuccessCopyWith<_CreateSuccess> get copyWith => __$CreateSuccessCopyWithImpl<_CreateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.createSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$CreateSuccessCopyWith<$Res> implements $LiveSessionsAndEnrollmentManagementStateCopyWith<$Res> {
  factory _$CreateSuccessCopyWith(_CreateSuccess value, $Res Function(_CreateSuccess) _then) = __$CreateSuccessCopyWithImpl;
@useResult
$Res call({
 EnrollmentResponse response
});




}
/// @nodoc
class __$CreateSuccessCopyWithImpl<$Res>
    implements _$CreateSuccessCopyWith<$Res> {
  __$CreateSuccessCopyWithImpl(this._self, this._then);

  final _CreateSuccess _self;
  final $Res Function(_CreateSuccess) _then;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_CreateSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as EnrollmentResponse,
  ));
}


}

/// @nodoc


class _CreateError implements LiveSessionsAndEnrollmentManagementState {
  const _CreateError({required this.error});
  

 final  String error;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateErrorCopyWith<_CreateError> get copyWith => __$CreateErrorCopyWithImpl<_CreateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.createError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$CreateErrorCopyWith<$Res> implements $LiveSessionsAndEnrollmentManagementStateCopyWith<$Res> {
  factory _$CreateErrorCopyWith(_CreateError value, $Res Function(_CreateError) _then) = __$CreateErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$CreateErrorCopyWithImpl<$Res>
    implements _$CreateErrorCopyWith<$Res> {
  __$CreateErrorCopyWithImpl(this._self, this._then);

  final _CreateError _self;
  final $Res Function(_CreateError) _then;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_CreateError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteLoading implements LiveSessionsAndEnrollmentManagementState {
  const _DeleteLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.deleteLoading()';
}


}




/// @nodoc


class _DeleteSuccess implements LiveSessionsAndEnrollmentManagementState {
  const _DeleteSuccess(this.response);
  

 final  EnrollmentActionResponse response;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteSuccessCopyWith<_DeleteSuccess> get copyWith => __$DeleteSuccessCopyWithImpl<_DeleteSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.deleteSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$DeleteSuccessCopyWith<$Res> implements $LiveSessionsAndEnrollmentManagementStateCopyWith<$Res> {
  factory _$DeleteSuccessCopyWith(_DeleteSuccess value, $Res Function(_DeleteSuccess) _then) = __$DeleteSuccessCopyWithImpl;
@useResult
$Res call({
 EnrollmentActionResponse response
});




}
/// @nodoc
class __$DeleteSuccessCopyWithImpl<$Res>
    implements _$DeleteSuccessCopyWith<$Res> {
  __$DeleteSuccessCopyWithImpl(this._self, this._then);

  final _DeleteSuccess _self;
  final $Res Function(_DeleteSuccess) _then;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_DeleteSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as EnrollmentActionResponse,
  ));
}


}

/// @nodoc


class _DeleteError implements LiveSessionsAndEnrollmentManagementState {
  const _DeleteError({required this.error});
  

 final  String error;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteErrorCopyWith<_DeleteError> get copyWith => __$DeleteErrorCopyWithImpl<_DeleteError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'LiveSessionsAndEnrollmentManagementState.deleteError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$DeleteErrorCopyWith<$Res> implements $LiveSessionsAndEnrollmentManagementStateCopyWith<$Res> {
  factory _$DeleteErrorCopyWith(_DeleteError value, $Res Function(_DeleteError) _then) = __$DeleteErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$DeleteErrorCopyWithImpl<$Res>
    implements _$DeleteErrorCopyWith<$Res> {
  __$DeleteErrorCopyWithImpl(this._self, this._then);

  final _DeleteError _self;
  final $Res Function(_DeleteError) _then;

/// Create a copy of LiveSessionsAndEnrollmentManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_DeleteError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
