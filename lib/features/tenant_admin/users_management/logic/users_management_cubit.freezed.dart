// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_management_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsersManagementState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersManagementState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState()';
}


}

/// @nodoc
class $UsersManagementStateCopyWith<$Res>  {
$UsersManagementStateCopyWith(UsersManagementState _, $Res Function(UsersManagementState) __);
}


/// Adds pattern-matching-related methods to [UsersManagementState].
extension UsersManagementStatePatterns on UsersManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _UsersLoading value)?  usersLoading,TResult Function( _UsersLoaded value)?  usersLoaded,TResult Function( _UsersLoadError value)?  usersLoadError,TResult Function( _UserDetailsLoading value)?  userDetailsLoading,TResult Function( _UserLoaded value)?  userLoaded,TResult Function( _UserDetailsError value)?  userDetailsError,TResult Function( _CreateUserLoading value)?  createUserLoading,TResult Function( _CreateSuccess value)?  createSuccess,TResult Function( _CreateUserError value)?  createUserError,TResult Function( _InviteUserLoading value)?  inviteUserLoading,TResult Function( _InviteSuccess value)?  inviteSuccess,TResult Function( _InviteUserError value)?  inviteUserError,TResult Function( _DeactivateUserLoading value)?  deactivateUserLoading,TResult Function( _DeactivateSuccess value)?  deactivateSuccess,TResult Function( _DeactivateUserError value)?  deactivateUserError,TResult Function( _ResetPasswordLoading value)?  resetPasswordLoading,TResult Function( _ResetPasswordSuccess value)?  resetPasswordSuccess,TResult Function( _ResetPasswordError value)?  resetPasswordError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _UsersLoading() when usersLoading != null:
return usersLoading(_that);case _UsersLoaded() when usersLoaded != null:
return usersLoaded(_that);case _UsersLoadError() when usersLoadError != null:
return usersLoadError(_that);case _UserDetailsLoading() when userDetailsLoading != null:
return userDetailsLoading(_that);case _UserLoaded() when userLoaded != null:
return userLoaded(_that);case _UserDetailsError() when userDetailsError != null:
return userDetailsError(_that);case _CreateUserLoading() when createUserLoading != null:
return createUserLoading(_that);case _CreateSuccess() when createSuccess != null:
return createSuccess(_that);case _CreateUserError() when createUserError != null:
return createUserError(_that);case _InviteUserLoading() when inviteUserLoading != null:
return inviteUserLoading(_that);case _InviteSuccess() when inviteSuccess != null:
return inviteSuccess(_that);case _InviteUserError() when inviteUserError != null:
return inviteUserError(_that);case _DeactivateUserLoading() when deactivateUserLoading != null:
return deactivateUserLoading(_that);case _DeactivateSuccess() when deactivateSuccess != null:
return deactivateSuccess(_that);case _DeactivateUserError() when deactivateUserError != null:
return deactivateUserError(_that);case _ResetPasswordLoading() when resetPasswordLoading != null:
return resetPasswordLoading(_that);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that);case _ResetPasswordError() when resetPasswordError != null:
return resetPasswordError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _UsersLoading value)  usersLoading,required TResult Function( _UsersLoaded value)  usersLoaded,required TResult Function( _UsersLoadError value)  usersLoadError,required TResult Function( _UserDetailsLoading value)  userDetailsLoading,required TResult Function( _UserLoaded value)  userLoaded,required TResult Function( _UserDetailsError value)  userDetailsError,required TResult Function( _CreateUserLoading value)  createUserLoading,required TResult Function( _CreateSuccess value)  createSuccess,required TResult Function( _CreateUserError value)  createUserError,required TResult Function( _InviteUserLoading value)  inviteUserLoading,required TResult Function( _InviteSuccess value)  inviteSuccess,required TResult Function( _InviteUserError value)  inviteUserError,required TResult Function( _DeactivateUserLoading value)  deactivateUserLoading,required TResult Function( _DeactivateSuccess value)  deactivateSuccess,required TResult Function( _DeactivateUserError value)  deactivateUserError,required TResult Function( _ResetPasswordLoading value)  resetPasswordLoading,required TResult Function( _ResetPasswordSuccess value)  resetPasswordSuccess,required TResult Function( _ResetPasswordError value)  resetPasswordError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _UsersLoading():
return usersLoading(_that);case _UsersLoaded():
return usersLoaded(_that);case _UsersLoadError():
return usersLoadError(_that);case _UserDetailsLoading():
return userDetailsLoading(_that);case _UserLoaded():
return userLoaded(_that);case _UserDetailsError():
return userDetailsError(_that);case _CreateUserLoading():
return createUserLoading(_that);case _CreateSuccess():
return createSuccess(_that);case _CreateUserError():
return createUserError(_that);case _InviteUserLoading():
return inviteUserLoading(_that);case _InviteSuccess():
return inviteSuccess(_that);case _InviteUserError():
return inviteUserError(_that);case _DeactivateUserLoading():
return deactivateUserLoading(_that);case _DeactivateSuccess():
return deactivateSuccess(_that);case _DeactivateUserError():
return deactivateUserError(_that);case _ResetPasswordLoading():
return resetPasswordLoading(_that);case _ResetPasswordSuccess():
return resetPasswordSuccess(_that);case _ResetPasswordError():
return resetPasswordError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _UsersLoading value)?  usersLoading,TResult? Function( _UsersLoaded value)?  usersLoaded,TResult? Function( _UsersLoadError value)?  usersLoadError,TResult? Function( _UserDetailsLoading value)?  userDetailsLoading,TResult? Function( _UserLoaded value)?  userLoaded,TResult? Function( _UserDetailsError value)?  userDetailsError,TResult? Function( _CreateUserLoading value)?  createUserLoading,TResult? Function( _CreateSuccess value)?  createSuccess,TResult? Function( _CreateUserError value)?  createUserError,TResult? Function( _InviteUserLoading value)?  inviteUserLoading,TResult? Function( _InviteSuccess value)?  inviteSuccess,TResult? Function( _InviteUserError value)?  inviteUserError,TResult? Function( _DeactivateUserLoading value)?  deactivateUserLoading,TResult? Function( _DeactivateSuccess value)?  deactivateSuccess,TResult? Function( _DeactivateUserError value)?  deactivateUserError,TResult? Function( _ResetPasswordLoading value)?  resetPasswordLoading,TResult? Function( _ResetPasswordSuccess value)?  resetPasswordSuccess,TResult? Function( _ResetPasswordError value)?  resetPasswordError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _UsersLoading() when usersLoading != null:
return usersLoading(_that);case _UsersLoaded() when usersLoaded != null:
return usersLoaded(_that);case _UsersLoadError() when usersLoadError != null:
return usersLoadError(_that);case _UserDetailsLoading() when userDetailsLoading != null:
return userDetailsLoading(_that);case _UserLoaded() when userLoaded != null:
return userLoaded(_that);case _UserDetailsError() when userDetailsError != null:
return userDetailsError(_that);case _CreateUserLoading() when createUserLoading != null:
return createUserLoading(_that);case _CreateSuccess() when createSuccess != null:
return createSuccess(_that);case _CreateUserError() when createUserError != null:
return createUserError(_that);case _InviteUserLoading() when inviteUserLoading != null:
return inviteUserLoading(_that);case _InviteSuccess() when inviteSuccess != null:
return inviteSuccess(_that);case _InviteUserError() when inviteUserError != null:
return inviteUserError(_that);case _DeactivateUserLoading() when deactivateUserLoading != null:
return deactivateUserLoading(_that);case _DeactivateSuccess() when deactivateSuccess != null:
return deactivateSuccess(_that);case _DeactivateUserError() when deactivateUserError != null:
return deactivateUserError(_that);case _ResetPasswordLoading() when resetPasswordLoading != null:
return resetPasswordLoading(_that);case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that);case _ResetPasswordError() when resetPasswordError != null:
return resetPasswordError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  usersLoading,TResult Function( UsersManagementResponse response)?  usersLoaded,TResult Function( String error)?  usersLoadError,TResult Function()?  userDetailsLoading,TResult Function( UserDetailsResponse response)?  userLoaded,TResult Function( String error)?  userDetailsError,TResult Function()?  createUserLoading,TResult Function( CreateUserResponse response)?  createSuccess,TResult Function( String error)?  createUserError,TResult Function()?  inviteUserLoading,TResult Function( InviteUserResponse response)?  inviteSuccess,TResult Function( String error)?  inviteUserError,TResult Function()?  deactivateUserLoading,TResult Function( UserActionResponse response)?  deactivateSuccess,TResult Function( String error)?  deactivateUserError,TResult Function()?  resetPasswordLoading,TResult Function( UserActionResponse response)?  resetPasswordSuccess,TResult Function( String error)?  resetPasswordError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _UsersLoading() when usersLoading != null:
return usersLoading();case _UsersLoaded() when usersLoaded != null:
return usersLoaded(_that.response);case _UsersLoadError() when usersLoadError != null:
return usersLoadError(_that.error);case _UserDetailsLoading() when userDetailsLoading != null:
return userDetailsLoading();case _UserLoaded() when userLoaded != null:
return userLoaded(_that.response);case _UserDetailsError() when userDetailsError != null:
return userDetailsError(_that.error);case _CreateUserLoading() when createUserLoading != null:
return createUserLoading();case _CreateSuccess() when createSuccess != null:
return createSuccess(_that.response);case _CreateUserError() when createUserError != null:
return createUserError(_that.error);case _InviteUserLoading() when inviteUserLoading != null:
return inviteUserLoading();case _InviteSuccess() when inviteSuccess != null:
return inviteSuccess(_that.response);case _InviteUserError() when inviteUserError != null:
return inviteUserError(_that.error);case _DeactivateUserLoading() when deactivateUserLoading != null:
return deactivateUserLoading();case _DeactivateSuccess() when deactivateSuccess != null:
return deactivateSuccess(_that.response);case _DeactivateUserError() when deactivateUserError != null:
return deactivateUserError(_that.error);case _ResetPasswordLoading() when resetPasswordLoading != null:
return resetPasswordLoading();case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that.response);case _ResetPasswordError() when resetPasswordError != null:
return resetPasswordError(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  usersLoading,required TResult Function( UsersManagementResponse response)  usersLoaded,required TResult Function( String error)  usersLoadError,required TResult Function()  userDetailsLoading,required TResult Function( UserDetailsResponse response)  userLoaded,required TResult Function( String error)  userDetailsError,required TResult Function()  createUserLoading,required TResult Function( CreateUserResponse response)  createSuccess,required TResult Function( String error)  createUserError,required TResult Function()  inviteUserLoading,required TResult Function( InviteUserResponse response)  inviteSuccess,required TResult Function( String error)  inviteUserError,required TResult Function()  deactivateUserLoading,required TResult Function( UserActionResponse response)  deactivateSuccess,required TResult Function( String error)  deactivateUserError,required TResult Function()  resetPasswordLoading,required TResult Function( UserActionResponse response)  resetPasswordSuccess,required TResult Function( String error)  resetPasswordError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _UsersLoading():
return usersLoading();case _UsersLoaded():
return usersLoaded(_that.response);case _UsersLoadError():
return usersLoadError(_that.error);case _UserDetailsLoading():
return userDetailsLoading();case _UserLoaded():
return userLoaded(_that.response);case _UserDetailsError():
return userDetailsError(_that.error);case _CreateUserLoading():
return createUserLoading();case _CreateSuccess():
return createSuccess(_that.response);case _CreateUserError():
return createUserError(_that.error);case _InviteUserLoading():
return inviteUserLoading();case _InviteSuccess():
return inviteSuccess(_that.response);case _InviteUserError():
return inviteUserError(_that.error);case _DeactivateUserLoading():
return deactivateUserLoading();case _DeactivateSuccess():
return deactivateSuccess(_that.response);case _DeactivateUserError():
return deactivateUserError(_that.error);case _ResetPasswordLoading():
return resetPasswordLoading();case _ResetPasswordSuccess():
return resetPasswordSuccess(_that.response);case _ResetPasswordError():
return resetPasswordError(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  usersLoading,TResult? Function( UsersManagementResponse response)?  usersLoaded,TResult? Function( String error)?  usersLoadError,TResult? Function()?  userDetailsLoading,TResult? Function( UserDetailsResponse response)?  userLoaded,TResult? Function( String error)?  userDetailsError,TResult? Function()?  createUserLoading,TResult? Function( CreateUserResponse response)?  createSuccess,TResult? Function( String error)?  createUserError,TResult? Function()?  inviteUserLoading,TResult? Function( InviteUserResponse response)?  inviteSuccess,TResult? Function( String error)?  inviteUserError,TResult? Function()?  deactivateUserLoading,TResult? Function( UserActionResponse response)?  deactivateSuccess,TResult? Function( String error)?  deactivateUserError,TResult? Function()?  resetPasswordLoading,TResult? Function( UserActionResponse response)?  resetPasswordSuccess,TResult? Function( String error)?  resetPasswordError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _UsersLoading() when usersLoading != null:
return usersLoading();case _UsersLoaded() when usersLoaded != null:
return usersLoaded(_that.response);case _UsersLoadError() when usersLoadError != null:
return usersLoadError(_that.error);case _UserDetailsLoading() when userDetailsLoading != null:
return userDetailsLoading();case _UserLoaded() when userLoaded != null:
return userLoaded(_that.response);case _UserDetailsError() when userDetailsError != null:
return userDetailsError(_that.error);case _CreateUserLoading() when createUserLoading != null:
return createUserLoading();case _CreateSuccess() when createSuccess != null:
return createSuccess(_that.response);case _CreateUserError() when createUserError != null:
return createUserError(_that.error);case _InviteUserLoading() when inviteUserLoading != null:
return inviteUserLoading();case _InviteSuccess() when inviteSuccess != null:
return inviteSuccess(_that.response);case _InviteUserError() when inviteUserError != null:
return inviteUserError(_that.error);case _DeactivateUserLoading() when deactivateUserLoading != null:
return deactivateUserLoading();case _DeactivateSuccess() when deactivateSuccess != null:
return deactivateSuccess(_that.response);case _DeactivateUserError() when deactivateUserError != null:
return deactivateUserError(_that.error);case _ResetPasswordLoading() when resetPasswordLoading != null:
return resetPasswordLoading();case _ResetPasswordSuccess() when resetPasswordSuccess != null:
return resetPasswordSuccess(_that.response);case _ResetPasswordError() when resetPasswordError != null:
return resetPasswordError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements UsersManagementState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState.initial()';
}


}




