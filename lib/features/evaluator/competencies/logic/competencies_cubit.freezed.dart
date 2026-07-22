// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competencies_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompetenciesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompetenciesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompetenciesState()';
}


}

/// @nodoc
class $CompetenciesStateCopyWith<$Res>  {
$CompetenciesStateCopyWith(CompetenciesState _, $Res Function(CompetenciesState) __);
}


/// Adds pattern-matching-related methods to [CompetenciesState].
extension CompetenciesStatePatterns on CompetenciesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _CompetenciesLoading value)?  competenciesLoading,TResult Function( _Loaded value)?  loaded,TResult Function( _LoadError value)?  loadError,TResult Function( _SaveLoading value)?  saveLoading,TResult Function( _Saved value)?  saved,TResult Function( _SaveError value)?  saveError,TResult Function( _DeleteLoading value)?  deleteLoading,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _ActionError value)?  actionError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _CompetenciesLoading() when competenciesLoading != null:
return competenciesLoading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _LoadError() when loadError != null:
return loadError(_that);case _SaveLoading() when saveLoading != null:
return saveLoading(_that);case _Saved() when saved != null:
return saved(_that);case _SaveError() when saveError != null:
return saveError(_that);case _DeleteLoading() when deleteLoading != null:
return deleteLoading(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _ActionError() when actionError != null:
return actionError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _CompetenciesLoading value)  competenciesLoading,required TResult Function( _Loaded value)  loaded,required TResult Function( _LoadError value)  loadError,required TResult Function( _SaveLoading value)  saveLoading,required TResult Function( _Saved value)  saved,required TResult Function( _SaveError value)  saveError,required TResult Function( _DeleteLoading value)  deleteLoading,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _ActionError value)  actionError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _CompetenciesLoading():
return competenciesLoading(_that);case _Loaded():
return loaded(_that);case _LoadError():
return loadError(_that);case _SaveLoading():
return saveLoading(_that);case _Saved():
return saved(_that);case _SaveError():
return saveError(_that);case _DeleteLoading():
return deleteLoading(_that);case _ActionSuccess():
return actionSuccess(_that);case _ActionError():
return actionError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _CompetenciesLoading value)?  competenciesLoading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _LoadError value)?  loadError,TResult? Function( _SaveLoading value)?  saveLoading,TResult? Function( _Saved value)?  saved,TResult? Function( _SaveError value)?  saveError,TResult? Function( _DeleteLoading value)?  deleteLoading,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _ActionError value)?  actionError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _CompetenciesLoading() when competenciesLoading != null:
return competenciesLoading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _LoadError() when loadError != null:
return loadError(_that);case _SaveLoading() when saveLoading != null:
return saveLoading(_that);case _Saved() when saved != null:
return saved(_that);case _SaveError() when saveError != null:
return saveError(_that);case _DeleteLoading() when deleteLoading != null:
return deleteLoading(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _ActionError() when actionError != null:
return actionError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  competenciesLoading,TResult Function( CompetenciesTreeResponse response)?  loaded,TResult Function( String error)?  loadError,TResult Function()?  saveLoading,TResult Function( CompetencyMutationResponse response)?  saved,TResult Function( String error)?  saveError,TResult Function()?  deleteLoading,TResult Function( CompetencyActionResponse response)?  actionSuccess,TResult Function( String error)?  actionError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _CompetenciesLoading() when competenciesLoading != null:
return competenciesLoading();case _Loaded() when loaded != null:
return loaded(_that.response);case _LoadError() when loadError != null:
return loadError(_that.error);case _SaveLoading() when saveLoading != null:
return saveLoading();case _Saved() when saved != null:
return saved(_that.response);case _SaveError() when saveError != null:
return saveError(_that.error);case _DeleteLoading() when deleteLoading != null:
return deleteLoading();case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.response);case _ActionError() when actionError != null:
return actionError(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  competenciesLoading,required TResult Function( CompetenciesTreeResponse response)  loaded,required TResult Function( String error)  loadError,required TResult Function()  saveLoading,required TResult Function( CompetencyMutationResponse response)  saved,required TResult Function( String error)  saveError,required TResult Function()  deleteLoading,required TResult Function( CompetencyActionResponse response)  actionSuccess,required TResult Function( String error)  actionError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _CompetenciesLoading():
return competenciesLoading();case _Loaded():
return loaded(_that.response);case _LoadError():
return loadError(_that.error);case _SaveLoading():
return saveLoading();case _Saved():
return saved(_that.response);case _SaveError():
return saveError(_that.error);case _DeleteLoading():
return deleteLoading();case _ActionSuccess():
return actionSuccess(_that.response);case _ActionError():
return actionError(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  competenciesLoading,TResult? Function( CompetenciesTreeResponse response)?  loaded,TResult? Function( String error)?  loadError,TResult? Function()?  saveLoading,TResult? Function( CompetencyMutationResponse response)?  saved,TResult? Function( String error)?  saveError,TResult? Function()?  deleteLoading,TResult? Function( CompetencyActionResponse response)?  actionSuccess,TResult? Function( String error)?  actionError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _CompetenciesLoading() when competenciesLoading != null:
return competenciesLoading();case _Loaded() when loaded != null:
return loaded(_that.response);case _LoadError() when loadError != null:
return loadError(_that.error);case _SaveLoading() when saveLoading != null:
return saveLoading();case _Saved() when saved != null:
return saved(_that.response);case _SaveError() when saveError != null:
return saveError(_that.error);case _DeleteLoading() when deleteLoading != null:
return deleteLoading();case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.response);case _ActionError() when actionError != null:
return actionError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CompetenciesState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompetenciesState.initial()';
}


}




