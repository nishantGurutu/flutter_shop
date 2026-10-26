part of 'professional_list_bloc.dart';

class ProfessionalListState {
  final bool isLoading;
  final List<ProfessionalModel> professionals;
  final String category;

  ProfessionalListState({
    this.isLoading = false,
    this.professionals = const [],
    this.category = '',
  });

  ProfessionalListState copyWith({
    bool? isLoading,
    List<ProfessionalModel>? professionals,
    String? category,
  }) {
    return ProfessionalListState(
      isLoading: isLoading ?? this.isLoading,
      professionals: professionals ?? this.professionals,
      category: category ?? this.category,
    );
  }
}
