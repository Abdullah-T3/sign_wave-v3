import 'package:flutter/material.dart';

import '../../data/model/chat_room_model.dart';
import '../../data/repo/chat_repository.dart';
import '../../../../../core/services/di.dart';
import '../../../../../core/common/animation/slide_Transition__widget.dart';

class ChatListTile extends StatelessWidget {
  final ChatRoomModel chat;
  final String currentUserId;
  final VoidCallback onTap;
  const ChatListTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  String _getOtherUsername() {
    try {
      final otherUserId = chat.participants.firstWhere(
        (id) => id != currentUserId,
        orElse: () => 'Unknown User',
      );
      return chat.participantsName?[otherUserId] ?? "Unknown User";
    } catch (e) {
      return "Unknown User";
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _getOtherUsername();

    return SlideTransitionWidget(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(username.isNotEmpty ? username[0].toUpperCase() : '?'),
        ),
        title: Text(
          username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        trailing: StreamBuilder<int>(
          stream: getIt<ChatRepository>().getUnreadCount(
            chat.id,
            currentUserId,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == 0) {
              return const SizedBox();
            }
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                snapshot.data.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
