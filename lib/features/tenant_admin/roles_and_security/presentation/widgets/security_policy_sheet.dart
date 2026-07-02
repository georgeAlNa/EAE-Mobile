import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/custom_dropdown.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/roles_and_security_request_body.dart';
import '../../data/models/roles_and_security_response.dart';
import '../../logic/roles_and_security_cubit.dart';

class SecurityPolicySheet extends StatefulWidget {
  final SecurityPolicy policy;

  const SecurityPolicySheet({super.key, required this.policy});

  @override
  State<SecurityPolicySheet> createState() => _SecurityPolicySheetState();
}

class _SecurityPolicySheetState extends State<SecurityPolicySheet> {
  final _formKey = GlobalKey<FormState>();
  late bool _mfaEnabled;
  late bool _passwordRequireUppercase;
  late bool _passwordRequireLowercase;
  late bool _passwordRequireNumbers;
  late bool _passwordRequireSpecialChars;
  late bool _sessionForceReauthOnPrivilegeChange;
  late bool _ipWhitelistingEnabled;
  late bool _enableBiometricAuth;
  late bool _enforceTls13Minimum;
  late bool _disableWeakCiphers;

  String? _mfaMethod;
  late final TextEditingController _passwordMinLengthController;
  late final TextEditingController _passwordExpiryDaysController;
  late final TextEditingController _passwordHistoryCountController;
  late final TextEditingController _sessionTimeoutMinutesController;
  late final TextEditingController _sessionAbsoluteTimeoutHoursController;
  late final TextEditingController _allowedIpRangesController;

