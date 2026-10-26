part of 'onbording_bloc.dart';

class OnbordingState {
  final int currentStep;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final bool isCompleted;

  const OnbordingState({
    this.currentStep = 0,
    this.selectedDate,
    this.selectedTimeSlot,
    this.isCompleted = false,
  });

  OnbordingState copyWith({
    int? currentStep,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    bool? isCompleted,
  }) {
    return OnbordingState(
      currentStep: currentStep ?? this.currentStep,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
