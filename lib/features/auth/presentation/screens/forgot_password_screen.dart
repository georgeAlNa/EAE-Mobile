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
import '../../logic/forgot_password/forgot_password_cubit.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_status_bar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) =>
          current.maybeWhen(success: (_) => true, orElse: () => false),
      listener: (context, state) {
        final email = context
            .read<ForgotPasswordCubit>()
            .emailController
            .text
            .trim();

        context.pushNamed(Routes.resetPasswordScreen, arguments: email);
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
                const _ForgotPasswordCard(),
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

class _ForgotPasswordCard extends StatelessWidget {
  const _ForgotPasswordCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final cubit = context.read<ForgotPasswordCubit>();
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
                      Icons.lock_reset_outlined,
                      color: AppColors.secondaryColor7,
                      size: 20.sp,
                    ),
                    horizontalSpace(8),
                    Expanded(
                      child: Text(
                        'Reset Access',
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(10),
                Text(
                  'Enter your work email. If the account exists, a reset link will be sent.',
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.45,
                  ),
                ),
                verticalSpace(16),
                Text(
                  AppStrings.workEmail,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
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
                      ? const _LoadingButton(label: 'Send Reset Link')
                      : ButtonWidget(
                          title: 'Send Reset Link',
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
