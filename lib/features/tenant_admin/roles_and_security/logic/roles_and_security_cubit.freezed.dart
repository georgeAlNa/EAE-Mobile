// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roles_and_security_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RolesAndSecurityState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesAndSecurityState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState()';
}


}

/// @nodoc
class $RolesAndSecurityStateCopyWith<$Res>  {
$RolesAndSecurityStateCopyWith(RolesAndSecurityState _, $Res Function(RolesAndSecurityState) __);
}


/// Adds pattern-matching-related methods to [RolesAndSecurityState].
extension RolesAndSecurityStatePatterns on RolesAndSecurityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _LoadingDashboard value)?  loadingDashboard,TResult Function( _Loaded value)?  loaded,TResult Function( _LoadError value)?  loadError,TResult Function( _CreateRoleLoading value)?  createRoleLoading,TResult Function( _CreateRoleSuccess value)?  createRoleSuccess,TResult Function( _CreateRoleError value)?  createRoleError,TResult Function( _UpdateRoleLoading value)?  updateRoleLoading,TResult Function( _UpdateRoleSuccess value)?  updateRoleSuccess,TResult Function( _UpdateRoleError value)?  updateRoleError,TResult Function( _DeleteRoleLoading value)?  deleteRoleLoading,TResult Function( _DeleteRoleSuccess value)?  deleteRoleSuccess,TResult Function( _DeleteRoleError value)?  deleteRoleError,TResult Function( _AssignRoleLoading value)?  assignRoleLoading,TResult Function( _AssignRoleSuccess value)?  assignRoleSuccess,TResult Function( _AssignRoleError value)?  assignRoleError,TResult Function( _RemoveRoleLoading value)?  removeRoleLoading,TResult Function( _RemoveRoleSuccess value)?  removeRoleSuccess,TResult Function( _RemoveRoleError value)?  removeRoleError,TResult Function( _SecurityPolicyUpdateLoading value)?  securityPolicyUpdateLoading,TResult Function( _SecurityPolicyUpdateSuccess value)?  securityPolicyUpdateSuccess,TResult Function( _SecurityPolicyUpdateError value)?  securityPolicyUpdateError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadingDashboard() when loadingDashboard != null:
return loadingDashboard(_that);case _Loaded() when loaded != null:
return loaded(_that);case _LoadError() when loadError != null:
return loadError(_that);case _CreateRoleLoading() when createRoleLoading != null:
return createRoleLoading(_that);case _CreateRoleSuccess() when createRoleSuccess != null:
return createRoleSuccess(_that);case _CreateRoleError() when createRoleError != null:
return createRoleError(_that);case _UpdateRoleLoading() when updateRoleLoading != null:
return updateRoleLoading(_that);case _UpdateRoleSuccess() when updateRoleSuccess != null:
return updateRoleSuccess(_that);case _UpdateRoleError() when updateRoleError != null:
return updateRoleError(_that);case _DeleteRoleLoading() when deleteRoleLoading != null:
return deleteRoleLoading(_that);case _DeleteRoleSuccess() when deleteRoleSuccess != null:
return deleteRoleSuccess(_that);case _DeleteRoleError() when deleteRoleError != null:
return deleteRoleError(_that);case _AssignRoleLoading() when assignRoleLoading != null:
return assignRoleLoading(_that);case _AssignRoleSuccess() when assignRoleSuccess != null:
return assignRoleSuccess(_that);case _AssignRoleError() when assignRoleError != null:
return assignRoleError(_that);case _RemoveRoleLoading() when removeRoleLoading != null:
return removeRoleLoading(_that);case _RemoveRoleSuccess() when removeRoleSuccess != null:
return removeRoleSuccess(_that);case _RemoveRoleError() when removeRoleError != null:
return removeRoleError(_that);case _SecurityPolicyUpdateLoading() when securityPolicyUpdateLoading != null:
return securityPolicyUpdateLoading(_that);case _SecurityPolicyUpdateSuccess() when securityPolicyUpdateSuccess != null:
return securityPolicyUpdateSuccess(_that);case _SecurityPolicyUpdateError() when securityPolicyUpdateError != null:
return securityPolicyUpdateError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _LoadingDashboard value)  loadingDashboard,required TResult Function( _Loaded value)  loaded,required TResult Function( _LoadError value)  loadError,required TResult Function( _CreateRoleLoading value)  createRoleLoading,required TResult Function( _CreateRoleSuccess value)  createRoleSuccess,required TResult Function( _CreateRoleError value)  createRoleError,required TResult Function( _UpdateRoleLoading value)  updateRoleLoading,required TResult Function( _UpdateRoleSuccess value)  updateRoleSuccess,required TResult Function( _UpdateRoleError value)  updateRoleError,required TResult Function( _DeleteRoleLoading value)  deleteRoleLoading,required TResult Function( _DeleteRoleSuccess value)  deleteRoleSuccess,required TResult Function( _DeleteRoleError value)  deleteRoleError,required TResult Function( _AssignRoleLoading value)  assignRoleLoading,required TResult Function( _AssignRoleSuccess value)  assignRoleSuccess,required TResult Function( _AssignRoleError value)  assignRoleError,required TResult Function( _RemoveRoleLoading value)  removeRoleLoading,required TResult Function( _RemoveRoleSuccess value)  removeRoleSuccess,required TResult Function( _RemoveRoleError value)  removeRoleError,required TResult Function( _SecurityPolicyUpdateLoading value)  securityPolicyUpdateLoading,required TResult Function( _SecurityPolicyUpdateSuccess value)  securityPolicyUpdateSuccess,required TResult Function( _SecurityPolicyUpdateError value)  securityPolicyUpdateError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _LoadingDashboard():
return loadingDashboard(_that);case _Loaded():
return loaded(_that);case _LoadError():
return loadError(_that);case _CreateRoleLoading():
return createRoleLoading(_that);case _CreateRoleSuccess():
return createRoleSuccess(_that);case _CreateRoleError():
return createRoleError(_that);case _UpdateRoleLoading():
return updateRoleLoading(_that);case _UpdateRoleSuccess():
return updateRoleSuccess(_that);case _UpdateRoleError():
return updateRoleError(_that);case _DeleteRoleLoading():
return deleteRoleLoading(_that);case _DeleteRoleSuccess():
return deleteRoleSuccess(_that);case _DeleteRoleError():
return deleteRoleError(_that);case _AssignRoleLoading():
return assignRoleLoading(_that);case _AssignRoleSuccess():
return assignRoleSuccess(_that);case _AssignRoleError():
return assignRoleError(_that);case _RemoveRoleLoading():
return removeRoleLoading(_that);case _RemoveRoleSuccess():
return removeRoleSuccess(_that);case _RemoveRoleError():
return removeRoleError(_that);case _SecurityPolicyUpdateLoading():
return securityPolicyUpdateLoading(_that);case _SecurityPolicyUpdateSuccess():
return securityPolicyUpdateSuccess(_that);case _SecurityPolicyUpdateError():
return securityPolicyUpdateError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _LoadingDashboard value)?  loadingDashboard,TResult? Function( _Loaded value)?  loaded,TResult? Function( _LoadError value)?  loadError,TResult? Function( _CreateRoleLoading value)?  createRoleLoading,TResult? Function( _CreateRoleSuccess value)?  createRoleSuccess,TResult? Function( _CreateRoleError value)?  createRoleError,TResult? Function( _UpdateRoleLoading value)?  updateRoleLoading,TResult? Function( _UpdateRoleSuccess value)?  updateRoleSuccess,TResult? Function( _UpdateRoleError value)?  updateRoleError,TResult? Function( _DeleteRoleLoading value)?  deleteRoleLoading,TResult? Function( _DeleteRoleSuccess value)?  deleteRoleSuccess,TResult? Function( _DeleteRoleError value)?  deleteRoleError,TResult? Function( _AssignRoleLoading value)?  assignRoleLoading,TResult? Function( _AssignRoleSuccess value)?  assignRoleSuccess,TResult? Function( _AssignRoleError value)?  assignRoleError,TResult? Function( _RemoveRoleLoading value)?  removeRoleLoading,TResult? Function( _RemoveRoleSuccess value)?  removeRoleSuccess,TResult? Function( _RemoveRoleError value)?  removeRoleError,TResult? Function( _SecurityPolicyUpdateLoading value)?  securityPolicyUpdateLoading,TResult? Function( _SecurityPolicyUpdateSuccess value)?  securityPolicyUpdateSuccess,TResult? Function( _SecurityPolicyUpdateError value)?  securityPolicyUpdateError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadingDashboard() when loadingDashboard != null:
return loadingDashboard(_that);case _Loaded() when loaded != null:
return loaded(_that);case _LoadError() when loadError != null:
return loadError(_that);case _CreateRoleLoading() when createRoleLoading != null:
return createRoleLoading(_that);case _CreateRoleSuccess() when createRoleSuccess != null:
return createRoleSuccess(_that);case _CreateRoleError() when createRoleError != null:
return createRoleError(_that);case _UpdateRoleLoading() when updateRoleLoading != null:
return updateRoleLoading(_that);case _UpdateRoleSuccess() when updateRoleSuccess != null:
return updateRoleSuccess(_that);case _UpdateRoleError() when updateRoleError != null:
return updateRoleError(_that);case _DeleteRoleLoading() when deleteRoleLoading != null:
return deleteRoleLoading(_that);case _DeleteRoleSuccess() when deleteRoleSuccess != null:
return deleteRoleSuccess(_that);case _DeleteRoleError() when deleteRoleError != null:
return deleteRoleError(_that);case _AssignRoleLoading() when assignRoleLoading != null:
return assignRoleLoading(_that);case _AssignRoleSuccess() when assignRoleSuccess != null:
return assignRoleSuccess(_that);case _AssignRoleError() when assignRoleError != null:
return assignRoleError(_that);case _RemoveRoleLoading() when removeRoleLoading != null:
return removeRoleLoading(_that);case _RemoveRoleSuccess() when removeRoleSuccess != null:
return removeRoleSuccess(_that);case _RemoveRoleError() when removeRoleError != null:
return removeRoleError(_that);case _SecurityPolicyUpdateLoading() when securityPolicyUpdateLoading != null:
return securityPolicyUpdateLoading(_that);case _SecurityPolicyUpdateSuccess() when securityPolicyUpdateSuccess != null:
return securityPolicyUpdateSuccess(_that);case _SecurityPolicyUpdateError() when securityPolicyUpdateError != null:
return securityPolicyUpdateError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loadingDashboard,TResult Function( RolesResponse rolesResponse,  SecurityPolicyResponse securityPolicyResponse)?  loaded,TResult Function( String error)?  loadError,TResult Function()?  createRoleLoading,TResult Function( CreateRoleResponse response)?  createRoleSuccess,TResult Function( String error)?  createRoleError,TResult Function()?  updateRoleLoading,TResult Function( RoleActionResponse response)?  updateRoleSuccess,TResult Function( String error)?  updateRoleError,TResult Function()?  deleteRoleLoading,TResult Function( RoleActionResponse response)?  deleteRoleSuccess,TResult Function( String error)?  deleteRoleError,TResult Function()?  assignRoleLoading,TResult Function( RoleActionResponse response)?  assignRoleSuccess,TResult Function( String error)?  assignRoleError,TResult Function()?  removeRoleLoading,TResult Function( RoleActionResponse response)?  removeRoleSuccess,TResult Function( String error)?  removeRoleError,TResult Function()?  securityPolicyUpdateLoading,TResult Function( SecurityPolicyResponse response)?  securityPolicyUpdateSuccess,TResult Function( String error)?  securityPolicyUpdateError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadingDashboard() when loadingDashboard != null:
return loadingDashboard();case _Loaded() when loaded != null:
return loaded(_that.rolesResponse,_that.securityPolicyResponse);case _LoadError() when loadError != null:
return loadError(_that.error);case _CreateRoleLoading() when createRoleLoading != null:
return createRoleLoading();case _CreateRoleSuccess() when createRoleSuccess != null:
return createRoleSuccess(_that.response);case _CreateRoleError() when createRoleError != null:
return createRoleError(_that.error);case _UpdateRoleLoading() when updateRoleLoading != null:
return updateRoleLoading();case _UpdateRoleSuccess() when updateRoleSuccess != null:
return updateRoleSuccess(_that.response);case _UpdateRoleError() when updateRoleError != null:
return updateRoleError(_that.error);case _DeleteRoleLoading() when deleteRoleLoading != null:
return deleteRoleLoading();case _DeleteRoleSuccess() when deleteRoleSuccess != null:
return deleteRoleSuccess(_that.response);case _DeleteRoleError() when deleteRoleError != null:
return deleteRoleError(_that.error);case _AssignRoleLoading() when assignRoleLoading != null:
return assignRoleLoading();case _AssignRoleSuccess() when assignRoleSuccess != null:
return assignRoleSuccess(_that.response);case _AssignRoleError() when assignRoleError != null:
return assignRoleError(_that.error);case _RemoveRoleLoading() when removeRoleLoading != null:
return removeRoleLoading();case _RemoveRoleSuccess() when removeRoleSuccess != null:
return removeRoleSuccess(_that.response);case _RemoveRoleError() when removeRoleError != null:
return removeRoleError(_that.error);case _SecurityPolicyUpdateLoading() when securityPolicyUpdateLoading != null:
return securityPolicyUpdateLoading();case _SecurityPolicyUpdateSuccess() when securityPolicyUpdateSuccess != null:
return securityPolicyUpdateSuccess(_that.response);case _SecurityPolicyUpdateError() when securityPolicyUpdateError != null:
return securityPolicyUpdateError(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loadingDashboard,required TResult Function( RolesResponse rolesResponse,  SecurityPolicyResponse securityPolicyResponse)  loaded,required TResult Function( String error)  loadError,required TResult Function()  createRoleLoading,required TResult Function( CreateRoleResponse response)  createRoleSuccess,required TResult Function( String error)  createRoleError,required TResult Function()  updateRoleLoading,required TResult Function( RoleActionResponse response)  updateRoleSuccess,required TResult Function( String error)  updateRoleError,required TResult Function()  deleteRoleLoading,required TResult Function( RoleActionResponse response)  deleteRoleSuccess,required TResult Function( String error)  deleteRoleError,required TResult Function()  assignRoleLoading,required TResult Function( RoleActionResponse response)  assignRoleSuccess,required TResult Function( String error)  assignRoleError,required TResult Function()  removeRoleLoading,required TResult Function( RoleActionResponse response)  removeRoleSuccess,required TResult Function( String error)  removeRoleError,required TResult Function()  securityPolicyUpdateLoading,required TResult Function( SecurityPolicyResponse response)  securityPolicyUpdateSuccess,required TResult Function( String error)  securityPolicyUpdateError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _LoadingDashboard():
return loadingDashboard();case _Loaded():
return loaded(_that.rolesResponse,_that.securityPolicyResponse);case _LoadError():
return loadError(_that.error);case _CreateRoleLoading():
return createRoleLoading();case _CreateRoleSuccess():
return createRoleSuccess(_that.response);case _CreateRoleError():
return createRoleError(_that.error);case _UpdateRoleLoading():
return updateRoleLoading();case _UpdateRoleSuccess():
return updateRoleSuccess(_that.response);case _UpdateRoleError():
return updateRoleError(_that.error);case _DeleteRoleLoading():
return deleteRoleLoading();case _DeleteRoleSuccess():
return deleteRoleSuccess(_that.response);case _DeleteRoleError():
return deleteRoleError(_that.error);case _AssignRoleLoading():
return assignRoleLoading();case _AssignRoleSuccess():
return assignRoleSuccess(_that.response);case _AssignRoleError():
return assignRoleError(_that.error);case _RemoveRoleLoading():
return removeRoleLoading();case _RemoveRoleSuccess():
return removeRoleSuccess(_that.response);case _RemoveRoleError():
return removeRoleError(_that.error);case _SecurityPolicyUpdateLoading():
return securityPolicyUpdateLoading();case _SecurityPolicyUpdateSuccess():
return securityPolicyUpdateSuccess(_that.response);case _SecurityPolicyUpdateError():
return securityPolicyUpdateError(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loadingDashboard,TResult? Function( RolesResponse rolesResponse,  SecurityPolicyResponse securityPolicyResponse)?  loaded,TResult? Function( String error)?  loadError,TResult? Function()?  createRoleLoading,TResult? Function( CreateRoleResponse response)?  createRoleSuccess,TResult? Function( String error)?  createRoleError,TResult? Function()?  updateRoleLoading,TResult? Function( RoleActionResponse response)?  updateRoleSuccess,TResult? Function( String error)?  updateRoleError,TResult? Function()?  deleteRoleLoading,TResult? Function( RoleActionResponse response)?  deleteRoleSuccess,TResult? Function( String error)?  deleteRoleError,TResult? Function()?  assignRoleLoading,TResult? Function( RoleActionResponse response)?  assignRoleSuccess,TResult? Function( String error)?  assignRoleError,TResult? Function()?  removeRoleLoading,TResult? Function( RoleActionResponse response)?  removeRoleSuccess,TResult? Function( String error)?  removeRoleError,TResult? Function()?  securityPolicyUpdateLoading,TResult? Function( SecurityPolicyResponse response)?  securityPolicyUpdateSuccess,TResult? Function( String error)?  securityPolicyUpdateError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadingDashboard() when loadingDashboard != null:
return loadingDashboard();case _Loaded() when loaded != null:
return loaded(_that.rolesResponse,_that.securityPolicyResponse);case _LoadError() when loadError != null:
return loadError(_that.error);case _CreateRoleLoading() when createRoleLoading != null:
return createRoleLoading();case _CreateRoleSuccess() when createRoleSuccess != null:
return createRoleSuccess(_that.response);case _CreateRoleError() when createRoleError != null:
return createRoleError(_that.error);case _UpdateRoleLoading() when updateRoleLoading != null:
return updateRoleLoading();case _UpdateRoleSuccess() when updateRoleSuccess != null:
return updateRoleSuccess(_that.response);case _UpdateRoleError() when updateRoleError != null:
return updateRoleError(_that.error);case _DeleteRoleLoading() when deleteRoleLoading != null:
return deleteRoleLoading();case _DeleteRoleSuccess() when deleteRoleSuccess != null:
return deleteRoleSuccess(_that.response);case _DeleteRoleError() when deleteRoleError != null:
return deleteRoleError(_that.error);case _AssignRoleLoading() when assignRoleLoading != null:
return assignRoleLoading();case _AssignRoleSuccess() when assignRoleSuccess != null:
return assignRoleSuccess(_that.response);case _AssignRoleError() when assignRoleError != null:
return assignRoleError(_that.error);case _RemoveRoleLoading() when removeRoleLoading != null:
return removeRoleLoading();case _RemoveRoleSuccess() when removeRoleSuccess != null:
return removeRoleSuccess(_that.response);case _RemoveRoleError() when removeRoleError != null:
return removeRoleError(_that.error);case _SecurityPolicyUpdateLoading() when securityPolicyUpdateLoading != null:
return securityPolicyUpdateLoading();case _SecurityPolicyUpdateSuccess() when securityPolicyUpdateSuccess != null:
return securityPolicyUpdateSuccess(_that.response);case _SecurityPolicyUpdateError() when securityPolicyUpdateError != null:
return securityPolicyUpdateError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RolesAndSecurityState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.initial()';
}


}




