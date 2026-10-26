import 'package:shop/model/profile/premium_package_model.dart';
import 'package:shop/repository/premium_api/premium_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'premium_event.dart';
part 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final PremiumRepository premiumRepository;

  PremiumBloc({required this.premiumRepository})
    : super(PremiumState(selectedIndex: 1, packages: [])) {
    on<LoadPremiumPackages>((event, emit) async {
      final packages = await premiumRepository.fetchPackages();
      emit(state.copyWith(packages: packages));
    });

    on<SelectPackage>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}