/// @nodoc


class _UsersLoading implements UsersManagementState {
  const _UsersLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState.usersLoading()';
}


}




/// @nodoc


class _UsersLoaded implements UsersManagementState {
  const _UsersLoaded(this.response);
  

 final  UsersManagementResponse response;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersLoadedCopyWith<_UsersLoaded> get copyWith => __$UsersLoadedCopyWithImpl<_UsersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersLoaded&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'UsersManagementState.usersLoaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$UsersLoadedCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$UsersLoadedCopyWith(_UsersLoaded value, $Res Function(_UsersLoaded) _then) = __$UsersLoadedCopyWithImpl;
@useResult
$Res call({
 UsersManagementResponse response
});




}
/// @nodoc
class __$UsersLoadedCopyWithImpl<$Res>
    implements _$UsersLoadedCopyWith<$Res> {
  __$UsersLoadedCopyWithImpl(this._self, this._then);

  final _UsersLoaded _self;
  final $Res Function(_UsersLoaded) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_UsersLoaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UsersManagementResponse,
  ));
}


}

/// @nodoc


class _UsersLoadError implements UsersManagementState {
  const _UsersLoadError({required this.error});
  

 final  String error;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersLoadErrorCopyWith<_UsersLoadError> get copyWith => __$UsersLoadErrorCopyWithImpl<_UsersLoadError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersLoadError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'UsersManagementState.usersLoadError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$UsersLoadErrorCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$UsersLoadErrorCopyWith(_UsersLoadError value, $Res Function(_UsersLoadError) _then) = __$UsersLoadErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$UsersLoadErrorCopyWithImpl<$Res>
    implements _$UsersLoadErrorCopyWith<$Res> {
  __$UsersLoadErrorCopyWithImpl(this._self, this._then);

  final _UsersLoadError _self;
  final $Res Function(_UsersLoadError) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_UsersLoadError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UserDetailsLoading implements UsersManagementState {
  const _UserDetailsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDetailsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState.userDetailsLoading()';
}


}




/// @nodoc


class _UserLoaded implements UsersManagementState {
  const _UserLoaded(this.response);
  

