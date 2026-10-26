import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/model/professional/professional_model.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingState()) {
    on<SelectDateEvent>((event, emit) {
      emit(state.copyWith(selectedDate: event.date));
    });

    on<SelectTimeSlotEvent>((event, emit) {
      emit(state.copyWith(selectedTimeSlot: event.slot));
    });

    on<ProceedToNextStepEvent>((event, emit) {
      if (state.currentStep < 2) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      } else {
        // Submit booking logic
      }
    });
  }
}
