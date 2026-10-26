import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';
import 'package:shop/model/chat_message_model.dart';

abstract class MessageRepository extends BaseRepository<ChatMessage> {
  Future<List<ChatMessage>> fetchMessages();
  Future<void> sendMessage(String text);
}

class MessageHttpRepository implements MessageRepository {
  final NetworkService _networkService;

  MessageHttpRepository(this._networkService);

  @override
  Future<List<ChatMessage>> getAll() async {
    return await fetchMessages();
  }

  @override
  Future<ChatMessage?> getById(String id) async {
    final messages = await fetchMessages();
    final filtered = messages.where((msg) => msg.text.contains(id));
    return filtered.isEmpty ? null : filtered.first;
  }

  @override
  Future<ChatMessage> create(ChatMessage item) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<ChatMessage> update(String id, ChatMessage item) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<void> delete(String id) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<ChatMessage>> fetchMessages() async {
    return [
      ChatMessage(
        text: "Hi Dear, welcome back to the session",
        isSent: false,
        time: "10:30 AM",
        isRead: true,
      ),
      ChatMessage(
        text: "Hello Matheus, how are you?",
        isSent: true,
        time: "10:32 AM",
        isRead: true,
      ),
      ChatMessage(
        text: "I am doing well, thank you!",
        isSent: false,
        time: "10:33 AM",
        isRead: false,
      ),
    ];
  }

  @override
  Future<void> sendMessage(String text) async {
    // Mock sending message
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
