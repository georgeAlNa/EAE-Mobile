// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_bank_and_categories_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestionBankAndCategoriesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionBankAndCategoriesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestionBankAndCategoriesState()';
}


}

/// @nodoc
class $QuestionBankAndCategoriesStateCopyWith<$Res>  {
$QuestionBankAndCategoriesStateCopyWith(QuestionBankAndCategoriesState _, $Res Function(QuestionBankAndCategoriesState) __);
}


/// Adds pattern-matching-related methods to [QuestionBankAndCategoriesState].
extension QuestionBankAndCategoriesStatePatterns on QuestionBankAndCategoriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _CategorySaved value)?  categorySaved,TResult Function( _QuestionSaved value)?  questionSaved,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _CategorySaved() when categorySaved != null:
return categorySaved(_that);case _QuestionSaved() when questionSaved != null:
return questionSaved(_that);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _CategorySaved value)  categorySaved,required TResult Function( _QuestionSaved value)  questionSaved,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _CategorySaved():
return categorySaved(_that);case _QuestionSaved():
return questionSaved(_that);case _ActionSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _CategorySaved value)?  categorySaved,TResult? Function( _QuestionSaved value)?  questionSaved,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _CategorySaved() when categorySaved != null:
return categorySaved(_that);case _QuestionSaved() when questionSaved != null:
return questionSaved(_that);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( CategoriesTreeResponse categoriesResponse,  QuestionsResponse questionsResponse)?  loaded,TResult Function( CategoryMutationResponse response)?  categorySaved,TResult Function( QuestionDetailsResponse response)?  questionSaved,TResult Function( QuestionBankActionResponse response)?  actionSuccess,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.categoriesResponse,_that.questionsResponse);case _CategorySaved() when categorySaved != null:
return categorySaved(_that.response);case _QuestionSaved() when questionSaved != null:
return questionSaved(_that.response);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( CategoriesTreeResponse categoriesResponse,  QuestionsResponse questionsResponse)  loaded,required TResult Function( CategoryMutationResponse response)  categorySaved,required TResult Function( QuestionDetailsResponse response)  questionSaved,required TResult Function( QuestionBankActionResponse response)  actionSuccess,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.categoriesResponse,_that.questionsResponse);case _CategorySaved():
return categorySaved(_that.response);case _QuestionSaved():
return questionSaved(_that.response);case _ActionSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( CategoriesTreeResponse categoriesResponse,  QuestionsResponse questionsResponse)?  loaded,TResult? Function( CategoryMutationResponse response)?  categorySaved,TResult? Function( QuestionDetailsResponse response)?  questionSaved,TResult? Function( QuestionBankActionResponse response)?  actionSuccess,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.categoriesResponse,_that.questionsResponse);case _CategorySaved() when categorySaved != null:
return categorySaved(_that.response);case _QuestionSaved() when questionSaved != null:
return questionSaved(_that.response);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.response);case _Error() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements QuestionBankAndCategoriesState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestionBankAndCategoriesState.initial()';
}


}




/// @nodoc


class _Loading implements QuestionBankAndCategoriesState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuestionBankAndCategoriesState.loading()';
}


}




/// @nodoc


class _Loaded implements QuestionBankAndCategoriesState {
  const _Loaded({required this.categoriesResponse, required this.questionsResponse});
  

 final  CategoriesTreeResponse categoriesResponse;
 final  QuestionsResponse questionsResponse;

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.categoriesResponse, categoriesResponse) || other.categoriesResponse == categoriesResponse)&&(identical(other.questionsResponse, questionsResponse) || other.questionsResponse == questionsResponse));
}


@override
int get hashCode => Object.hash(runtimeType,categoriesResponse,questionsResponse);

