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
import '../../logic/register/register_cubit.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_status_bar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) =>
          current.maybeWhen(success: (_) => true, orElse: () => false),
      listener: (context, state) {
        context.pushNamedAndRemoveUntil(
          Routes.assessmentInventoryScreen,
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
                const _RegisterCard(),
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

class _RegisterCard extends StatelessWidget {
  const _RegisterCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
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
                      Icons.how_to_reg_outlined,
                      color: AppColors.secondaryColor7,
                      size: 20.sp,
                    ),
                    horizontalSpace(8),
                    Expanded(
                      child: Text(
                        AppStrings.acceptInvite,
                        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                          color: AppColors.primaryColor9,
                        ),
                      ),
                    ),
                  ],
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
                  validationType: InputValidationType.email,
                ),
                verticalSpace(14),
                Text(
                  AppStrings.inviteToken,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(8),
                TextFieldWidget(
                  controller: cubit.tokenController,
                  hintText: AppStrings.inviteTokenHint,
                  labelText: AppStrings.inviteToken,
                  obscureText: false,
                  prefixIcon: Icons.key_outlined,
                  prefixIconColor: AppColors.tertiaryColor6,
                  inputColor: AppColors.primaryColor9,
                  validationType: InputValidationType.none,
                ),
                verticalSpace(14),
                Text(
                  AppStrings.password,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
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
                Text(
                  AppStrings.confirmPassword,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
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
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            AbsorbPointer(
                              child: ButtonWidget(
                                title: AppStrings.acceptInvite,
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
                      : ButtonWidget(
                          title: AppStrings.acceptInvite,
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
