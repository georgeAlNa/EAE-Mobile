import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../../core/helpers/spacing.dart';
import '../../../data/models/assessment_session_models.dart';

class AssessmentSessionFileUploadCard extends StatelessWidget {
  final AssessmentSessionQuestion question;
  final VoidCallback onPickFile;

  const AssessmentSessionFileUploadCard({
    super.key,
    required this.question,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    if (question.type != AssessmentSessionQuestionType.fileUpload &&
        !question.canAttachEvidence) {
      return const SizedBox.shrink();
    }

    final isUnsupportedFileUpload =
        question.type == AssessmentSessionQuestionType.fileUpload;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.supportingDocumentation.toUpperCase(),
          style: AppTextStyles.font11DarkGreyLight.copyWith(
            color: AppColors.primaryColor9,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpace(12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor5,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.tertiaryColor2),
          ),
          child: Column(
            children: [
              Icon(
                Icons.upload_file_rounded,
                size: 40.sp,
                color: AppColors.tertiaryColor4,
              ),
              verticalSpace(12),
              Text(
                AppStrings.uploadPrompt,
                style: AppTextStyles.font14DarkGreyRegular.copyWith(
                  color: AppColors.primaryColor9,
                ),
              ),
              verticalSpace(6),
              Text(
                question.evidenceHint.isEmpty
                    ? AppStrings.uploadHint
                    : question.evidenceHint,
                textAlign: TextAlign.center,
                style: AppTextStyles.font11DarkGreyLight.copyWith(
                  color: AppColors.tertiaryColor5,
                ),
              ),
              if (question.uploadedFileName != null) ...[
                verticalSpace(12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutralColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.tertiaryColor2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        size: 18.sp,
                        color: AppColors.secondaryColor7,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          question.uploadedFileName!,
                          style: AppTextStyles.font11DarkGreyLight.copyWith(
                            color: AppColors.primaryColor9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              verticalSpace(14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isUnsupportedFileUpload ? null : onPickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor10,
                    foregroundColor: AppColors.neutralColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  icon: const Icon(Icons.attach_file_rounded),
                  label: Text(
                    isUnsupportedFileUpload
                        ? 'Upload unavailable'
                        : question.uploadedFileName == null
                        ? 'Choose File'
                        : 'Replace File',
                    style: AppTextStyles.font12WhiteSemiBold.copyWith(
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
