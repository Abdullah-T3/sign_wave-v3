import 'package:flutter/material.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';

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
      child: InfoWidget(
        builder: (context, deviceInfo) {
          return InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: deviceInfo.screenWidth * 0.04,
                vertical: deviceInfo.screenHeight * 0.01,
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF135CAF), // App's primary blue
                          const Color(0xFF40C4FF), // App's light blue
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF40C4FF).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: deviceInfo.screenWidth * 0.06,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceInfo.screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: deviceInfo.screenWidth * 0.03),

                  // Message content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat.lastMessage ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Time and notification count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Time
                      Text(
                        _getFormattedTime(),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(height: 5),

                      // Notification count
                      StreamBuilder<int>(
                        stream: getIt<ChatRepository>().getUnreadCount(
                          chat.id,
                          currentUserId,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == 0) {
                            return const SizedBox(height: 20);
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF40C4FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              snapshot.data.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFormattedTime() {
    if (chat.lastMessageTime == null) return '';

    final dateTime = chat.lastMessageTime!.toDate();
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