 final  UserDetailsResponse response;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLoadedCopyWith<_UserLoaded> get copyWith => __$UserLoadedCopyWithImpl<_UserLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLoaded&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'UsersManagementState.userLoaded(response: $response)';
}


}

/// @nodoc
abstract mixin class _$UserLoadedCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$UserLoadedCopyWith(_UserLoaded value, $Res Function(_UserLoaded) _then) = __$UserLoadedCopyWithImpl;
@useResult
$Res call({
 UserDetailsResponse response
});




}
/// @nodoc
class __$UserLoadedCopyWithImpl<$Res>
    implements _$UserLoadedCopyWith<$Res> {
  __$UserLoadedCopyWithImpl(this._self, this._then);

  final _UserLoaded _self;
  final $Res Function(_UserLoaded) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_UserLoaded(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UserDetailsResponse,
  ));
}


}

/// @nodoc


class _UserDetailsError implements UsersManagementState {
  const _UserDetailsError({required this.error});
  

 final  String error;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDetailsErrorCopyWith<_UserDetailsError> get copyWith => __$UserDetailsErrorCopyWithImpl<_UserDetailsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDetailsError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'UsersManagementState.userDetailsError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$UserDetailsErrorCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$UserDetailsErrorCopyWith(_UserDetailsError value, $Res Function(_UserDetailsError) _then) = __$UserDetailsErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$UserDetailsErrorCopyWithImpl<$Res>
    implements _$UserDetailsErrorCopyWith<$Res> {
  __$UserDetailsErrorCopyWithImpl(this._self, this._then);

  final _UserDetailsError _self;
  final $Res Function(_UserDetailsError) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_UserDetailsError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CreateUserLoading implements UsersManagementState {
  const _CreateUserLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState.createUserLoading()';
}


}




/// @nodoc


class _CreateSuccess implements UsersManagementState {
  const _CreateSuccess(this.response);
  