/// @nodoc


class _LoadingDashboard implements RolesAndSecurityState {
  const _LoadingDashboard();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadingDashboard);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.loadingDashboard()';
}


}




/// @nodoc


class _Loaded implements RolesAndSecurityState {
  const _Loaded({required this.rolesResponse, required this.securityPolicyResponse});
  

 final  RolesResponse rolesResponse;
 final  SecurityPolicyResponse securityPolicyResponse;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.rolesResponse, rolesResponse) || other.rolesResponse == rolesResponse)&&(identical(other.securityPolicyResponse, securityPolicyResponse) || other.securityPolicyResponse == securityPolicyResponse));
}


@override
int get hashCode => Object.hash(runtimeType,rolesResponse,securityPolicyResponse);

@override
String toString() {
  return 'RolesAndSecurityState.loaded(rolesResponse: $rolesResponse, securityPolicyResponse: $securityPolicyResponse)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 RolesResponse rolesResponse, SecurityPolicyResponse securityPolicyResponse
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rolesResponse = null,Object? securityPolicyResponse = null,}) {
  return _then(_Loaded(
rolesResponse: null == rolesResponse ? _self.rolesResponse : rolesResponse // ignore: cast_nullable_to_non_nullable
as RolesResponse,securityPolicyResponse: null == securityPolicyResponse ? _self.securityPolicyResponse : securityPolicyResponse // ignore: cast_nullable_to_non_nullable
as SecurityPolicyResponse,
  ));
}


}

