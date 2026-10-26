import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  Timer? _timer;
  int _seconds = 0;
  int _minutes = 0;

  CallBloc() : super(CallState()) {
    on<StartTimer>((event, emit) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _seconds++;
        if (_seconds >= 60) {
          _minutes++;
          _seconds = 0;
        }
        final formatted =
            '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}';
        add(UpdateTimer(formatted));
      });
    });

    on<UpdateTimer>((event, emit) {
      emit(state.copyWith(duration: event.duration));
    });

    on<ToggleSpeaker>((event, emit) {
      emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
    });

    on<ToggleMute>((event, emit) {
      emit(state.copyWith(isMuted: !state.isMuted));
    });

    on<ToggleVideo>((event, emit) {
      emit(state.copyWith(isVideoOn: !state.isVideoOn));
    });

    on<MovePip>((event, emit) {
      emit(state.copyWith(pipPosition: event.position));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
