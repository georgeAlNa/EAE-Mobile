import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/certificates_response.dart';
import '../../logic/certificates_cubit.dart';

class CertificatesScreen extends StatefulWidget {
  final CertificateRole role;
  final String title;
  final bool useScaffold;
  final String? Function(Certificate certificate)? trustedSessionIdResolver;

  const CertificatesScreen({
    super.key,
    required this.role,
    required this.title,
    this.useScaffold = true,
    this.trustedSessionIdResolver,
  });

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  final _scrollController = ScrollController();
  final _verifyCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CertificatesCubit>().loadCertificates();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _verifyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocConsumer<CertificatesCubit, CertificatesState>(
      listener: _listenToState,
      builder: (context, state) {
        final cubit = context.read<CertificatesCubit>();
        final certificates = cubit.currentCertificates;
        final isInitialLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final isBusy = state.maybeWhen(
          detailsLoading: () => true,
          actionLoading: () => true,
          downloadLoading: () => true,
          verifyLoading: () => true,
          orElse: () => false,
        );

        return SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: cubit.refresh,
                child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 18.h,
                  ),
                  children: [
                    _CertificatesHeader(
                      title: widget.title,
                      count: certificates.length,
                      onVerify: _showVerifySheet,
                    ),
                    verticalSpace(14),
                    _CertificatesListBody(
                      certificates: certificates,
                      state: state,
                      isInitialLoading: isInitialLoading,
                      onRetry: () => cubit.loadCertificates(),
                      onOpen: (certificate) => cubit.getCertificateDetails(
                        certificate.certificateId,
                      ),
                    ),
                    if (cubit.hasMore && certificates.isNotEmpty) ...[
                      verticalSpace(10),
                      OutlinedButton.icon(
                        onPressed: cubit.loadNextPage,
                        icon: const Icon(Icons.expand_more),
                        label: Text(AppStrings.tr('Load More')),
                      ),
                    ],
                    verticalSpace(24),
                  ],
                ),
              ),
              if (isBusy)
                Positioned(
                  left: 24.w,
                  right: 24.w,
                  bottom: 14.h,
                  child: _CertificatesActionBanner(state: state),
                ),
            ],
          ),
        );
      },
    );

    if (!widget.useScaffold) return content;

    return Scaffold(backgroundColor: AppColors.neutralColor, body: content);
  }

  void _listenToState(BuildContext context, CertificatesState state) {
    state.maybeWhen(
      detailsLoaded: (certificate) => _showDetailsSheet(certificate),
      detailsError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      downloadSuccess: (file) => showAppSnackBar(
        context,
        '${AppStrings.tr('Certificate downloaded')}: ${file.filePath}',
      ),
      downloadError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      actionSuccess: (_) =>
          showAppSnackBar(context, AppStrings.tr('Certificate updated')),
      actionError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      verified: (response) => showAppSnackBar(
        context,
        response.valid
            ? AppStrings.tr('Certificate is valid')
            : AppStrings.tr('Certificate is revoked'),
      ),
      verifyError: (_) =>
          showAppSnackBar(context, AppStrings.tr('Invalid certificate')),
      nextPageError: (_, error) =>
          showAppSnackBar(context, AppStrings.tr(error)),
      refreshError: (_, error) =>
          showAppSnackBar(context, AppStrings.tr(error)),
      error: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      orElse: () {},
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 180) {
      context.read<CertificatesCubit>().loadNextPage();
    }
  }

  void _showDetailsSheet(Certificate certificate) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CertificatesCubit>(),
        child: _CertificateDetailsSheet(
          certificate: certificate,
          trustedSessionIdResolver: widget.trustedSessionIdResolver,
        ),
      ),
    );
  }

  void _showVerifySheet() {
    _verifyCodeController.clear();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CertificatesCubit>(),
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 18.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18.h,
          ),
          child: _CertificateVerifySheet(controller: _verifyCodeController),
        ),
      ),
    );
  }
}

class _CertificatesHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onVerify;

  const _CertificatesHeader({
    required this.title,
    required this.count,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.tr(title),
                style: AppTextStyles.font20DarkGreyBold.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: AppStrings.tr('Verify Certificate'),
              onPressed: onVerify,
              icon: const Icon(Icons.verified_outlined),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          '${AppStrings.tr('Loaded certificates')}: $count',
          style: AppTextStyles.font12DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
          ),
        ),
      ],
    );
  }
}

class _CertificatesListBody extends StatelessWidget {
  final List<Certificate> certificates;
  final CertificatesState state;
  final bool isInitialLoading;
  final VoidCallback onRetry;
  final ValueChanged<Certificate> onOpen;

