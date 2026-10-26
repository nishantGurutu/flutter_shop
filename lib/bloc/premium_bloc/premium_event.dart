part of 'premium_bloc.dart';

abstract class PremiumEvent {}

class LoadPremiumPackages extends PremiumEvent {}

class SelectPackage extends PremiumEvent {
  final int index;
  SelectPackage(this.index);
}
