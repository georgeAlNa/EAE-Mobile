import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/live_sessions_and_enrollment_management_request_body.dart';
import '../../logic/live_sessions_and_enrollment_management_cubit.dart';

class CreateEnrollmentSheet extends StatefulWidget {
  final String examId;

  const CreateEnrollmentSheet({super.key, required this.examId});

  @override
  State<CreateEnrollmentSheet> createState() => _CreateEnrollmentSheetState();
}

class _CreateEnrollmentSheetState extends State<CreateEnrollmentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _candidateUserIdController = TextEditingController();
  final _cohortIdController = TextEditingController();
  final _startWindowDateController = TextEditingController(
    text: '2026-06-25T14:03:03',
  );
  final _endWindowDateController = TextEditingController(text: '2052-07-18');
  final _maxAttemptsAllowedController = TextEditingController(text: '2');
  final _enrollmentNotesController = TextEditingController(text: 'g');

  @override
  void dispose() {
    _candidateUserIdController.dispose();
    _cohortIdController.dispose();
    _startWindowDateController.dispose();
    _endWindowDateController.dispose();
    _maxAttemptsAllowedController.dispose();
    _enrollmentNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Create enrollment',
      subtitle: 'Enroll a candidate into the selected exam.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _candidateUserIdController,
              hintText: 'candidate user UUID',
              labelText: 'Candidate user ID',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _cohortIdController,
              hintText: 'cohort UUID',
              labelText: 'Cohort ID',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _startWindowDateController,
              hintText: '2026-06-25T14:03:03',
              labelText: 'Start window date',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _endWindowDateController,
              hintText: '2052-07-18',
              labelText: 'End window date',
              obscureText: false,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _maxAttemptsAllowedController,
              hintText: '2',
              labelText: 'Max attempts allowed',
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _enrollmentNotesController,
              hintText: 'g',
              labelText: 'Enrollment notes',
              obscureText: false,
              maxLines: 2,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: 'Create Enrollment',
              width: double.infinity,
              radius: 8.r,
              backgroundColor: AppColors.secondaryColor7,
              textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.neutralColor,
              ),
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final maxAttemptsAllowed = int.tryParse(
      _maxAttemptsAllowedController.text.trim(),
    );

    if (_candidateUserIdController.text.trim().isEmpty ||
        _cohortIdController.text.trim().isEmpty ||
        _startWindowDateController.text.trim().isEmpty ||
        _endWindowDateController.text.trim().isEmpty ||
        _enrollmentNotesController.text.trim().isEmpty ||
        maxAttemptsAllowed == null) {
      showAppSnackBar(context, 'Please fill all required fields correctly');
      return;
    }

    context.read<LiveSessionsAndEnrollmentManagementCubit>().createEnrollment(
      widget.examId,
      CreateEnrollmentRequestBody(
        candidateUserId: _candidateUserIdController.text.trim(),
        cohortId: _cohortIdController.text.trim(),
        startWindowDate: _startWindowDateController.text.trim(),
        endWindowDate: _endWindowDateController.text.trim(),
        maxAttemptsAllowed: maxAttemptsAllowed,
        enrollmentNotes: _enrollmentNotesController.text.trim(),
      ),
    );
    Navigator.pop(context);
  }
}