@override
String toString() {
  return 'QuestionBankAndCategoriesState.loaded(categoriesResponse: $categoriesResponse, questionsResponse: $questionsResponse)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $QuestionBankAndCategoriesStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 CategoriesTreeResponse categoriesResponse, QuestionsResponse questionsResponse
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoriesResponse = null,Object? questionsResponse = null,}) {
  return _then(_Loaded(
categoriesResponse: null == categoriesResponse ? _self.categoriesResponse : categoriesResponse // ignore: cast_nullable_to_non_nullable
as CategoriesTreeResponse,questionsResponse: null == questionsResponse ? _self.questionsResponse : questionsResponse // ignore: cast_nullable_to_non_nullable
as QuestionsResponse,
  ));
}


}

/// @nodoc


class _CategorySaved implements QuestionBankAndCategoriesState {
  const _CategorySaved(this.response);
  

 final  CategoryMutationResponse response;

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySavedCopyWith<_CategorySaved> get copyWith => __$CategorySavedCopyWithImpl<_CategorySaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySaved&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'QuestionBankAndCategoriesState.categorySaved(response: $response)';
}


}

/// @nodoc
abstract mixin class _$CategorySavedCopyWith<$Res> implements $QuestionBankAndCategoriesStateCopyWith<$Res> {
  factory _$CategorySavedCopyWith(_CategorySaved value, $Res Function(_CategorySaved) _then) = __$CategorySavedCopyWithImpl;
@useResult
$Res call({
 CategoryMutationResponse response
});




}
/// @nodoc
class __$CategorySavedCopyWithImpl<$Res>
    implements _$CategorySavedCopyWith<$Res> {
  __$CategorySavedCopyWithImpl(this._self, this._then);

  final _CategorySaved _self;
  final $Res Function(_CategorySaved) _then;

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_CategorySaved(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as CategoryMutationResponse,
  ));
}


}

/// @nodoc


class _QuestionSaved implements QuestionBankAndCategoriesState {
  const _QuestionSaved(this.response);
  

 final  QuestionDetailsResponse response;

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionSavedCopyWith<_QuestionSaved> get copyWith => __$QuestionSavedCopyWithImpl<_QuestionSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionSaved&&(identical(other.response, response) || other.response == response));
}


@override
int get hashCode => Object.hash(runtimeType,response);

@override
String toString() {
  return 'QuestionBankAndCategoriesState.questionSaved(response: $response)';
}


}

/// @nodoc
abstract mixin class _$QuestionSavedCopyWith<$Res> implements $QuestionBankAndCategoriesStateCopyWith<$Res> {
  factory _$QuestionSavedCopyWith(_QuestionSaved value, $Res Function(_QuestionSaved) _then) = __$QuestionSavedCopyWithImpl;
@useResult
$Res call({
 QuestionDetailsResponse response
});




}
/// @nodoc
class __$QuestionSavedCopyWithImpl<$Res>
    implements _$QuestionSavedCopyWith<$Res> {
  __$QuestionSavedCopyWithImpl(this._self, this._then);

  final _QuestionSaved _self;
  final $Res Function(_QuestionSaved) _then;

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_QuestionSaved(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as QuestionDetailsResponse,
  ));
}


}

/// @nodoc


class _ActionSuccess implements QuestionBankAndCategoriesState {
  const _ActionSuccess(this.response);
  

 final  QuestionBankActionResponse response;

/// Create a copy of QuestionBankAndCategoriesState
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
  return 'QuestionBankAndCategoriesState.actionSuccess(response: $response)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $QuestionBankAndCategoriesStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 QuestionBankActionResponse response
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? response = null,}) {
  return _then(_ActionSuccess(
null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as QuestionBankActionResponse,
  ));
}


}

/// @nodoc


class _Error implements QuestionBankAndCategoriesState {
  const _Error({required this.error});
  

 final  String error;

/// Create a copy of QuestionBankAndCategoriesState
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
  return 'QuestionBankAndCategoriesState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $QuestionBankAndCategoriesStateCopyWith<$Res> {
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

/// Create a copy of QuestionBankAndCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