  const _CertificatesListBody({
    required this.certificates,
    required this.state,
    required this.isInitialLoading,
    required this.onRetry,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final error = state.whenOrNull(error: (error) => error);
    final nextPageError = state.whenOrNull(nextPageError: (_, error) => error);

    if (isInitialLoading && certificates.isEmpty) {
      return const AppSkeletonDataList(
        itemCount: 4,
        showDescription: false,
        infoRowCount: 3,
      );
    }

    if (error != null && certificates.isEmpty) {
      return SizedBox(
        height: 320.h,
        child: AppRetryErrorView(
          title: AppStrings.tr(error),
          message: AppStrings.tr('Failed to load certificates'),
          onRetry: onRetry,
        ),
      );
    }

    if (certificates.isEmpty) {
      return SizedBox(
        height: 260.h,
        child: Center(
          child: Text(
            AppStrings.tr('No certificates available'),
            style: AppTextStyles.font14DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...certificates.map(
          (certificate) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _CertificateCard(
              certificate: certificate,
              onTap: () => onOpen(certificate),
            ),
          ),
        ),
        if (nextPageError != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              AppStrings.tr(nextPageError),
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor7,
              ),
            ),
          ),
      ],
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final Certificate certificate;
  final VoidCallback onTap;

  const _CertificateCard({required this.certificate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    certificate.certificateCode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                      color: AppColors.primaryColor9,
                    ),
                  ),
                ),
                _StatusBadge(status: certificate.verificationStatus),
              ],
            ),
            verticalSpace(10),
            _InfoLine(
              label: AppStrings.tr('Issued At'),
              value: _formatDate(certificate.issuedAt),
            ),
            _InfoLine(
              label: AppStrings.tr('Expires At'),
              value: _formatDate(certificate.expiresAt),
            ),
            _InfoLine(
              label: AppStrings.tr('Exam ID'),
              value: certificate.examId,
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificateDetailsSheet extends StatefulWidget {
  final Certificate certificate;
  final String? Function(Certificate certificate)? trustedSessionIdResolver;

  const _CertificateDetailsSheet({
    required this.certificate,
    required this.trustedSessionIdResolver,
  });

  @override
  State<_CertificateDetailsSheet> createState() =>
      _CertificateDetailsSheetState();
}

class _CertificateDetailsSheetState extends State<_CertificateDetailsSheet> {
  late Certificate _certificate;

  @override
  void initState() {
    super.initState();
    _certificate = widget.certificate;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CertificatesCubit>();
    final sessionId = widget.trustedSessionIdResolver?.call(_certificate);
    final canRevoke = cubit.canManageCertificates && !_certificate.isRevoked;

    return BlocListener<CertificatesCubit, CertificatesState>(
      listener: (context, state) {
        state.maybeWhen(
          actionSuccess: (certificate) {
            setState(() => _certificate = certificate);
          },
          detailsLoaded: (certificate) {
            setState(() => _certificate = certificate);
          },
          orElse: () {},
        );
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.82,
        minChildSize: 0.45,
        maxChildSize: 0.94,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.tr('Certificate Details'),
                      style: AppTextStyles.font16DarkGreyBold.copyWith(
                        color: AppColors.primaryColor9,
                      ),
                    ),
                  ),
                  _StatusBadge(status: _certificate.verificationStatus),
                ],
              ),
              verticalSpace(14),
              _DetailsRow(
                label: AppStrings.tr('Certificate Code'),
                value: _certificate.certificateCode,
              ),
              _DetailsRow(
                label: AppStrings.tr('Issued At'),
                value: _formatDate(_certificate.issuedAt),
              ),
              _DetailsRow(
                label: AppStrings.tr('Expires At'),
                value: _formatDate(_certificate.expiresAt),
              ),
              _DetailsRow(
                label: AppStrings.tr('Exam ID'),
                value: _certificate.examId,
              ),
              _DetailsRow(
                label: AppStrings.tr('Assessment Result ID'),
                value: _certificate.assessmentResultId,
              ),
              if (_certificate.qrCodeData != null)
                _DetailsRow(
                  label: AppStrings.tr('QR Verification Link'),
                  value: _certificate.qrCodeData!,
                ),
              if (_certificate.revokedAt != null)
                _DetailsRow(
                  label: AppStrings.tr('Revoked At'),
                  value: _formatDate(_certificate.revokedAt),
                ),
              if (_certificate.revokedReason != null)
                _DetailsRow(
                  label: AppStrings.tr('Revoked Reason'),
                  value: _certificate.revokedReason!,
                ),
              if (sessionId != null) ...[
                verticalSpace(18),
                OutlinedButton.icon(
                  onPressed: () => cubit.downloadSessionCertificate(sessionId),
                  icon: const Icon(Icons.download_outlined),
                  label: Text(AppStrings.tr('Download Certificate')),
                ),
              ],
              if (cubit.canManageCertificates) ...[
                verticalSpace(10),
                OutlinedButton.icon(
                  onPressed: () => _confirmRegenerate(context, _certificate),
                  icon: const Icon(Icons.refresh_outlined),
                  label: Text(AppStrings.tr('Regenerate Certificate')),
                ),
                verticalSpace(10),
                FilledButton.icon(
                  onPressed: canRevoke
                      ? () => _confirmRevoke(context, _certificate)
                      : null,
                  icon: const Icon(Icons.block_outlined),
                  label: Text(AppStrings.tr('Revoke Certificate')),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.tertiaryColor7,
                    foregroundColor: AppColors.neutralColor,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _confirmRegenerate(BuildContext context, Certificate certificate) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.tr('Regenerate certificate?')),
        content: Text(
          AppStrings.tr(
            'Regenerating replaces the current certificate identity and PDF.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppStrings.tr('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CertificatesCubit>().regenerateCertificate(
                certificate.certificateId,
              );
            },
            child: Text(AppStrings.tr('Regenerate Certificate')),
          ),
        ],
      ),
    );
  }

  void _confirmRevoke(BuildContext context, Certificate certificate) {
    final reasonController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.tr('Revoke certificate?')),
        content: TextField(
          controller: reasonController,
          maxLength: 500,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: AppStrings.tr('Revoke Reason'),
            hintText: AppStrings.tr('Optional reason, up to 500 characters'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppStrings.tr('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CertificatesCubit>().revokeCertificate(
                certificate.certificateId,
                reason: reasonController.text,
              );
            },
            child: Text(AppStrings.tr('Revoke Certificate')),
          ),
        ],
      ),
    ).whenComplete(reasonController.dispose);
  }
}