 final  CreateUserResponse response;

/// Create a copy of UsersManagementState
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
  return 'UsersManagementState.createSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$CreateSuccessCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$CreateSuccessCopyWith(_CreateSuccess value, $Res Function(_CreateSuccess) _then) = __$CreateSuccessCopyWithImpl;
@useResult
$Res call({
 CreateUserResponse response
});




}
/// @nodoc
class __$CreateSuccessCopyWithImpl<$Res>
    implements _$CreateSuccessCopyWith<$Res> {
  __$CreateSuccessCopyWithImpl(this._self, this._then);

  final _CreateSuccess _self;
  final $Res Function(_CreateSuccess) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_CreateSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CreateUserResponse,
  ));
}


}

/// @nodoc


class _CreateUserError implements UsersManagementState {
  const _CreateUserError({required this.error});
  

 final  String error;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUserErrorCopyWith<_CreateUserError> get copyWith => __$CreateUserErrorCopyWithImpl<_CreateUserError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'UsersManagementState.createUserError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$CreateUserErrorCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$CreateUserErrorCopyWith(_CreateUserError value, $Res Function(_CreateUserError) _then) = __$CreateUserErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$CreateUserErrorCopyWithImpl<$Res>
    implements _$CreateUserErrorCopyWith<$Res> {
  __$CreateUserErrorCopyWithImpl(this._self, this._then);

  final _CreateUserError _self;
  final $Res Function(_CreateUserError) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_CreateUserError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InviteUserLoading implements UsersManagementState {
  const _InviteUserLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteUserLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState.inviteUserLoading()';
}


}




/// @nodoc


class _InviteSuccess implements UsersManagementState {
  const _InviteSuccess(this.response);
  

