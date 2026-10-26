part of 'update_profile_bloc.dart';

class UpdateProfileState {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String countryCode;
  final String email;
  final String gender;
  final String address;
  final String imageUrl;
  final bool isSaving;

  UpdateProfileState({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.countryCode,
    required this.email,
    required this.gender,
    required this.address,
    required this.imageUrl,
    this.isSaving = false,
  });

  UpdateProfileState copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? countryCode,
    String? email,
    String? gender,
    String? address,
    String? imageUrl,
    bool? isSaving,
  }) {
    return UpdateProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
