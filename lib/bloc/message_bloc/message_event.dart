part of 'message_bloc.dart';

abstract class MessageEvent {}

class LoadMessages extends MessageEvent {}

class SendMessage extends MessageEvent {
  final String text;
  SendMessage(this.text);
}

class ToggleEmoji extends MessageEvent {}
