import 'package:shop/model/chat_item_model.dart';
import 'package:shop/repository/chat_api/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository})
    : super(ChatState(matches: [], messages: [], visitors: [])) {
    on<LoadChatData>((event, emit) async {
      emit(state.copyWith(/* Add loading state if state class supports it */));
      final matches = await chatRepository.fetchMatches();
      final messages = await chatRepository.fetchMessages();
      final visitors = await chatRepository.fetchVisitors();
      emit(
        state.copyWith(
          matches: matches,
          messages: messages,
          visitors: visitors,
        ),
      );
    });
  }
}
