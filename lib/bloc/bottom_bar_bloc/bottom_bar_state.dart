part of 'bottom_bar_bloc.dart';

class BottomBarState extends Equatable {
  final int currentIndex;

  const BottomBarState({this.currentIndex = 0});

  BottomBarState copyWith({int? currentIndex}) {
    return BottomBarState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object> get props => [currentIndex];
}
