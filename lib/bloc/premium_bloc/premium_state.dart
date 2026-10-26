part of 'premium_bloc.dart';

class PremiumState {
  final int selectedIndex;
  final List<PremiumPackage> packages;

  PremiumState({required this.selectedIndex, required this.packages});

  PremiumState copyWith({int? selectedIndex, List<PremiumPackage>? packages}) {
    return PremiumState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      packages: packages ?? this.packages,
    );
  }
}
