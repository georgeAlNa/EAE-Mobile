import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
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
              saved: (_) {
                showAppSnackBar(context, 'Competency saved successfully');
                context.read<CompetenciesCubit>().getCompetenciesTree();
              },
              actionSuccess: (_) {
                showAppSnackBar(context, 'Action completed successfully');
                context.read<CompetenciesCubit>().getCompetenciesTree();
              },
              error: (error) => showAppSnackBar(context, error),
              orElse: () {},
            );
          },
          builder: (context, state) {
            final cubit = context.read<CompetenciesCubit>();
            final competencies = state.maybeWhen(
              loaded: (response) => response.data,
              orElse: () => cubit.competenciesTreeResponse?.data,
            );
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            if (competencies == null && isLoading) {
              return const LoadingWidget();
            }

            if (competencies == null) {
              return CompetenciesErrorView(onRetry: cubit.getCompetenciesTree);
            }

            final flattenedCompetencies = flattenCompetencies(competencies);
            final visibleCompetencies = filterCompetencies(
              competencies,
              _query,
            );

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: cubit.getCompetenciesTree,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
                    children: [
                      CompetenciesHeader(
                        competenciesCount: flattenedCompetencies.length,
                        rootCount: competencies.length,
                        searchController: _searchController,
                        onCreateCompetency: () => showCompetencyFormSheet(
                          context: context,
                          competencies: flattenedCompetencies,
                        ),
                      ),
                      verticalSpace(18),
                      if (visibleCompetencies.isEmpty)
                        CompetenciesEmptyState(
                          title: _query.isEmpty
                              ? 'No competencies yet'
                              : 'No matching competencies',
                          message: _query.isEmpty
                              ? 'Create the first competency to start building the evaluator map.'
                              : 'Try another competency name or description.',
                        )
                      else
                        ...visibleCompetencies.map(
                          (competency) => CompetencyCard(
                            competency: competency,
                            parentName: parentNameFor(
                              competency.parentId,
                              flattenedCompetencies,
                            ),
                            onMove: () => showMoveCompetencySheet(
                              context: context,
                              competencies: flattenedCompetencies,
                              competency: competency,
                            ),
                            onDelete: () => confirmCompetencyDelete(
                              context: context,
                              competency: competency,
                              onConfirmed: () =>
                                  cubit.deleteCompetency(competency.id),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: ColoredBox(
                      color: AppColors.neutralColor.withValues(alpha: 0.65),
                      child: const LoadingWidget(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