/// @nodoc


class _LoadError implements RolesAndSecurityState {
  const _LoadError({required this.error});
  

 final  String error;

/// Create a copy of RolesAndSecurityState
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
  return 'RolesAndSecurityState.loadError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoadErrorCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
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

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_LoadError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CreateRoleLoading implements RolesAndSecurityState {
  const _CreateRoleLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoleLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.createRoleLoading()';
}


}




/// @nodoc


class _CreateRoleSuccess implements RolesAndSecurityState {
  const _CreateRoleSuccess(this.response);
  

 final  CreateRoleResponse response;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRoleSuccessCopyWith<_CreateRoleSuccess> get copyWith => __$CreateRoleSuccessCopyWithImpl<_CreateRoleSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoleSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'RolesAndSecurityState.createRoleSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$CreateRoleSuccessCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$CreateRoleSuccessCopyWith(_CreateRoleSuccess value, $Res Function(_CreateRoleSuccess) _then) = __$CreateRoleSuccessCopyWithImpl;
@useResult
$Res call({
 CreateRoleResponse response
});




}
/// @nodoc
class __$CreateRoleSuccessCopyWithImpl<$Res>
    implements _$CreateRoleSuccessCopyWith<$Res> {
  __$CreateRoleSuccessCopyWithImpl(this._self, this._then);

  final _CreateRoleSuccess _self;
  final $Res Function(_CreateRoleSuccess) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_CreateRoleSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CreateRoleResponse,
  ));
}


}

