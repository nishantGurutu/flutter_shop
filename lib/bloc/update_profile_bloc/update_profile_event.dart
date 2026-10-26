part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent {}

class UpdateField extends UpdateProfileEvent {
  final String field;
  final String value;
  UpdateField(this.field, this.value);
}

class SaveProfile extends UpdateProfileEvent {}

class LoadProfile extends UpdateProfileEvent {}

class UpdateProfileImage extends UpdateProfileEvent {
  final String imageUrl;
  UpdateProfileImage(this.imageUrl);
}