class _CertificateVerifySheet extends StatelessWidget {
  final TextEditingController controller;

  const _CertificateVerifySheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.tr('Verify Certificate'),
          style: AppTextStyles.font16DarkGreyBold.copyWith(
            color: AppColors.primaryColor9,
          ),
        ),
        verticalSpace(14),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: AppStrings.tr('Certificate Code'),
            hintText: 'CERT-XXXXXXXXXX',
          ),
          onSubmitted: (_) => _verify(context),
        ),
        verticalSpace(12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _verify(context),
            icon: const Icon(Icons.verified_outlined),
            label: Text(AppStrings.tr('Verify by Code')),
          ),
        ),
        verticalSpace(12),
        BlocBuilder<CertificatesCubit, CertificatesState>(
          builder: (context, state) {
            return state.maybeWhen(
              verifyLoading: () => const LinearProgressIndicator(),
              verified: (response) => _VerificationResult(response: response),
              verifyError: (_) => _VerificationResult(
                response: CertificateVerificationResponse(valid: false),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  void _verify(BuildContext context) {
    context.read<CertificatesCubit>().verifyCertificate(controller.text);
  }
}

class _VerificationResult extends StatelessWidget {
  final CertificateVerificationResponse response;

  const _VerificationResult({required this.response});

  @override
  Widget build(BuildContext context) {
    final title = response.valid
        ? AppStrings.tr('Certificate is valid')
        : AppStrings.tr(
            response.certificateCode == null
                ? 'Certificate not found'
                : 'Certificate is revoked',
          );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.font14DarkGreySemiBold.copyWith(
              color: response.valid
                  ? AppColors.secondaryColor7
                  : AppColors.tertiaryColor7,
            ),
          ),
          if (response.certificateCode != null) ...[
            verticalSpace(8),
            _InfoLine(
              label: AppStrings.tr('Certificate Code'),
              value: response.certificateCode!,
            ),
          ],
          if (response.issuedAt != null)
            _InfoLine(
              label: AppStrings.tr('Issued At'),
              value: _formatDate(response.issuedAt),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isRevoked = status.toLowerCase() == CertificateStatus.revoked;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isRevoked ? AppColors.tertiaryColor2 : AppColors.secondaryColor2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        AppStrings.tr(isRevoked ? 'Revoked' : 'Valid'),
        style: AppTextStyles.font10DarkGreyRegular.copyWith(
          color: isRevoked
              ? AppColors.tertiaryColor7
              : AppColors.secondaryColor7,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118.w,
            child: Text(
              label,
              style: AppTextStyles.font10DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.font10DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
          verticalSpace(4),
          Text(
            value,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificatesActionBanner extends StatelessWidget {
  final CertificatesState state;

  const _CertificatesActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      detailsLoading: () => 'Loading certificate details...',
      actionLoading: () => 'Updating certificate...',
      downloadLoading: () => 'Downloading certificate...',
      verifyLoading: () => 'Verifying certificate...',
      orElse: () => 'Working...',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.secondaryColor7,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor10.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: AppSkeletonBox(height: 18.h, borderRadius: 9),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(
                AppStrings.tr(message),
                style: TextStyle(
                  color: AppColors.neutralColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(String? value) {
  if (value == null || value.isEmpty) return '-';
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  final local = parsed.toLocal();
  final date =
      '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  final time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}