/// @nodoc


class _CreateRoleError implements RolesAndSecurityState {
  const _CreateRoleError({required this.error});
  

 final  String error;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRoleErrorCopyWith<_CreateRoleError> get copyWith => __$CreateRoleErrorCopyWithImpl<_CreateRoleError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRoleError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RolesAndSecurityState.createRoleError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$CreateRoleErrorCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$CreateRoleErrorCopyWith(_CreateRoleError value, $Res Function(_CreateRoleError) _then) = __$CreateRoleErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$CreateRoleErrorCopyWithImpl<$Res>
    implements _$CreateRoleErrorCopyWith<$Res> {
  __$CreateRoleErrorCopyWithImpl(this._self, this._then);

  final _CreateRoleError _self;
  final $Res Function(_CreateRoleError) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_CreateRoleError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateRoleLoading implements RolesAndSecurityState {
  const _UpdateRoleLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateRoleLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.updateRoleLoading()';
}


}




/// @nodoc


class _UpdateRoleSuccess implements RolesAndSecurityState {
  const _UpdateRoleSuccess(this.response);
  

 final  RoleActionResponse response;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateRoleSuccessCopyWith<_UpdateRoleSuccess> get copyWith => __$UpdateRoleSuccessCopyWithImpl<_UpdateRoleSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateRoleSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'RolesAndSecurityState.updateRoleSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$UpdateRoleSuccessCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$UpdateRoleSuccessCopyWith(_UpdateRoleSuccess value, $Res Function(_UpdateRoleSuccess) _then) = __$UpdateRoleSuccessCopyWithImpl;
@useResult
$Res call({
 RoleActionResponse response
});




}
/// @nodoc
class __$UpdateRoleSuccessCopyWithImpl<$Res>
    implements _$UpdateRoleSuccessCopyWith<$Res> {
  __$UpdateRoleSuccessCopyWithImpl(this._self, this._then);

  final _UpdateRoleSuccess _self;
  final $Res Function(_UpdateRoleSuccess) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_UpdateRoleSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as RoleActionResponse,
  ));
}


}

