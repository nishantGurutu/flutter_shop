import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';
import 'package:shop/model/chat_item_model.dart';

abstract class ChatRepository extends BaseRepository<ChatItem> {
  Future<List<String>> fetchMatches();
  Future<List<ChatItem>> fetchMessages();
  Future<List<Map<String, dynamic>>> fetchVisitors();
}

class ChatHttpRepository implements ChatRepository {
  final NetworkService _networkService;

  ChatHttpRepository(this._networkService);

  @override
  Future<List<ChatItem>> getAll() async {
    return await fetchMessages();
  }

  @override
  Future<ChatItem?> getById(String id) async {
    final messages = await fetchMessages();
    final filtered = messages.where((msg) => msg.name == id);
    return filtered.isEmpty ? null : filtered.first;
  }

  @override
  Future<ChatItem> create(ChatItem item) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return item;
  }

  @override
  Future<ChatItem> update(String id, ChatItem item) async {
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
  Future<List<String>> fetchMatches() async {
    return [
      "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600",
      "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=600",
      "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=600",
      "https://images.pexels.com/photos/1587009/pexels-photo-1587009.jpeg?auto=compress&cs=tinysrgb&w=600",
      "https://images.pexels.com/photos/1462637/pexels-photo-1462637.jpeg?auto=compress&cs=tinysrgb&w=600",
    ];
  }

  @override
  Future<List<ChatItem>> fetchMessages() async {
    return [
      const ChatItem(
        name: "Emma Stone",
        message: "You : See you then.",
        timeLabel: "Now",
        unreadCount: 0,
        isVerified: true,
        imageUrl:
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600",
      ),
      const ChatItem(
        name: "Matheus",
        message: "Hey! How have you been?",
        timeLabel: "10:30 AM",
        unreadCount: 2,
        imageUrl:
            "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=600",
      ),
      const ChatItem(
        name: "Lily",
        message: "The movie was great!",
        timeLabel: "Yesterday",
        unreadCount: 0,
        imageUrl:
            "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=600",
      ),
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchVisitors() async {
    return [
      {
        "name": "Lily James",
        "age": 22,
        "isVerified": true,
        "imageUrl":
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600",
        "time": "5 min ago",
      },
    ];
  }
}
