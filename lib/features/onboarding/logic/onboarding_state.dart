import 'package:equatable/equatable.dart';
import '../data/models/color_option_model.dart';
import '../data/models/style_option_model.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingLoaded extends OnboardingState {
  final List<StyleOptionModel> styleOptions;
  final List<ColorOptionModel> colorOptions;
  final String? selectedStyleId;
  final List<String> selectedColorIds;

  const OnboardingLoaded({
    required this.styleOptions,
    required this.colorOptions,
    this.selectedStyleId,
    this.selectedColorIds = const [],
  });

  OnboardingLoaded copyWith({
    String? selectedStyleId,
    List<String>? selectedColorIds,
  }) {
    return OnboardingLoaded(
      styleOptions: styleOptions,
      colorOptions: colorOptions,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      selectedColorIds: selectedColorIds ?? this.selectedColorIds,
    );
  }

  @override
  List<Object?> get props => [
    styleOptions,
    colorOptions,
    selectedStyleId,
    selectedColorIds,
  ];
}

class OnboardingSaving extends OnboardingState {
  const OnboardingSaving();
}

class OnboardingSaveSuccess extends OnboardingState {
  const OnboardingSaveSuccess();
}

class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