/// @nodoc


class _UpdateRoleError implements RolesAndSecurityState {
  const _UpdateRoleError({required this.error});
  

 final  String error;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateRoleErrorCopyWith<_UpdateRoleError> get copyWith => __$UpdateRoleErrorCopyWithImpl<_UpdateRoleError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateRoleError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RolesAndSecurityState.updateRoleError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$UpdateRoleErrorCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$UpdateRoleErrorCopyWith(_UpdateRoleError value, $Res Function(_UpdateRoleError) _then) = __$UpdateRoleErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$UpdateRoleErrorCopyWithImpl<$Res>
    implements _$UpdateRoleErrorCopyWith<$Res> {
  __$UpdateRoleErrorCopyWithImpl(this._self, this._then);

  final _UpdateRoleError _self;
  final $Res Function(_UpdateRoleError) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_UpdateRoleError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteRoleLoading implements RolesAndSecurityState {
  const _DeleteRoleLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRoleLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.deleteRoleLoading()';
}


}




/// @nodoc


class _DeleteRoleSuccess implements RolesAndSecurityState {
  const _DeleteRoleSuccess(this.response);
  

 final  RoleActionResponse response;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteRoleSuccessCopyWith<_DeleteRoleSuccess> get copyWith => __$DeleteRoleSuccessCopyWithImpl<_DeleteRoleSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRoleSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'RolesAndSecurityState.deleteRoleSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$DeleteRoleSuccessCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$DeleteRoleSuccessCopyWith(_DeleteRoleSuccess value, $Res Function(_DeleteRoleSuccess) _then) = __$DeleteRoleSuccessCopyWithImpl;
@useResult
$Res call({
 RoleActionResponse response
});




}
/// @nodoc
class __$DeleteRoleSuccessCopyWithImpl<$Res>
    implements _$DeleteRoleSuccessCopyWith<$Res> {
  __$DeleteRoleSuccessCopyWithImpl(this._self, this._then);

  final _DeleteRoleSuccess _self;
  final $Res Function(_DeleteRoleSuccess) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_DeleteRoleSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as RoleActionResponse,
  ));
}


}