/// @nodoc


class _CompetenciesLoading implements CompetenciesState {
  const _CompetenciesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompetenciesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompetenciesState.competenciesLoading()';
}


}




/// @nodoc


class _Loaded implements CompetenciesState {
  const _Loaded(this.response);
  

 final  CompetenciesTreeResponse response;

/// Create a copy of CompetenciesState
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
  return 'CompetenciesState.loaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $CompetenciesStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 CompetenciesTreeResponse response
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_Loaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CompetenciesTreeResponse,
  ));
}


}

/// @nodoc


class _LoadError implements CompetenciesState {
  const _LoadError({required this.error});
  

 final  String error;

/// Create a copy of CompetenciesState
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
  return 'CompetenciesState.loadError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoadErrorCopyWith<$Res> implements $CompetenciesStateCopyWith<$Res> {
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

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_LoadError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveLoading implements CompetenciesState {
  const _SaveLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompetenciesState.saveLoading()';
}


}




/// @nodoc


class _Saved implements CompetenciesState {
  const _Saved(this.response);
  

 final  CompetencyMutationResponse response;

/// Create a copy of CompetenciesState
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
  return 'CompetenciesState.saved(response: $response)';
}


}

/// @nodoc
abstract mixin class _$SavedCopyWith<$Res> implements $CompetenciesStateCopyWith<$Res> {
  factory _$SavedCopyWith(_Saved value, $Res Function(_Saved) _then) = __$SavedCopyWithImpl;
@useResult
$Res call({
 CompetencyMutationResponse response
});




}
/// @nodoc
class __$SavedCopyWithImpl<$Res>
    implements _$SavedCopyWith<$Res> {
  __$SavedCopyWithImpl(this._self, this._then);

  final _Saved _self;
  final $Res Function(_Saved) _then;

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_Saved(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CompetencyMutationResponse,
  ));
}


}

/// @nodoc


class _SaveError implements CompetenciesState {
  const _SaveError({required this.error});
  

 final  String error;

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveErrorCopyWith<_SaveError> get copyWith => __$SaveErrorCopyWithImpl<_SaveError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'CompetenciesState.saveError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$SaveErrorCopyWith<$Res> implements $CompetenciesStateCopyWith<$Res> {
  factory _$SaveErrorCopyWith(_SaveError value, $Res Function(_SaveError) _then) = __$SaveErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$SaveErrorCopyWithImpl<$Res>
    implements _$SaveErrorCopyWith<$Res> {
  __$SaveErrorCopyWithImpl(this._self, this._then);

  final _SaveError _self;
  final $Res Function(_SaveError) _then;

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_SaveError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteLoading implements CompetenciesState {
  const _DeleteLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CompetenciesState.deleteLoading()';
}


}




/// @nodoc


class _ActionSuccess implements CompetenciesState {
  const _ActionSuccess(this.response);
  

 final  CompetencyActionResponse response;

/// Create a copy of CompetenciesState
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
  return 'CompetenciesState.actionSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $CompetenciesStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 CompetencyActionResponse response
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_ActionSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CompetencyActionResponse,
  ));
}


}

/// @nodoc


class _ActionError implements CompetenciesState {
  const _ActionError({required this.error});
  

 final  String error;

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionErrorCopyWith<_ActionError> get copyWith => __$ActionErrorCopyWithImpl<_ActionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'CompetenciesState.actionError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ActionErrorCopyWith<$Res> implements $CompetenciesStateCopyWith<$Res> {
  factory _$ActionErrorCopyWith(_ActionError value, $Res Function(_ActionError) _then) = __$ActionErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$ActionErrorCopyWithImpl<$Res>
    implements _$ActionErrorCopyWith<$Res> {
  __$ActionErrorCopyWithImpl(this._self, this._then);

  final _ActionError _self;
  final $Res Function(_ActionError) _then;

/// Create a copy of CompetenciesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_ActionError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