  @override
  void initState() {
    super.initState();
    final policy = widget.policy;
    _mfaEnabled = policy.mfaEnabled;
    _passwordRequireUppercase = policy.passwordRequireUppercase;
    _passwordRequireLowercase = policy.passwordRequireLowercase;
    _passwordRequireNumbers = policy.passwordRequireNumbers;
    _passwordRequireSpecialChars = policy.passwordRequireSpecialChars;
    _sessionForceReauthOnPrivilegeChange =
        policy.sessionForceReauthOnPrivilegeChange;
    _ipWhitelistingEnabled = policy.ipWhitelistingEnabled;
    _enableBiometricAuth = policy.enableBiometricAuth;
    _enforceTls13Minimum = policy.enforceTls13Minimum;
    _disableWeakCiphers = policy.disableWeakCiphers;

    _mfaMethod = policy.mfaMethod;
    _passwordMinLengthController = TextEditingController(
      text: policy.passwordMinLength.toString(),
    );
    _passwordExpiryDaysController = TextEditingController(
      text: policy.passwordExpiryDays?.toString() ?? '',
    );
    _passwordHistoryCountController = TextEditingController(
      text: policy.passwordHistoryCount?.toString() ?? '',
    );
    _sessionTimeoutMinutesController = TextEditingController(
      text: policy.sessionTimeoutMinutes.toString(),
    );
    _sessionAbsoluteTimeoutHoursController = TextEditingController(
      text: policy.sessionAbsoluteTimeoutHours.toString(),
    );
    _allowedIpRangesController = TextEditingController(
      text: policy.allowedIpRanges?.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _passwordMinLengthController.dispose();
    _passwordExpiryDaysController.dispose();
    _passwordHistoryCountController.dispose();
    _sessionTimeoutMinutesController.dispose();
    _sessionAbsoluteTimeoutHoursController.dispose();
    _allowedIpRangesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Update security policy',
      subtitle: 'Adjust authentication, password, session, and IP controls.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _PolicySwitch(
              title: 'MFA enabled',
              value: _mfaEnabled,
              onChanged: (value) => setState(() => _mfaEnabled = value),
            ),
            CustomDropdown(
              items: _dropdownItems(_mfaMethod, _mfaMethodOptions),
              value: _mfaMethod,
              hintText: 'MFA method',
              onChanged: _mfaEnabled
                  ? (value) => setState(() => _mfaMethod = value)
                  : (_) {},
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordMinLengthController,
              hintText: '22',
              labelText: 'Password min length',
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordExpiryDaysController,
              hintText: '7',
              labelText: 'Password expiry days',
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _passwordHistoryCountController,
              hintText: '6',
              labelText: 'Password history count',
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _sessionTimeoutMinutesController,
              hintText: '17',
              labelText: 'Session timeout minutes',
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _sessionAbsoluteTimeoutHoursController,
              hintText: '15',
              labelText: 'Session absolute timeout hours',
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            verticalSpace(12),
            TextFieldWidget(
              controller: _allowedIpRangesController,
              hintText: '10.0.0.0/24, 192.168.1.1',
              labelText: 'Allowed IP ranges',
              obscureText: false,
              maxLines: 2,
            ),
            verticalSpace(12),
            _PolicySwitch(
              title: 'Require uppercase',
              value: _passwordRequireUppercase,
              onChanged: (value) =>
                  setState(() => _passwordRequireUppercase = value),
            ),
            _PolicySwitch(
              title: 'Require lowercase',
              value: _passwordRequireLowercase,
              onChanged: (value) =>
                  setState(() => _passwordRequireLowercase = value),
            ),
            _PolicySwitch(
              title: 'Require numbers',
              value: _passwordRequireNumbers,
              onChanged: (value) =>
                  setState(() => _passwordRequireNumbers = value),
            ),
            _PolicySwitch(
              title: 'Require special chars',
              value: _passwordRequireSpecialChars,
              onChanged: (value) =>
                  setState(() => _passwordRequireSpecialChars = value),
            ),
            _PolicySwitch(
              title: 'Force reauth on privilege change',
              value: _sessionForceReauthOnPrivilegeChange,
              onChanged: (value) =>
                  setState(() => _sessionForceReauthOnPrivilegeChange = value),
            ),
            _PolicySwitch(
              title: 'IP whitelisting',
              value: _ipWhitelistingEnabled,
              onChanged: (value) =>
                  setState(() => _ipWhitelistingEnabled = value),
            ),
            _PolicySwitch(
              title: 'Biometric auth',
              value: _enableBiometricAuth,
              onChanged: (value) =>
                  setState(() => _enableBiometricAuth = value),
            ),
            _PolicySwitch(
              title: 'Enforce TLS 1.3 minimum',
              value: _enforceTls13Minimum,
              onChanged: (value) =>
                  setState(() => _enforceTls13Minimum = value),
            ),
            _PolicySwitch(
              title: 'Disable weak ciphers',
              value: _disableWeakCiphers,
              onChanged: (value) => setState(() => _disableWeakCiphers = value),
            ),
            verticalSpace(20),
            ButtonWidget(
              title: 'Update Policy',
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

    final passwordMinLength = int.tryParse(
      _passwordMinLengthController.text.trim(),
    );
    final sessionTimeoutMinutes = int.tryParse(
      _sessionTimeoutMinutesController.text.trim(),
    );
    final sessionAbsoluteTimeoutHours = int.tryParse(
      _sessionAbsoluteTimeoutHoursController.text.trim(),
    );

    if (passwordMinLength == null ||
        sessionTimeoutMinutes == null ||
        sessionAbsoluteTimeoutHours == null) {
      showAppSnackBar(context, 'Please enter valid required numbers');
      return;
    }

    final passwordExpiryDays = _optionalInt(_passwordExpiryDaysController.text);
    final passwordHistoryCount = _optionalInt(
      _passwordHistoryCountController.text,
    );
    final allowedIpRanges = _allowedIpRangesController.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    context.read<RolesAndSecurityCubit>().updateSecurityPolicy(
      UpdateSecurityPolicyRequestBody(
        mfaEnabled: _mfaEnabled,
        mfaMethod: _mfaEnabled ? _mfaMethod : null,
        passwordMinLength: passwordMinLength,
        passwordRequireUppercase: _passwordRequireUppercase,
        passwordRequireLowercase: _passwordRequireLowercase,
        passwordRequireNumbers: _passwordRequireNumbers,
        passwordRequireSpecialChars: _passwordRequireSpecialChars,
        passwordExpiryDays: passwordExpiryDays,
        passwordHistoryCount: passwordHistoryCount,
        sessionTimeoutMinutes: sessionTimeoutMinutes,
        sessionAbsoluteTimeoutHours: sessionAbsoluteTimeoutHours,
        sessionForceReauthOnPrivilegeChange:
            _sessionForceReauthOnPrivilegeChange,
        ipWhitelistingEnabled: _ipWhitelistingEnabled,
        enableBiometricAuth: _enableBiometricAuth,
        enforceTls13Minimum: _enforceTls13Minimum,
        disableWeakCiphers: _disableWeakCiphers,
        allowedIpRanges: allowedIpRanges.isEmpty ? null : allowedIpRanges,
      ),
    );

    Navigator.pop(context);
  }

  int? _optionalInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }
}

const List<String> _mfaMethodOptions = [
  'email',
  'sms',
  'totp',
  'authenticator',
];

List<String> _dropdownItems(String? value, List<String> options) {
  if (value == null || value.isEmpty || options.contains(value)) return options;
  return [value, ...options];
}

class _PolicySwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PolicySwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.font14DarkGreySemiBold.copyWith(
          color: AppColors.primaryColor9,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