/// @nodoc


class _DeleteRoleError implements RolesAndSecurityState {
  const _DeleteRoleError({required this.error});
  

 final  String error;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteRoleErrorCopyWith<_DeleteRoleError> get copyWith => __$DeleteRoleErrorCopyWithImpl<_DeleteRoleError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteRoleError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RolesAndSecurityState.deleteRoleError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$DeleteRoleErrorCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$DeleteRoleErrorCopyWith(_DeleteRoleError value, $Res Function(_DeleteRoleError) _then) = __$DeleteRoleErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$DeleteRoleErrorCopyWithImpl<$Res>
    implements _$DeleteRoleErrorCopyWith<$Res> {
  __$DeleteRoleErrorCopyWithImpl(this._self, this._then);

  final _DeleteRoleError _self;
  final $Res Function(_DeleteRoleError) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_DeleteRoleError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AssignRoleLoading implements RolesAndSecurityState {
  const _AssignRoleLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignRoleLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.assignRoleLoading()';
}


}




/// @nodoc


class _AssignRoleSuccess implements RolesAndSecurityState {
  const _AssignRoleSuccess(this.response);
  

 final  RoleActionResponse response;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignRoleSuccessCopyWith<_AssignRoleSuccess> get copyWith => __$AssignRoleSuccessCopyWithImpl<_AssignRoleSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignRoleSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'RolesAndSecurityState.assignRoleSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$AssignRoleSuccessCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$AssignRoleSuccessCopyWith(_AssignRoleSuccess value, $Res Function(_AssignRoleSuccess) _then) = __$AssignRoleSuccessCopyWithImpl;
@useResult
$Res call({
 RoleActionResponse response
});




}
/// @nodoc
class __$AssignRoleSuccessCopyWithImpl<$Res>
    implements _$AssignRoleSuccessCopyWith<$Res> {
  __$AssignRoleSuccessCopyWithImpl(this._self, this._then);

  final _AssignRoleSuccess _self;
  final $Res Function(_AssignRoleSuccess) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_AssignRoleSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as RoleActionResponse,
  ));
}


}

