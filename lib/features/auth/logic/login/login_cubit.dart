import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/login/login_request_body.dart';
import '../../data/models/login/login_response.dart';
import '../../data/repos/auth_repo.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit({required this.authRepo}) : super(const LoginState.initial()) {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.addListener(_handleEmailChanged);
    passwordController.addListener(_handlePasswordChanged);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  bool _isSyncingController = false;
  Timer? _rateLimitTimer;

  void _handleEmailChanged() {
    if (_isSyncingController) return;
    updateEmail(emailController.text);
  }

  void _handlePasswordChanged() {
    if (_isSyncingController) return;
    updatePassword(passwordController.text);
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) return;

    _isSyncingController = true;
    controller
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
    _isSyncingController = false;
  }

  void updateEmail(String value) {
    _syncController(emailController, value);
    if (state is Loading || state is RateLimited) return;
    emit(const LoginState.initial());
  }

  void updatePassword(String value) {
    _syncController(passwordController, value);
    if (state is Loading || state is RateLimited) return;
    emit(const LoginState.initial());
  }

  Future<void> submit() async {
    // Block submission during rate limiting
    if (state is RateLimited) return;

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      emit(
        const LoginState.error(
          error: 'Please enter your corporate credentials',
        ),
      );
      return;
    }

    emit(const LoginState.loading());

    try {
      final response = await authRepo.login(
        LoginRequestBody(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      emit(LoginState.success(response));
    } on NetworkExceptions catch (e) {
      if (e is TooManyAttempts) {
        _startRateLimitCountdown(e.retryAfterSeconds);
      } else {
        emit(LoginState.error(error: NetworkExceptions.getErrorMessage(e)));
      }
    } catch (e) {
      emit(LoginState.error(error: 'Failed to login, please try again'));
    }
  }

  void _startRateLimitCountdown(int seconds) {
    _rateLimitTimer?.cancel();

    int remaining = seconds;
    emit(LoginState.rateLimited(remainingSeconds: remaining));

    _rateLimitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      if (remaining <= 0) {
        timer.cancel();
        _rateLimitTimer = null;
        emit(const LoginState.initial());
      } else {
        emit(LoginState.rateLimited(remainingSeconds: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _rateLimitTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
