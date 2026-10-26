part of 'professional_list_bloc.dart';

abstract class ProfessionalListEvent {}

class FetchProfessionalsEvent extends ProfessionalListEvent {
  final String category;
  FetchProfessionalsEvent(this.category);
}
