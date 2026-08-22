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
import '../../logic/login/login_cubit.dart';

String _formatSeconds(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  if (minutes > 0) {
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }
  return '${seconds}s';
}

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isSubmitting = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final errorMessage = state.maybeWhen(
          error: (error) => error,
          orElse: () => null,
        );
        final isRateLimited = state is RateLimited;
        final rateLimitedSeconds = isRateLimited ? state.remainingSeconds : 0;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.workEmail,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(8),
                TextFieldWidget(
                  key: const Key('login_email_field'),
                  controller: cubit.emailController,
                  hintText: AppStrings.workEmailHint,
                  labelText: AppStrings.workEmail,
                  obscureText: false,
                  prefixIcon: Icons.mail_outline,
                  prefixIconColor: AppColors.tertiaryColor6,
                  inputColor: AppColors.primaryColor9,
                  // validationType: InputValidationType.email,
                ),
                verticalSpace(14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppStrings.password,
                        style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (isSubmitting || isRateLimited)
                          ? null
                          : () =>
                                context.pushNamed(Routes.forgotPasswordScreen),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.h,
                        ),
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                            color: AppColors.secondaryColor7,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(8),
                TextFieldWidget(
                  key: const Key('login_password_field'),
                  controller: cubit.passwordController,
                  hintText: AppStrings.passwordHint,
                  labelText: AppStrings.password,
                  obscureText: true,
                  enablePasswordVisibilityToggle: true,
                  prefixIcon: Icons.lock_outline,
                  prefixIconColor: AppColors.tertiaryColor6,
                  inputColor: AppColors.primaryColor9,
                  // validationType: InputValidationType.password,
                ),
                if (errorMessage != null) ...[
                  verticalSpace(8),
                  Text(
                    errorMessage,
                    style: AppTextStyles.font11OrangeLowInStockSemiBold,
                  ),
                ],
                if (isRateLimited) ...[
                  verticalSpace(8),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_clock_outlined,
                        size: 14.sp,
                        color: AppColors.secondaryColor7,
                      ),
                      horizontalSpace(6),
                      Expanded(
                        child: Text(
                          'Too many attempts. Try again in ${_formatSeconds(rateLimitedSeconds)}',
                          style: AppTextStyles.font11OrangeLowInStockSemiBold
                              .copyWith(color: AppColors.secondaryColor7),
                        ),
                      ),
                    ],
                  ),
                ],
                verticalSpace(18),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: isSubmitting
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AbsorbPointer(
                              child: ButtonWidget(
                                key: const Key('login_submit_button'),
                                title: AppStrings.enterpriseSignIn,
                                onTap: () {},
                                width: double.infinity,
                                height: 52.h,
                                radius: 12.r,
                                backgroundColor: AppColors.neutralColor,
                                borderColor: AppColors.primaryColor8,
                                textStyle: AppTextStyles.font14DarkGreySemiBold
                                    .copyWith(color: AppColors.primaryColor9),
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
                        )
                      : isRateLimited
                      ? AbsorbPointer(
                          child: ButtonWidget(
                            key: const Key('login_submit_button'),
                            title:
                                'Retry in ${_formatSeconds(rateLimitedSeconds)}',
                            onTap: () {},
                            width: double.infinity,
                            height: 52.h,
                            radius: 12.r,
                            backgroundColor: AppColors.tertiaryColor2
                                .withValues(alpha: 0.6),
                            borderColor: AppColors.tertiaryColor2,
                            textStyle: AppTextStyles.font14DarkGreySemiBold
                                .copyWith(color: AppColors.tertiaryColor6),
                          ),
                        )
                      : ButtonWidget(
                          key: const Key('login_submit_button'),
                          title: AppStrings.enterpriseSignIn,
                          onTap: () => cubit.submit(),
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
                    onPressed: (isSubmitting || isRateLimited)
                        ? null
                        : () => context.pushNamed(Routes.registerScreen),
                    child: Text(
                      '${AppStrings.haveInvite} ${AppStrings.acceptInvite}',
                      style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                        color: AppColors.secondaryColor7,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: (isSubmitting || isRateLimited)
                        ? null
                        : () => context.pushNamedAndRemoveUntil(
                            Routes.roleSelectionScreen,
                            predicate: (_) => false,
                          ),
                    child: Text(
                      AppStrings.tr('Change access role'),
                      style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                        color: AppColors.tertiaryColor7,
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
