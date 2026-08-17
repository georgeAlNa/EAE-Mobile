import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_strings.dart';
import '../data/models/forensics_checkpoint_models.dart';

part 'forensics_checkpoint_state.dart';
part 'forensics_checkpoint_cubit.freezed.dart';

class ForensicsCheckpointCubit extends Cubit<ForensicsCheckpointState> {
  ForensicsCheckpointCubit() : super(const ForensicsCheckpointState.loading()) {
    _loadInformationalData();
  }

  void _loadInformationalData() {
    final viewData = ForensicsCheckpointViewData(
      protocolLabel: AppStrings.securityProtocol,
      title: AppStrings.forensicsCheckpointTitle,
      subtitle: AppStrings.tr(
        'Security requirements are checked on the next setup screen.',
      ),
      heroTitle: AppStrings.tr('Security setup'),
      heroStatus: AppStrings.tr('Pending setup check'),
      heroStep: '--',
      checksCompleted: 0,
      checksTotal: 4,
      checks: const [
        ForensicsCheckItem(
          title: 'Location checks',
          subtitle: 'No geofence validation is performed on this screen',
          statusLabel: 'Not checked',
          isValidated: false,
        ),
        ForensicsCheckItem(
          title: 'Camera permission',
          subtitle: 'Checked only when required by exam setup',
          statusLabel: 'Pending',
          isValidated: false,
        ),
        ForensicsCheckItem(
          title: 'Microphone permission',
          subtitle: 'Checked only when required by exam setup',
          statusLabel: 'Pending',
          isValidated: false,
        ),
        ForensicsCheckItem(
          title: 'Device integrity',
          subtitle: 'Reported by the setup security service',
          statusLabel: 'Pending',
          isValidated: false,
        ),
      ],
      sessionNotice: AppStrings.sessionRecordedNotice,
      actionLabel: AppStrings.tr('Continue to setup'),
      deviceId: AppStrings.tr('Not collected'),
      auditLatency: AppStrings.tr('Not measured'),
    );

    emit(ForensicsCheckpointState.ready(viewData: viewData));
  }
}
