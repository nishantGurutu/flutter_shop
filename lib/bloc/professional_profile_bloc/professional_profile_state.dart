part of 'professional_profile_bloc.dart';

class ProfessionalProfileState {
  final bool isLoading;
  final ProfessionalModel? professional;

  ProfessionalProfileState({
    this.isLoading = true,
    this.professional,
  });

  ProfessionalProfileState copyWith({
    bool? isLoading,
    ProfessionalModel? professional,
  }) {
    return ProfessionalProfileState(
      isLoading: isLoading ?? this.isLoading,
      professional: professional ?? this.professional,
    );
  }
}