 final  InviteUserResponse response;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteSuccessCopyWith<_InviteSuccess> get copyWith => __$InviteSuccessCopyWithImpl<_InviteSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'UsersManagementState.inviteSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$InviteSuccessCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$InviteSuccessCopyWith(_InviteSuccess value, $Res Function(_InviteSuccess) _then) = __$InviteSuccessCopyWithImpl;
@useResult
$Res call({
 InviteUserResponse response
});




}
/// @nodoc
class __$InviteSuccessCopyWithImpl<$Res>
    implements _$InviteSuccessCopyWith<$Res> {
  __$InviteSuccessCopyWithImpl(this._self, this._then);

  final _InviteSuccess _self;
  final $Res Function(_InviteSuccess) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_InviteSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as InviteUserResponse,
  ));
}


}

/// @nodoc


class _InviteUserError implements UsersManagementState {
  const _InviteUserError({required this.error});
  

 final  String error;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteUserErrorCopyWith<_InviteUserError> get copyWith => __$InviteUserErrorCopyWithImpl<_InviteUserError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteUserError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'UsersManagementState.inviteUserError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$InviteUserErrorCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$InviteUserErrorCopyWith(_InviteUserError value, $Res Function(_InviteUserError) _then) = __$InviteUserErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$InviteUserErrorCopyWithImpl<$Res>
    implements _$InviteUserErrorCopyWith<$Res> {
  __$InviteUserErrorCopyWithImpl(this._self, this._then);

  final _InviteUserError _self;
  final $Res Function(_InviteUserError) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_InviteUserError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeactivateUserLoading implements UsersManagementState {
  const _DeactivateUserLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeactivateUserLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState.deactivateUserLoading()';
}


}




/// @nodoc


class _DeactivateSuccess implements UsersManagementState {
  const _DeactivateSuccess(this.response);
  

