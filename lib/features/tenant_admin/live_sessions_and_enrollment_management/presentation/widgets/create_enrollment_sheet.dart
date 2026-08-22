import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../../../core/public_widgets/searchable_entity_picker.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../cohorts/data/models/cohorts_response.dart';
import '../../../cohorts/data/repos/cohorts_repo.dart';
import '../../../users_management/data/models/users_management_response.dart';
import '../../../users_management/data/repos/users_management_repo.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/live_sessions_and_enrollment_management_request_body.dart';
import '../../logic/live_sessions_and_enrollment_management_cubit.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class CreateEnrollmentSheet extends StatefulWidget {
  final String examId;

  const CreateEnrollmentSheet({super.key, required this.examId});

  @override
  State<CreateEnrollmentSheet> createState() => _CreateEnrollmentSheetState();
}

class _CreateEnrollmentSheetState extends State<CreateEnrollmentSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _candidateUserId;
  String? _cohortId;
  late final Future<List<EntityPickerOption>> _users;
  late final Future<List<EntityPickerOption>> _cohorts;
  final _startWindowDateController = TextEditingController();
  final _endWindowDateController = TextEditingController();
  late DateTime _startWindowDate;
  late DateTime _endWindowDate;
  final _maxAttemptsAllowedController = TextEditingController(text: '2');
  final _enrollmentNotesController = TextEditingController(text: 'g');

  @override
  void dispose() {
    _startWindowDateController.dispose();
    _endWindowDateController.dispose();
    _maxAttemptsAllowedController.dispose();
    _enrollmentNotesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final today = DateUtils.dateOnly(DateTime.now());
    _startWindowDate = today;
    _endWindowDate = today.add(const Duration(days: 7));
    _startWindowDateController.text = _formatDate(_startWindowDate);
    _endWindowDateController.text = _formatDate(_endWindowDate);
    _users = _loadUsers();
    _cohorts = _loadCohorts();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: AppStrings.tr('Create enrollment'),
      subtitle: AppStrings.tr('Enroll a candidate into the selected exam.'),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FutureBuilder<List<EntityPickerOption>>(
              future: _users,
              builder: (context, snapshot) => SearchableEntityPicker(
                label: AppStrings.tr('Candidate user ID'), value: _candidateUserId,
                options: snapshot.data ?? const [],
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                onChanged: (id) => setState(() => _candidateUserId = id),
              ),
            ),
            verticalSpace(12),
            FutureBuilder<List<EntityPickerOption>>(
              future: _cohorts,
              builder: (context, snapshot) => SearchableEntityPicker(
                label: AppStrings.tr('Cohort ID'), value: _cohortId,
                options: snapshot.data ?? const [],
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                onChanged: (id) => setState(() => _cohortId = id),
              ),
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _startWindowDateController,
              hintText: '2026-06-25T14:03:03',
              labelText: AppStrings.tr('Start window date'),
              obscureText: false,
              readOnly: true,
              suffixIcon: Icons.calendar_month_outlined,
              onTap: () => _pickWindowDate(isStart: true),
              onPressedSuffixIcon: () => _pickWindowDate(isStart: true),
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _endWindowDateController,
              hintText: '2052-07-18',
              labelText: AppStrings.tr('End window date'),
              obscureText: false,
              readOnly: true,
              suffixIcon: Icons.calendar_month_outlined,
              onTap: () => _pickWindowDate(isStart: false),
              onPressedSuffixIcon: () => _pickWindowDate(isStart: false),
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _maxAttemptsAllowedController,
              hintText: '2',
              labelText: AppStrings.tr('Max attempts allowed'),
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _enrollmentNotesController,
              hintText: 'g',
              labelText: AppStrings.tr('Enrollment notes'),
              obscureText: false,
              maxLines: 2,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: AppStrings.tr('Create Enrollment'),
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

    if (_candidateUserId == null ||
        _cohortId == null ||
        _startWindowDateController.text.trim().isEmpty ||
        _endWindowDateController.text.trim().isEmpty ||
        _enrollmentNotesController.text.trim().isEmpty ||
        maxAttemptsAllowed == null) {
      showAppSnackBar(context, 'Please fill all required fields correctly');
      return;
    }

    if (_endWindowDate.isBefore(_startWindowDate)) {
      showAppSnackBar(
        context,
        AppStrings.tr('End window date must not be before start window date'),
      );
      return;
    }

    context.read<LiveSessionsAndEnrollmentManagementCubit>().createEnrollment(
      widget.examId,
      CreateEnrollmentRequestBody(
        candidateUserId: _candidateUserId!,
        cohortId: _cohortId!,
        startWindowDate: DateTime.utc(
          _startWindowDate.year,
          _startWindowDate.month,
          _startWindowDate.day,
        ).toIso8601String(),
        endWindowDate: DateTime.utc(
          _endWindowDate.year,
          _endWindowDate.month,
          _endWindowDate.day,
          23,
          59,
          59,
          999,
        ).toIso8601String(),
        maxAttemptsAllowed: maxAttemptsAllowed,
        enrollmentNotes: _enrollmentNotesController.text.trim(),
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _pickWindowDate({required bool isStart}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStart ? _startWindowDate : _endWindowDate,
      firstDate: isStart
          ? DateUtils.dateOnly(DateTime.now())
          : _startWindowDate,
      lastDate: DateTime(DateTime.now().year + 20, 12, 31),
    );
    if (selected == null || !mounted) return;

    setState(() {
      if (isStart) {
        _startWindowDate = selected;
        _startWindowDateController.text = _formatDate(selected);
        if (_endWindowDate.isBefore(selected)) {
          _endWindowDate = selected;
          _endWindowDateController.text = _formatDate(selected);
        }
      } else {
        _endWindowDate = selected;
        _endWindowDateController.text = _formatDate(selected);
      }
    });
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<List<EntityPickerOption>> _loadUsers() async {
    final response = await getIt<UsersManagementRepo>().usersManagement();
    return response.data.map(_userOption).toList();
  }

  Future<List<EntityPickerOption>> _loadCohorts() async {
    final response = await getIt<CohortsRepo>().cohorts();
    return response.data.map(_cohortOption).toList();
  }
}

EntityPickerOption _userOption(UserManagementUser user) => EntityPickerOption(
  id: user.id,
  label: ('${user.firstName} ${user.lastName}').trim(),
  subtitle: user.email,
);

EntityPickerOption _cohortOption(CohortItem cohort) => EntityPickerOption(
  id: cohort.id, label: cohort.cohortName, subtitle: cohort.cohortCode,
);
