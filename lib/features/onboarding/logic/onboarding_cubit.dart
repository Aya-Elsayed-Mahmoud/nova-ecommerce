import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/onboarding_repository.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingCubit(this._repository) : super(const OnboardingInitial());

  OnboardingLoaded _lastLoaded = const OnboardingLoaded(
    styleOptions: [],
    colorOptions: [],
  );

  OnboardingLoaded get lastLoadedState => _lastLoaded;

  Future<void> loadPreferences() async {
    emit(const OnboardingLoading());
    try {
      final styles = await _repository.fetchStyleOptions();
      final colors = await _repository.fetchColorOptions();
      _lastLoaded = OnboardingLoaded(
        styleOptions: styles,
        colorOptions: colors,
      );
      emit(_lastLoaded);
    } catch (e) {
      emit(OnboardingError('Failed to load preferences: $e'));
    }
  }

  void selectStyle(String styleId) {
    final current = state;
    if (current is! OnboardingLoaded) return;
    _lastLoaded = current.copyWith(selectedStyleId: styleId);
    emit(_lastLoaded);
  }

  void toggleColor(String colorId) {
    final current = state;
    if (current is! OnboardingLoaded) return;

    final updatedColors = List<String>.from(current.selectedColorIds);
    if (updatedColors.contains(colorId)) {
      updatedColors.remove(colorId);
    } else {
      updatedColors.add(colorId);
    }

    _lastLoaded = current.copyWith(selectedColorIds: updatedColors);
    emit(_lastLoaded);
  }

  Future<void> savePreferences() async {
    final current = state;
    if (current is! OnboardingLoaded) return;

    emit(const OnboardingSaving());
    try {
      await _repository.savePreferences(
        styleId: current.selectedStyleId,
        colorIds: current.selectedColorIds,
      );
      await _repository.setOnboardingCompleted();
      emit(const OnboardingSaveSuccess());
    } catch (e) {
      emit(OnboardingError('Failed to save preferences: $e'));
    }
  }
}