 final  UserActionResponse response;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeactivateSuccessCopyWith<_DeactivateSuccess> get copyWith => __$DeactivateSuccessCopyWithImpl<_DeactivateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeactivateSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'UsersManagementState.deactivateSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$DeactivateSuccessCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$DeactivateSuccessCopyWith(_DeactivateSuccess value, $Res Function(_DeactivateSuccess) _then) = __$DeactivateSuccessCopyWithImpl;
@useResult
$Res call({
 UserActionResponse response
});




}
/// @nodoc
class __$DeactivateSuccessCopyWithImpl<$Res>
    implements _$DeactivateSuccessCopyWith<$Res> {
  __$DeactivateSuccessCopyWithImpl(this._self, this._then);

  final _DeactivateSuccess _self;
  final $Res Function(_DeactivateSuccess) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_DeactivateSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UserActionResponse,
  ));
}


}

/// @nodoc


class _DeactivateUserError implements UsersManagementState {
  const _DeactivateUserError({required this.error});
  

 final  String error;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeactivateUserErrorCopyWith<_DeactivateUserError> get copyWith => __$DeactivateUserErrorCopyWithImpl<_DeactivateUserError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeactivateUserError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'UsersManagementState.deactivateUserError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$DeactivateUserErrorCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$DeactivateUserErrorCopyWith(_DeactivateUserError value, $Res Function(_DeactivateUserError) _then) = __$DeactivateUserErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$DeactivateUserErrorCopyWithImpl<$Res>
    implements _$DeactivateUserErrorCopyWith<$Res> {
  __$DeactivateUserErrorCopyWithImpl(this._self, this._then);

  final _DeactivateUserError _self;
  final $Res Function(_DeactivateUserError) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_DeactivateUserError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ResetPasswordLoading implements UsersManagementState {
  const _ResetPasswordLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UsersManagementState.resetPasswordLoading()';
}


}




/// @nodoc


class _ResetPasswordSuccess implements UsersManagementState {
  const _ResetPasswordSuccess(this.response);
  

 final  UserActionResponse response;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetPasswordSuccessCopyWith<_ResetPasswordSuccess> get copyWith => __$ResetPasswordSuccessCopyWithImpl<_ResetPasswordSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordSuccess&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'UsersManagementState.resetPasswordSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$ResetPasswordSuccessCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$ResetPasswordSuccessCopyWith(_ResetPasswordSuccess value, $Res Function(_ResetPasswordSuccess) _then) = __$ResetPasswordSuccessCopyWithImpl;
@useResult
$Res call({
 UserActionResponse response
});




}
/// @nodoc
class __$ResetPasswordSuccessCopyWithImpl<$Res>
    implements _$ResetPasswordSuccessCopyWith<$Res> {
  __$ResetPasswordSuccessCopyWithImpl(this._self, this._then);

  final _ResetPasswordSuccess _self;
  final $Res Function(_ResetPasswordSuccess) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_ResetPasswordSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UserActionResponse,
  ));
}


}

/// @nodoc


class _ResetPasswordError implements UsersManagementState {
  const _ResetPasswordError({required this.error});
  

 final  String error;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetPasswordErrorCopyWith<_ResetPasswordError> get copyWith => __$ResetPasswordErrorCopyWithImpl<_ResetPasswordError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'UsersManagementState.resetPasswordError(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ResetPasswordErrorCopyWith<$Res> implements $UsersManagementStateCopyWith<$Res> {
  factory _$ResetPasswordErrorCopyWith(_ResetPasswordError value, $Res Function(_ResetPasswordError) _then) = __$ResetPasswordErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$ResetPasswordErrorCopyWithImpl<$Res>
    implements _$ResetPasswordErrorCopyWith<$Res> {
  __$ResetPasswordErrorCopyWithImpl(this._self, this._then);

  final _ResetPasswordError _self;
  final $Res Function(_ResetPasswordError) _then;

/// Create a copy of UsersManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_ResetPasswordError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
