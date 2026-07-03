// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exams_management_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamsManagementState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamsManagementState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamsManagementState()';
}


}

/// @nodoc
class $ExamsManagementStateCopyWith<$Res>  {
$ExamsManagementStateCopyWith(ExamsManagementState _, $Res Function(ExamsManagementState) __);
}


/// Adds pattern-matching-related methods to [ExamsManagementState].
extension ExamsManagementStatePatterns on ExamsManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _DetailsLoaded value)?  detailsLoaded,TResult Function( _Saved value)?  saved,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that);case _Saved() when saved != null:
return saved(_that);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _DetailsLoaded value)  detailsLoaded,required TResult Function( _Saved value)  saved,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _DetailsLoaded():
return detailsLoaded(_that);case _Saved():
return saved(_that);case _ActionSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _DetailsLoaded value)?  detailsLoaded,TResult? Function( _Saved value)?  saved,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that);case _Saved() when saved != null:
return saved(_that);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ExamsResponse response)?  loaded,TResult Function( ExamResponse response)?  detailsLoaded,TResult Function( ExamResponse response)?  saved,TResult Function( ExamActionResponse response)?  actionSuccess,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.response);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that.response);case _Saved() when saved != null:
return saved(_that.response);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ExamsResponse response)  loaded,required TResult Function( ExamResponse response)  detailsLoaded,required TResult Function( ExamResponse response)  saved,required TResult Function( ExamActionResponse response)  actionSuccess,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.response);case _DetailsLoaded():
return detailsLoaded(_that.response);case _Saved():
return saved(_that.response);case _ActionSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ExamsResponse response)?  loaded,TResult? Function( ExamResponse response)?  detailsLoaded,TResult? Function( ExamResponse response)?  saved,TResult? Function( ExamActionResponse response)?  actionSuccess,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.response);case _DetailsLoaded() when detailsLoaded != null:
return detailsLoaded(_that.response);case _Saved() when saved != null:
return saved(_that.response);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.response);case _Error() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ExamsManagementState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamsManagementState.initial()';
}


}




/// @nodoc


class _Loading implements ExamsManagementState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamsManagementState.loading()';
}


}




/// @nodoc


class _Loaded implements ExamsManagementState {
  const _Loaded(this.response);
  

 final  ExamsResponse response;

/// Create a copy of ExamsManagementState
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
  return 'ExamsManagementState.loaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ExamsManagementStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 ExamsResponse response
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ExamsManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_Loaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as ExamsResponse,
  ));
}


}

/// @nodoc


class _DetailsLoaded implements ExamsManagementState {
  const _DetailsLoaded(this.response);
  

 final  ExamResponse response;

/// Create a copy of ExamsManagementState
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
  return 'ExamsManagementState.detailsLoaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$DetailsLoadedCopyWith<$Res> implements $ExamsManagementStateCopyWith<$Res> {
  factory _$DetailsLoadedCopyWith(_DetailsLoaded value, $Res Function(_DetailsLoaded) _then) = __$DetailsLoadedCopyWithImpl;
@useResult
$Res call({
 ExamResponse response
});




}
/// @nodoc
class __$DetailsLoadedCopyWithImpl<$Res>
    implements _$DetailsLoadedCopyWith<$Res> {
  __$DetailsLoadedCopyWithImpl(this._self, this._then);

  final _DetailsLoaded _self;
  final $Res Function(_DetailsLoaded) _then;

/// Create a copy of ExamsManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_DetailsLoaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as ExamResponse,
  ));
}


}

/// @nodoc


class _Saved implements ExamsManagementState {
  const _Saved(this.response);
  

 final  ExamResponse response;

/// Create a copy of ExamsManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedCopyWith<_Saved> get copyWith => __$SavedCopyWithImpl<_Saved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Saved&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'ExamsManagementState.saved(response: $response)';
}


}

/// @nodoc
abstract mixin class _$SavedCopyWith<$Res> implements $ExamsManagementStateCopyWith<$Res> {
  factory _$SavedCopyWith(_Saved value, $Res Function(_Saved) _then) = __$SavedCopyWithImpl;
@useResult
$Res call({
 ExamResponse response
});




}
/// @nodoc
class __$SavedCopyWithImpl<$Res>
    implements _$SavedCopyWith<$Res> {
  __$SavedCopyWithImpl(this._self, this._then);

  final _Saved _self;
  final $Res Function(_Saved) _then;

/// Create a copy of ExamsManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_Saved(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as ExamResponse,
  ));
}


}

/// @nodoc


class _ActionSuccess implements ExamsManagementState {
  const _ActionSuccess(this.response);
  

 final  ExamActionResponse response;

/// Create a copy of ExamsManagementState
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
  return 'ExamsManagementState.actionSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $ExamsManagementStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 ExamActionResponse response
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of ExamsManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_ActionSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as ExamActionResponse,
  ));
}


}

/// @nodoc


class _Error implements ExamsManagementState {
  const _Error({required this.error});
  

 final  String error;

/// Create a copy of ExamsManagementState
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
  return 'ExamsManagementState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ExamsManagementStateCopyWith<$Res> {
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

/// Create a copy of ExamsManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
