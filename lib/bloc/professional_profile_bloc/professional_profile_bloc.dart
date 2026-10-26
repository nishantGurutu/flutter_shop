import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/model/professional/professional_model.dart';

part 'professional_profile_event.dart';
part 'professional_profile_state.dart';

class ProfessionalProfileBloc extends Bloc<ProfessionalProfileEvent, ProfessionalProfileState> {
  ProfessionalProfileBloc() : super(ProfessionalProfileState()) {
    on<LoadProfessionalProfileEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // Simulating some loading if needed, though we already have the model
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(isLoading: false, professional: event.professional));
    });
  }
}
