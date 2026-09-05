import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_ecommerce/core/theme/app_colors.dart';
import 'package:nova_ecommerce/core/theme/text_style.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/onboarding_repository.dart';
import '../../logic/onboarding_cubit.dart';
import '../../logic/onboarding_state.dart';
import '../../data/models/style_option_model.dart';
import '../widgets/color_option.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/style_option.dart';
import 'personalization_ready_screen.dart';

class PreferencesScreen extends StatelessWidget {
  final OnboardingRepository repository;

  const PreferencesScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(repository)..loadPreferences(),
      child: const _PreferencesView(),
    );
  }
}

class _PreferencesView extends StatefulWidget {
  const _PreferencesView();

  @override
  State<_PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<_PreferencesView> {
  int _step = 0; // 0 = style, 1 = colors

  void _goToReadyScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PersonalizationReadyScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: _step == 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step = 0),
              )
            : null,
      ),
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is OnboardingSaveSuccess) {
            _goToReadyScreen();
          }
        },
        builder: (context, state) {
          if (state is OnboardingLoading || state is OnboardingInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OnboardingLoaded) {
            return _step == 0
                ? _StyleStep(
                    state: state,
                    onContinue: () => setState(() => _step = 1),
                  )
                : _ColorsStep(state: state);
          }

          if (state is OnboardingSaving) {
            final cubit = context.read<OnboardingCubit>();
            return _ColorsStep(state: cubit.lastLoadedState, isSaving: true);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StyleStep extends StatelessWidget {
  final OnboardingLoaded state;
  final VoidCallback onContinue;

  const _StyleStep({required this.state, required this.onContinue});

  List<List<StyleOptionModel>> _toRows(List<StyleOptionModel> options) {
    final rows = <List<StyleOptionModel>>[];
    for (var i = 0; i < options.length; i += 2) {
      rows.add(
        options.sublist(i, i + 2 > options.length ? options.length : i + 2),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final rows = _toRows(state.styleOptions);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pick your style.',
            style: AppTextStyles.styleBold48.copyWith(fontSize: 24),
          ),
          verticalSpace(8),
          Text(
            'Choose the style that feels most like you.',
            style: TextStyle(color: AppColors.lightGrey),
          ),
          verticalSpace(24),

          Expanded(
            child: Column(
              children: [
                for (var r = 0; r < rows.length; r++) ...[
                  if (r > 0) verticalSpace(12),
                  Expanded(
                    child: Row(
                      children: [
                        for (var c = 0; c < rows[r].length; c++) ...[
                          if (c > 0) herizontalSpace(12),
                          Expanded(
                            child: StyleOptionCard(
                              option: rows[r][c],
                              isSelected:
                                  state.selectedStyleId == rows[r][c].id,
                              onTap: () => cubit.selectStyle(rows[r][c].id),
                            ),
                          ),
                        ],
                        if (rows[r].length == 1)
                          const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: PrimaryButton(
              label: 'Continue',
              onPressed: state.selectedStyleId == null ? null : onContinue,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorsStep extends StatelessWidget {
  final OnboardingLoaded state;
  final bool isSaving;

  const _ColorsStep({required this.state, this.isSaving = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    final groups = <String, List<int>>{};
    for (var i = 0; i < state.colorOptions.length; i++) {
      groups.putIfAbsent(state.colorOptions[i].groupLabel, () => []).add(i);
    }

    final selectedOptions = state.colorOptions
        .where((option) => state.selectedColorIds.contains(option.id))
        .toList();

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick your colors.',
                  style: AppTextStyles.styleBold48.copyWith(fontSize: 24),
                ),
                verticalSpace(8),
                Text(
                  'Select the tones that define your personal style to help us curate your wardrobe.',
                  style: TextStyle(color: AppColors.lightGrey),
                ),
                verticalSpace(20),

                Expanded(
                  child: ListView(
                    children: groups.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            verticalSpace(10),
                            Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: entry.value.map((index) {
                                final option = state.colorOptions[index];
                                return ColorOptionSwatch(
                                  option: option,
                                  isSelected: state.selectedColorIds.contains(
                                    option.id,
                                  ),
                                  onTap: () => cubit.toggleColor(option.id),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedOptions.isEmpty
                    ? 'YOUR PALETTE'
                    : 'YOUR PALETTE · ${selectedOptions.length} SELECTED',
                style: AppTextStyles.styleBold48.copyWith(
                  fontSize: 12,
                  color: AppColors.grey,
                  letterSpacing: 0.5,
                ),
              ),
              verticalSpace(10),
              SizedBox(
                height: 32,
                child: selectedOptions.isEmpty
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tap a color above to add it to your palette',
                          style: TextStyle(fontSize: 13, color: AppColors.grey),
                        ),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedOptions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final option = selectedOptions[index];
                          return GestureDetector(
                            onTap: () => cubit.toggleColor(option.id),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: option.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.06),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              verticalSpace(18),
              PrimaryButton(
                label: 'Continue',
                isLoading: isSaving,
                onPressed: state.selectedColorIds.isEmpty
                    ? null
                    : cubit.savePreferences,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
