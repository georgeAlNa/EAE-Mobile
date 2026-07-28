import 'package:eae_mobile/core/helpers/input_validation_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/public_widgets/button_widget.dart';
import '../../../../core/public_widgets/text_field_widget.dart';
import '../../../../core/routing/routes.dart';
import '../../logic/reset_password/reset_password_cubit.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_status_bar.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listenWhen: (previous, current) =>
          current.maybeWhen(success: (_) => true, orElse: () => false),
      listener: (context, state) {
        context.pushNamedAndRemoveUntil(
          Routes.loginScreen,
          predicate: (_) => false,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHero(),
                verticalSpace(24),
                const _ResetPasswordCard(),
                verticalSpace(18),
                const LoginFooter(),
                verticalSpace(20),
                const LoginStatusBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordCard extends StatelessWidget {
  const _ResetPasswordCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ResetPasswordCubit>();
        final isSubmitting = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final errorMessage = state.maybeWhen(
          error: (error) => error,
          orElse: () => null,
        );

        return Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: AppColors.neutralColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.tertiaryColor2),
            boxShadow: [
              BoxShadow(
                color: AppColors.tertiaryColor2.withValues(alpha: 0.35),
                blurRadius: 24.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Form(
            key: cubit.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: cubit.updateForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.password_outlined,
                      color: AppColors.secondaryColor7,
                      size: 20.sp,
                    ),
                    horizontalSpace(8),
                    Expanded(
                      child: Text(
                        'Create New Password',
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(16),
                _FieldLabel(label: AppStrings.workEmail),
                verticalSpace(8),
                TextFieldWidget(
                  controller: cubit.emailController,
                  hintText: AppStrings.workEmailHint,
                  labelText: AppStrings.workEmail,
                  obscureText: false,
                  prefixIcon: Icons.mail_outline,
                  prefixIconColor: AppColors.tertiaryColor6,
                  inputColor: AppColors.primaryColor9,
                  keyboardType: TextInputType.emailAddress,
                  validationType: InputValidationType.email,
                ),
                verticalSpace(14),
                const _FieldLabel(label: 'Reset Token'),
                verticalSpace(8),
                TextFieldWidget(
                  controller: cubit.tokenController,
                  hintText: 'Paste reset token',
                  labelText: 'Reset Token',
                  obscureText: false,
                  prefixIcon: Icons.key_outlined,
                  prefixIconColor: AppColors.tertiaryColor6,
                  inputColor: AppColors.primaryColor9,
                  validationType: InputValidationType.none,
                ),
                verticalSpace(14),
                _FieldLabel(label: AppStrings.password),
                verticalSpace(8),
                TextFieldWidget(
                  controller: cubit.passwordController,
                  hintText: AppStrings.passwordHint,
                  labelText: AppStrings.password,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  prefixIconColor: AppColors.tertiaryColor6,
                  inputColor: AppColors.primaryColor9,
                  validationType: InputValidationType.password,
                ),
                verticalSpace(14),
                _FieldLabel(label: AppStrings.confirmPassword),
                verticalSpace(8),
                TextFieldWidget(
                  controller: cubit.passwordConfirmationController,
                  hintText: AppStrings.confirmPasswordHint,
                  labelText: AppStrings.confirmPassword,
                  obscureText: true,
                  prefixIcon: Icons.lock_reset_outlined,
                  prefixIconColor: AppColors.tertiaryColor6,
                  inputColor: AppColors.primaryColor9,
                  validationType: InputValidationType.password,
                ),
                if (errorMessage != null) ...[
                  verticalSpace(8),
                  Text(
                    errorMessage,
                    style: AppTextStyles.font11OrangeLowInStockSemiBold,
                  ),
                ],
                verticalSpace(18),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: isSubmitting
                      ? const _LoadingButton(label: 'Reset Password')
                      : ButtonWidget(
                          title: 'Reset Password',
                          onTap: cubit.submit,
                          width: double.infinity,
                          height: 52.h,
                          radius: 12.r,
                          backgroundColor: AppColors.neutralColor,
                          borderColor: AppColors.primaryColor8,
                          textStyle: AppTextStyles.font14DarkGreySemiBold
                              .copyWith(color: AppColors.primaryColor9),
                        ),
                ),
                verticalSpace(14),
                Center(
                  child: TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () => context.pushNamedAndRemoveUntil(
                            Routes.loginScreen,
                            predicate: (_) => false,
                          ),
                    child: Text(
                      AppStrings.backToSignIn,
                      style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                        color: AppColors.secondaryColor7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.font12DarkGreySemiBold.copyWith(
        color: AppColors.primaryColor9,
      ),
    );
  }
}

class _LoadingButton extends StatelessWidget {
  final String label;

  const _LoadingButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AbsorbPointer(
          child: ButtonWidget(
            title: label,
            onTap: () {},
            width: double.infinity,
            height: 52.h,
            radius: 12.r,
            backgroundColor: AppColors.neutralColor,
            borderColor: AppColors.primaryColor8,
            textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
          height: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor6,
          ),
        ),
      ],
    );
  }
}
