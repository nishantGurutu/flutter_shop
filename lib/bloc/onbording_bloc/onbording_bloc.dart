import 'package:flutter_bloc/flutter_bloc.dart';

part 'onbording_event.dart';
part 'onbording_state.dart';

class OnbordingBloc extends Bloc<OnbordingEvent, OnbordingState> {
  OnbordingBloc() : super(const OnbordingState()) {
    on<PageChangedEvent>((event, emit) {
      emit(state.copyWith(currentStep: event.index));
    });

    on<ProceedToNextStepEvent>((event, emit) {
      if (state.currentStep < 2) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<CompleteOnbordingEvent>((event, emit) {
      emit(state.copyWith(isCompleted: true));
    });
  }
}