part of 'booking_bloc.dart';

abstract class BookingEvent {}

class SelectDateEvent extends BookingEvent {
  final DateTime date;
  SelectDateEvent(this.date);
}

class SelectTimeSlotEvent extends BookingEvent {
  final String slot;
  SelectTimeSlotEvent(this.slot);
}

class ProceedToNextStepEvent extends BookingEvent {
  final ProfessionalModel? professional;
  ProceedToNextStepEvent({this.professional});
}
