part of 'chat_bloc.dart';

class ChatState {
  final List<String> matches;
  final List<ChatItem> messages;
  final List<Map<String, dynamic>> visitors;

  ChatState({
    required this.matches,
    required this.messages,
    required this.visitors,
  });

  ChatState copyWith({
    List<String>? matches,
    List<ChatItem>? messages,
    List<Map<String, dynamic>>? visitors,
  }) {
    return ChatState(
      matches: matches ?? this.matches,
      messages: messages ?? this.messages,
      visitors: visitors ?? this.visitors,
    );
  }
}
