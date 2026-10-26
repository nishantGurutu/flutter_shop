part of 'call_bloc.dart';

class CallState {
  final String duration;
  final bool isSpeakerOn;
  final bool isMuted;
  final bool isVideoOn;
  final Offset pipPosition;

  CallState({
    this.duration = '00:00',
    this.isSpeakerOn = false,
    this.isMuted = false,
    this.isVideoOn = true,
    this.pipPosition = Offset.zero,
  });

  CallState copyWith({
    String? duration,
    bool? isSpeakerOn,
    bool? isMuted,
    bool? isVideoOn,
    Offset? pipPosition,
  }) {
    return CallState(
      duration: duration ?? this.duration,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isMuted: isMuted ?? this.isMuted,
      isVideoOn: isVideoOn ?? this.isVideoOn,
      pipPosition: pipPosition ?? this.pipPosition,
    );
  }
}
