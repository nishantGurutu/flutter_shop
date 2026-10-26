part of 'home_bloc.dart';

abstract class HomeEvent extends BaseEvent {
  const HomeEvent();
}

class TabChanged extends HomeEvent {
  final int index;
  const TabChanged(this.index);

  @override
  List<Object> get props => [index];
}

class FetchUsers extends HomeEvent {
  const FetchUsers();
}

class SearchUsers extends HomeEvent {
  final String query;
  const SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}
