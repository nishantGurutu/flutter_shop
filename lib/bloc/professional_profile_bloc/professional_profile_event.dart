part of 'professional_profile_bloc.dart';

abstract class ProfessionalProfileEvent {}

class LoadProfessionalProfileEvent extends ProfessionalProfileEvent {
  final ProfessionalModel professional;
  LoadProfessionalProfileEvent(this.professional);
}
