part of 'home_bloc.dart';

class HomeState extends BaseState {
  final int selectedIndex;
  final List<UserModel> users;
  final String searchQuery;

  const HomeState({
    this.selectedIndex = 1,
    this.users = const [],
    this.searchQuery = '',
    super.isLoading,
    super.error,
  });

  @override
  HomeState copyWith({
    int? selectedIndex,
    List<UserModel>? users,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      users: users ?? this.users,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    users,
    searchQuery,
    isLoading,
    error,
  ];
}
