import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc/navigation/navigatin_event.dart';
import 'package:shop/bloc/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<ChangeTabEvent>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}
