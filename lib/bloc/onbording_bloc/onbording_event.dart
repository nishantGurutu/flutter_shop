part of 'onbording_bloc.dart';

abstract class OnbordingEvent {
  const OnbordingEvent();
}

class PageChangedEvent extends OnbordingEvent {
  final int index;
  const PageChangedEvent(this.index);
}

class ProceedToNextStepEvent extends OnbordingEvent {
  const ProceedToNextStepEvent();
}

class CompleteOnbordingEvent extends OnbordingEvent {
  const CompleteOnbordingEvent();
}