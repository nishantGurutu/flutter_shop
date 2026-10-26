import 'package:shop/repository/home_api/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UserRepository userRepository;

  UpdateProfileBloc({required this.userRepository})
    : super(
        UpdateProfileState(
          firstName: "",
          lastName: "",
          phoneNumber: "",
          countryCode: "",
          email: "",
          gender: "",
          address: "",
          imageUrl: "",
        ),
      ) {
    on<LoadProfile>((event, emit) async {
      final profile = await userRepository.fetchProfile();
      emit(
        state.copyWith(
          firstName: profile['firstName'],
          lastName: profile['lastName'],
          phoneNumber: profile['phoneNumber'],
          countryCode: profile['countryCode'],
          email: profile['email'],
          gender: profile['gender'],
          address: profile['address'],
          imageUrl: profile['imageUrl'],
        ),
      );
    });

    on<UpdateField>((event, emit) {
      switch (event.field) {
        case 'firstName':
          emit(state.copyWith(firstName: event.value));
          break;
        case 'lastName':
          emit(state.copyWith(lastName: event.value));
          break;
        case 'phoneNumber':
          emit(state.copyWith(phoneNumber: event.value));
          break;
        case 'email':
          emit(state.copyWith(email: event.value));
          break;
        case 'gender':
          emit(state.copyWith(gender: event.value));
          break;
        case 'address':
          emit(state.copyWith(address: event.value));
          break;
      }
    });

    on<UpdateProfileImage>((event, emit) {
      emit(state.copyWith(imageUrl: event.imageUrl));
    });

    on<SaveProfile>((event, emit) async {
      emit(state.copyWith(isSaving: true));
      await userRepository.updateProfile({
        'firstName': state.firstName,
        'lastName': state.lastName,
        'phoneNumber': state.phoneNumber,
        'email': state.email,
        'gender': state.gender,
        'address': state.address,
        'imageUrl': state.imageUrl,
      });
      emit(state.copyWith(isSaving: false));
    });
  }
}
