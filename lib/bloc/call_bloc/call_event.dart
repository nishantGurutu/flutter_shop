part of 'call_bloc.dart';

abstract class CallEvent {}

class StartTimer extends CallEvent {}

class UpdateTimer extends CallEvent {
  final String duration;
  UpdateTimer(this.duration);
}

class ToggleSpeaker extends CallEvent {}

class ToggleMute extends CallEvent {}

class ToggleVideo extends CallEvent {}

class MovePip extends CallEvent {
  final Offset position;
  MovePip(this.position);
}
