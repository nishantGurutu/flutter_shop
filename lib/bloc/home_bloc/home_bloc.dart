import 'package:shop/core/base_classes.dart';
import 'package:shop/model/home/home_model.dart';
import 'package:shop/repository/home_api/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeState()) {
    on<TabChanged>(_onTabChanged);
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
  }

  void _onTabChanged(TabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onFetchUsers(FetchUsers event, Emitter<HomeState> emit) async {
    await handleAsyncOperation(() async {
      final users = await homeRepository.fetchUsers();
      emit(state.copyWith(users: users));
    }, errorMessage: 'Failed to load users');
  }

  void _onSearchUsers(SearchUsers event, Emitter<HomeState> emit) async {
    if (event.query.isEmpty) {
      add(const FetchUsers());
      return;
    }

    await handleAsyncOperation(() async {
      final users = await homeRepository.searchUsers(event.query);
      emit(state.copyWith(users: users, searchQuery: event.query));
    }, errorMessage: 'Failed to search users');
  }
}
