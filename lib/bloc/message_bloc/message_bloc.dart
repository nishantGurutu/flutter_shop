import 'package:shop/model/chat_message_model.dart';
import 'package:shop/repository/message_api/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;

  MessageBloc({required this.messageRepository})
    : super(MessageState(messages: [])) {
    on<LoadMessages>((event, emit) async {
      final messages = await messageRepository.fetchMessages();
      emit(state.copyWith(messages: messages));
    });

    on<SendMessage>((event, emit) async {
      final newMessages = List<ChatMessage>.from(state.messages)
        ..add(
          ChatMessage(
            text: event.text,
            isSent: true,
            time: "Now",
            isRead: false,
          ),
        );
      emit(state.copyWith(messages: newMessages));
      await messageRepository.sendMessage(event.text);
    });

    on<ToggleEmoji>((event, emit) {
      emit(state.copyWith(showEmoji: !state.showEmoji));
    });
  }
}