/// @nodoc


class _AssignRoleError implements RolesAndSecurityState {
  const _AssignRoleError({required this.error});
  

 final  String error;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignRoleErrorCopyWith<_AssignRoleError> get copyWith => __$AssignRoleErrorCopyWithImpl<_AssignRoleError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignRoleError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RolesAndSecurityState.assignRoleError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$AssignRoleErrorCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$AssignRoleErrorCopyWith(_AssignRoleError value, $Res Function(_AssignRoleError) _then) = __$AssignRoleErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$AssignRoleErrorCopyWithImpl<$Res>
    implements _$AssignRoleErrorCopyWith<$Res> {
  __$AssignRoleErrorCopyWithImpl(this._self, this._then);

  final _AssignRoleError _self;
  final $Res Function(_AssignRoleError) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_AssignRoleError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RemoveRoleLoading implements RolesAndSecurityState {
  const _RemoveRoleLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveRoleLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.removeRoleLoading()';
}


}




/// @nodoc


class _RemoveRoleSuccess implements RolesAndSecurityState {
  const _RemoveRoleSuccess(this.response);
  

 final  RoleActionResponse response;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveRoleSuccessCopyWith<_RemoveRoleSuccess> get copyWith => __$RemoveRoleSuccessCopyWithImpl<_RemoveRoleSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveRoleSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'RolesAndSecurityState.removeRoleSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$RemoveRoleSuccessCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$RemoveRoleSuccessCopyWith(_RemoveRoleSuccess value, $Res Function(_RemoveRoleSuccess) _then) = __$RemoveRoleSuccessCopyWithImpl;
@useResult
$Res call({
 RoleActionResponse response
});




}
/// @nodoc
class __$RemoveRoleSuccessCopyWithImpl<$Res>
    implements _$RemoveRoleSuccessCopyWith<$Res> {
  __$RemoveRoleSuccessCopyWithImpl(this._self, this._then);

  final _RemoveRoleSuccess _self;
  final $Res Function(_RemoveRoleSuccess) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_RemoveRoleSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as RoleActionResponse,
  ));
}


}

