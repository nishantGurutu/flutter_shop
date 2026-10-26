part of 'booking_bloc.dart';

class BookingState {
  final int currentStep;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;

  BookingState({
    this.currentStep = 0,
    this.selectedDate,
    this.selectedTimeSlot,
  });

  BookingState copyWith({
    int? currentStep,
    DateTime? selectedDate,
    String? selectedTimeSlot,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
    );
  }
}
