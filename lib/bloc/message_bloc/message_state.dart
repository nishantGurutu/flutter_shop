part of 'message_bloc.dart';

class MessageState {
  final List<ChatMessage> messages;
  final bool showEmoji;
  final bool isTyping;

  MessageState({
    required this.messages,
    this.showEmoji = false,
    this.isTyping = false,
  });

  MessageState copyWith({
    List<ChatMessage>? messages,
    bool? showEmoji,
    bool? isTyping,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      showEmoji: showEmoji ?? this.showEmoji,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
