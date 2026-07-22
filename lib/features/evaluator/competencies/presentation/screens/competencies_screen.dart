import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/competencies_response.dart';
import '../../logic/competencies_cubit.dart';
import '../widgets/competencies_empty_error.dart';
import '../widgets/competencies_header.dart';
import '../widgets/competencies_helpers.dart';
import '../widgets/competencies_sheets.dart';
import '../widgets/competency_card.dart';

class CompetenciesScreen extends StatefulWidget {
  const CompetenciesScreen({super.key});

  @override
  State<CompetenciesScreen> createState() => _CompetenciesScreenState();
}

class _CompetenciesScreenState extends State<CompetenciesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  List<Competency>? _competencies;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<CompetenciesCubit, CompetenciesState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (response) => _competencies = response.data,
              saved: (_) {
                showAppSnackBar(context, 'Competency saved successfully');
                context.read<CompetenciesCubit>().getCompetenciesTree();
              },
              actionSuccess: (_) {
                showAppSnackBar(context, 'Action completed successfully');
                context.read<CompetenciesCubit>().getCompetenciesTree();
              },
              saveError: (error) => showAppSnackBar(context, error),
              actionError: (error) => showAppSnackBar(context, error),
              orElse: () {},
            );
          },
          builder: (context, state) {
            final cubit = context.read<CompetenciesCubit>();
            final loadedCompetencies = state.maybeWhen(
              loaded: (response) => response.data,
              orElse: () => null,
            );
            if (loadedCompetencies != null) {
              _competencies = loadedCompetencies;
            }

            final competencies =
                _competencies ?? cubit.competenciesTreeResponse?.data;
            final isCompetenciesLoading = state.maybeWhen(
              competenciesLoading: () => true,
              orElse: () => false,
            );
            final isActionLoading = state.maybeWhen(
              saveLoading: () => true,
              deleteLoading: () => true,
              orElse: () => false,
            );
            final loadError = state.maybeWhen(
              loadError: (error) => error,
              orElse: () => null,
            );

            final flattenedCompetencies = competencies == null
                ? const <Competency>[]
                : flattenCompetencies(competencies);
            final visibleCompetencies = competencies == null
                ? null
                : filterCompetencies(competencies, _query);

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.getCompetenciesTree,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: ListView(
                      key: ValueKey('${visibleCompetencies?.length}-$_query'),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 18.h,
                      ),
                      children: [
                        CompetenciesHeader(
                          competenciesCount: competencies == null
                              ? 0
                              : flattenedCompetencies.length,
                          rootCount: competencies?.length ?? 0,
                          searchController: _searchController,
                          onCreateCompetency: () => showCompetencyFormSheet(
                            context: context,
                            competencies: flattenedCompetencies,
                          ),
                        ),
                        verticalSpace(18),
                        _CompetenciesDataSection(
                          competencies: visibleCompetencies,
                          flattenedCompetencies: flattenedCompetencies,
                          query: _query,
                          isLoading:
                              competencies == null && isCompetenciesLoading,
                          loadError: competencies == null ? loadError : null,
                          onRetry: cubit.getCompetenciesTree,
                          onMove: (competency) => showMoveCompetencySheet(
                            context: context,
                            competencies: flattenedCompetencies,
                            competency: competency,
                          ),
                          onDelete: (competency) => confirmCompetencyDelete(
                            context: context,
                            competency: competency,
                            onConfirmed: () =>
                                cubit.deleteCompetency(competency.id),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isCompetenciesLoading &&
                    competencies != null &&
                    competencies.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppSkeletonBox(
                      width: double.infinity,
                      height: 4.h,
                      borderRadius: 0,
                    ),
                  ),
                if (isActionLoading)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _CompetenciesActionBanner(state: state),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CompetenciesDataSection extends StatelessWidget {
  final List<Competency>? competencies;
  final List<Competency> flattenedCompetencies;
  final String query;
  final bool isLoading;
  final String? loadError;
  final VoidCallback onRetry;
  final ValueChanged<Competency> onMove;
  final ValueChanged<Competency> onDelete;

  const _CompetenciesDataSection({
    required this.competencies,
    required this.flattenedCompetencies,
    required this.query,
    required this.isLoading,
    required this.loadError,
    required this.onRetry,
    required this.onMove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppSkeletonDataList(
        itemCount: 5,
        showDescription: true,
        chipCount: 2,
      );
    }

    if (loadError != null) {
      return SizedBox(
        height: 260.h,
        child: AppRetryErrorView(
          title: loadError!,
          message: 'Check the connection and try again.',
          onRetry: onRetry,
        ),
      );
    }

    final items = competencies ?? const <Competency>[];
    if (items.isEmpty) {
      return CompetenciesEmptyState(
        title: query.isEmpty
            ? 'No competencies yet'
            : 'No matching competencies',
        message: query.isEmpty
            ? 'Create the first competency to start building the evaluator map.'
            : 'Try another competency name or description.',
      );
    }

    return Column(
      children: items
          .asMap()
          .entries
          .map(
            (entry) => _AnimatedListItem(
              index: entry.key,
              child: CompetencyCard(
                competency: entry.value,
                parentName: parentNameFor(
                  entry.value.parentId,
                  flattenedCompetencies,
                ),
                onMove: () => onMove(entry.value),
                onDelete: () => onDelete(entry.value),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedListItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 180 + (index.clamp(0, 6) * 35)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10.h),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _CompetenciesActionBanner extends StatelessWidget {
  final CompetenciesState state;

  const _CompetenciesActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      saveLoading: () => 'Saving competency...',
      deleteLoading: () => 'Deleting competency...',
      orElse: () => 'Working...',
    );

    return _EvaluatorActionProgressBanner(message: message);
  }
}

class _EvaluatorActionProgressBanner extends StatelessWidget {
  final String message;

  const _EvaluatorActionProgressBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: DecoratedBox(
        key: ValueKey(message),
        decoration: BoxDecoration(
          color: AppColors.primaryColor9,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
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
                  message,
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
      ),
    );
  }
}