/// @nodoc


class _RemoveRoleError implements RolesAndSecurityState {
  const _RemoveRoleError({required this.error});
  

 final  String error;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveRoleErrorCopyWith<_RemoveRoleError> get copyWith => __$RemoveRoleErrorCopyWithImpl<_RemoveRoleError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveRoleError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RolesAndSecurityState.removeRoleError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoveRoleErrorCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$RemoveRoleErrorCopyWith(_RemoveRoleError value, $Res Function(_RemoveRoleError) _then) = __$RemoveRoleErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$RemoveRoleErrorCopyWithImpl<$Res>
    implements _$RemoveRoleErrorCopyWith<$Res> {
  __$RemoveRoleErrorCopyWithImpl(this._self, this._then);

  final _RemoveRoleError _self;
  final $Res Function(_RemoveRoleError) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_RemoveRoleError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SecurityPolicyUpdateLoading implements RolesAndSecurityState {
  const _SecurityPolicyUpdateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityPolicyUpdateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RolesAndSecurityState.securityPolicyUpdateLoading()';
}


}




/// @nodoc


class _SecurityPolicyUpdateSuccess implements RolesAndSecurityState {
  const _SecurityPolicyUpdateSuccess(this.response);
  

 final  SecurityPolicyResponse response;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityPolicyUpdateSuccessCopyWith<_SecurityPolicyUpdateSuccess> get copyWith => __$SecurityPolicyUpdateSuccessCopyWithImpl<_SecurityPolicyUpdateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityPolicyUpdateSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'RolesAndSecurityState.securityPolicyUpdateSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$SecurityPolicyUpdateSuccessCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$SecurityPolicyUpdateSuccessCopyWith(_SecurityPolicyUpdateSuccess value, $Res Function(_SecurityPolicyUpdateSuccess) _then) = __$SecurityPolicyUpdateSuccessCopyWithImpl;
@useResult
$Res call({
 SecurityPolicyResponse response
});




}
/// @nodoc
class __$SecurityPolicyUpdateSuccessCopyWithImpl<$Res>
    implements _$SecurityPolicyUpdateSuccessCopyWith<$Res> {
  __$SecurityPolicyUpdateSuccessCopyWithImpl(this._self, this._then);

  final _SecurityPolicyUpdateSuccess _self;
  final $Res Function(_SecurityPolicyUpdateSuccess) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_SecurityPolicyUpdateSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as SecurityPolicyResponse,
  ));
}


}

/// @nodoc


class _SecurityPolicyUpdateError implements RolesAndSecurityState {
  const _SecurityPolicyUpdateError({required this.error});
  

 final  String error;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityPolicyUpdateErrorCopyWith<_SecurityPolicyUpdateError> get copyWith => __$SecurityPolicyUpdateErrorCopyWithImpl<_SecurityPolicyUpdateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityPolicyUpdateError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RolesAndSecurityState.securityPolicyUpdateError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$SecurityPolicyUpdateErrorCopyWith<$Res> implements $RolesAndSecurityStateCopyWith<$Res> {
  factory _$SecurityPolicyUpdateErrorCopyWith(_SecurityPolicyUpdateError value, $Res Function(_SecurityPolicyUpdateError) _then) = __$SecurityPolicyUpdateErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$SecurityPolicyUpdateErrorCopyWithImpl<$Res>
    implements _$SecurityPolicyUpdateErrorCopyWith<$Res> {
  __$SecurityPolicyUpdateErrorCopyWithImpl(this._self, this._then);

  final _SecurityPolicyUpdateError _self;
  final $Res Function(_SecurityPolicyUpdateError) _then;

/// Create a copy of RolesAndSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_SecurityPolicyUpdateError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
