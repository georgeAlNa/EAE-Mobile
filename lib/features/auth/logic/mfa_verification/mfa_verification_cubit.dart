import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../data/models/mfa_verify/mfa_verify_request_body.dart';
import '../../data/models/mfa_verify/mfa_verify_response.dart';
import '../../data/repos/auth_repo.dart';

part 'mfa_verification_state.dart';

class MfaVerificationCubit extends Cubit<MfaVerificationState> {
  final AuthRepo authRepo;

  MfaVerificationCubit({required this.authRepo})
    : super(const MfaVerificationState.initial());

  Future<void> verifyMfa(MfaVerifyRequestBody requestBody) async {
    emit(const MfaVerificationState.loading());

    try {
      final response = await authRepo.verifyMfa(requestBody);
      emit(MfaVerificationState.success(response));
    } on NetworkExceptions catch (e) {
      emit(
        MfaVerificationState.error(error: NetworkExceptions.getErrorMessage(e)),
      );
    } catch (e) {
      emit(const MfaVerificationState.error(error: 'Failed to verify code'));
    }
  }
}
