import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/common/cherryToast/cherry_toast_msgs.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/features/home/data/model/chat_message.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/cubits/chat_cubit.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/cubits/chat_state.dart'
    show ChatState, ChatStatus;

import '../../../../core/helper/format_name.dart';
import '../../../../core/services/di.dart' show getIt;
import '../../../../core/theming/colors.dart' show ColorsManager;
import '../widgets/loading_dots.dart';

class ChatMessageScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  const ChatMessageScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final TextEditingController messageController = TextEditingController();
  late final ChatCubit _chatCubit;
  final _scrollController = ScrollController();
  List<ChatMessage> _previousMessages = [];
  bool _isComposing = false;
  bool _showEmoji = false;

  @override
  void initState() {
    _chatCubit = getIt<ChatCubit>();
    _chatCubit.enterChat(widget.receiverId);
    messageController.addListener(_onTextChanged);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  Future<void> _handleSendMessage() async {
    final messageText = messageController.text.trim();
    messageController.clear();
    await _chatCubit.sendMessage(
      content: messageText,
      receiverId: widget.receiverId,
      receiverName: widget.receiverName,
    );
  }

  void _onScroll() {
    // Load more messages when reaching the top
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _chatCubit.loadMoreMessages();
    }
  }

  void _onTextChanged() {
    final isComposing = messageController.text.isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() {
        _isComposing = isComposing;
      });
      if (isComposing) {
        _chatCubit.startTyping();
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _hasNewMessages(List<ChatMessage> messages) {
    if (messages.length != _previousMessages.length) {
      _scrollToBottom();
      _previousMessages = messages;
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    _chatCubit.leaveChat();
    super.dispose();
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      var userIDs = '';
      for (var index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        final userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = "User doesn't exist or is offline: $userIDs";
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      InfoWidget(
        builder: (context, deviceInfo) {
          return CherryToastMsgs.CherryToastError(
            info: deviceInfo,
            context: context,
            title: code,
            description: message,
          );
        },
      );
      // showToast(
      //   message,
      //   position: StyledToastPosition.top,
      //   context: context,
      // );
    } else if (code.isNotEmpty) {
      InfoWidget(
        builder: (context, deviceInfo) {
          return CherryToastMsgs.CherryToastError(
            info: deviceInfo,
            context: context,
            title: code,
            description: message,
          );
        },
      );
      // showToast(
      //   'code: $code, message:$message',
      //   position: StyledToastPosition.top,
      //   context: context,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ColorsManager.blue,
            leading: Container(
              margin: EdgeInsets.all(deviceInfo.screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        ColorsManager.lightBlue,
                        Colors.white.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.lightBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: deviceInfo.screenWidth * 0.06,
                    backgroundColor: Colors.transparent,
                    child: Text(
                      widget.receiverName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: deviceInfo.screenWidth * 0.045,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: deviceInfo.screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatName(widget.receiverName),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceInfo.screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      BlocBuilder<ChatCubit, ChatState>(
                        bloc: _chatCubit,
                        builder: (context, state) {
                          if (state.isReceiverTyping) {
                            return Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    right: deviceInfo.screenWidth * 0.01,
                                  ),
                                  child: const LoadingDots(),
                                ),
                                Text(
                                  context.tr('typing'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: deviceInfo.screenWidth * 0.035,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          }
                          if (state.isReceiverOnline) {
                            return Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.5),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: deviceInfo.screenWidth * 0.02),
                                Text(
                                  context.tr('online'),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: deviceInfo.screenWidth * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          }
                          if (state.receiverLastSeen != null) {
                            final lastSeen = state.receiverLastSeen!.toDate();
                            return Text(
                              "${context.tr('last_seen_at')} ${DateFormat('h:mm a').format(lastSeen)}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: deviceInfo.screenWidth * 0.032,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Call button hidden - uncomment below to re-enable
              // Container(
              //   margin: EdgeInsets.only(right: deviceInfo.screenWidth * 0.02),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: BlocBuilder<AuthCubit, AuthState>(
              //     bloc: getIt<AuthCubit>(),
              //     builder: (context, authState) {
              //       if (authState.status == AuthStatus.authenticated &&
              //           authState.user != null) {
              //         return JitsiCallButton(
              //           userID: widget.receiverId,
              //           userName: widget.receiverName,
              //           userAvatar: '', // TODO: Get user avatar from user data
              //           callerID: authState.user!.uid,
              //           callerName: authState.user!.fullName,
              //           callerAvatar:
              //               '', // TODO: Get caller avatar from user data
              //           calleeFcmToken:
              //               '', // TODO: Get FCM token from user data
              //           onCallFinished: onSendCallInvitationFinished,
              //         );
              //       }
              //       return const SizedBox.shrink();
              //     },
              //   ),
              // ),
              BlocBuilder<ChatCubit, ChatState>(
                bloc: _chatCubit,
                builder: (context, state) {
                  if (state.isUserBlocked) {
                    return TextButton.icon(
                      onPressed:
                          () => _chatCubit.unBlockUser(widget.receiverId),
                      label: const Text("Unblock"),
                      icon: Icon(Icons.block, color: Colors.red),
                    );
                  }
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) async {
                      if (value == "block") {
                        final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  "Are you sure you want to block ${widget.receiverName}",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text(
                                      "Block",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          await _chatCubit.blockUser(widget.receiverId);
                        }
                      }
                    },
                    itemBuilder:
                        (context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem(
                            value: 'block',
                            child: Text("Block User"),
                          ),
                        ],
                  );
                },
              ),
            ],
          ),
          body: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              _hasNewMessages(state.messages);
            },
            bloc: _chatCubit,
            builder: (context, state) {
              if (state.status == ChatStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == ChatStatus.error) {
                return Center(
                  child: Text(state.error ?? "Something went wrong"),
                );
              }
              return Column(
                children: [
                  if (state.amIBlocked)
                    Container(
                      padding: EdgeInsets.all(deviceInfo.screenWidth * 0.02),
                      color: Colors.red.withOpacity(0.1),
                      child: Text(
                        "You have been blocked by ${widget.receiverName}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe =
                            message.senderId == _chatCubit.userData.uid;
                        return MessageBubble(
                          message: message,
                          isMe: isMe,
                          deviceInfo: deviceInfo,
                        );
                      },
                    ),
                  ),
                  if (!state.amIBlocked && !state.isUserBlocked)
                    Container(
                      padding: EdgeInsets.all(deviceInfo.screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color:
                                    _isComposing
                                        ? ColorsManager.lightBlue
                                        : Colors.grey.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Emoji button
                                Container(
                                  margin: EdgeInsets.all(
                                    deviceInfo.screenWidth * 0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _showEmoji
                                            ? ColorsManager.lightBlue
                                                .withOpacity(0.2)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showEmoji = !_showEmoji;
                                        if (_showEmoji) {
                                          FocusScope.of(context).unfocus();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.emoji_emotions,
                                      color:
                                          _showEmoji
                                              ? ColorsManager.lightBlue
                                              : Colors.grey[600],
                                    ),
                                  ),
                                ),

                                // Text input
                                Expanded(
                                  child: TextField(
                                    onTap: () {
                                      if (_showEmoji) {
                                        setState(() {
                                          _showEmoji = false;
                                        });
                                      }
                                    },
                                    controller: messageController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: 1,
                                    style: TextStyle(
                                      fontSize: deviceInfo.screenWidth * 0.04,
                                      color:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: context.tr('type_a_message'),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: deviceInfo.screenWidth * 0.04,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            deviceInfo.screenWidth * 0.02,
                                        vertical:
                                            deviceInfo.screenHeight * 0.015,
                                      ),
                                    ),
                                  ),
                                ),

                                // Send button
                                Container(
                                  margin: EdgeInsets.all(
                                    deviceInfo.screenWidth * 0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient:
                                        _isComposing
                                            ? LinearGradient(
                                              colors: [
                                                ColorsManager.lightBlue,
                                                ColorsManager.blue,
                                              ],
                                            )
                                            : null,
                                    color:
                                        !_isComposing ? Colors.grey[300] : null,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow:
                                        _isComposing
                                            ? [
                                              BoxShadow(
                                                color: ColorsManager.lightBlue
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                            : null,
                                  ),
                                  child: IconButton(
                                    onPressed:
                                        _isComposing
                                            ? _handleSendMessage
                                            : null,
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color:
                                          _isComposing
                                              ? Colors.white
                                              : Colors.grey[600],
                                      size: deviceInfo.screenWidth * 0.05,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_showEmoji)
                            SizedBox(
                              height: deviceInfo.screenHeight * 0.4,
                              child: EmojiPicker(
                                textEditingController: messageController,
                                onEmojiSelected: (category, emoji) {
                                  final cursorPos =
                                      messageController.selection.baseOffset;
                                  final text = messageController.text;
                                  final newText =
                                      cursorPos >= 0
                                          ? text.substring(0, cursorPos) +
                                              emoji.emoji +
                                              text.substring(cursorPos)
                                          : text + emoji.emoji;
                                  messageController.text = newText;
                                  messageController
                                      .selection = TextSelection.fromPosition(
                                    TextPosition(
                                      offset:
                                          cursorPos >= 0
                                              ? cursorPos + emoji.emoji.length
                                              : newText.length,
                                    ),
                                  );
                                  setState(() {
                                    _isComposing =
                                        messageController.text.isNotEmpty;
                                  });
                                },
                                onBackspacePressed: () {
                                  messageController
                                    ..text =
                                        messageController.text.characters
                                            .skipLast(1)
                                            .toString()
                                    ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: messageController.text.length,
                                      ),
                                    );
                                },
                                config: Config(
                                  height: deviceInfo.screenHeight * 0.4,
                                  emojiViewConfig: EmojiViewConfig(
                                    columns: 7,
                                    emojiSizeMax:
                                        32.0 * (Platform.isIOS ? 1.30 : 1.0),
                                    verticalSpacing: 0,
                                    horizontalSpacing: 0,
                                    gridPadding: EdgeInsets.zero,
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                    loadingIndicator: const SizedBox.shrink(),
                                  ),
                                  categoryViewConfig: const CategoryViewConfig(
                                    initCategory: Category.RECENT,
                                  ),
                                  bottomActionBarConfig: BottomActionBarConfig(
                                    enabled: true,
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                    buttonColor: Theme.of(context).primaryColor,
                                  ),
                                  skinToneConfig: const SkinToneConfig(
                                    enabled: true,
                                    dialogBackgroundColor: Colors.white,
                                    indicatorColor: Colors.grey,
                                  ),
                                  searchViewConfig: SearchViewConfig(
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                    buttonIconColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isMe;
  final DeviceInfo deviceInfo;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.deviceInfo,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bubbleMaxWidth = widget.deviceInfo.screenWidth * 0.75;
    final double fontSize = widget.deviceInfo.screenWidth * 0.04;
    final double timestampSize = widget.deviceInfo.screenWidth * 0.03;
    final double iconSize = widget.deviceInfo.screenWidth * 0.035;
    final double padding = widget.deviceInfo.screenWidth * 0.03;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Align(
              alignment:
                  widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
                margin: EdgeInsets.only(
                  left:
                      widget.isMe
                          ? widget.deviceInfo.screenWidth * 0.15
                          : padding,
                  right:
                      widget.isMe
                          ? padding
                          : widget.deviceInfo.screenWidth * 0.15,
                  bottom: widget.deviceInfo.screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  gradient:
                      widget.isMe
                          ? LinearGradient(
                            colors: [
                              ColorsManager.blue,
                              ColorsManager.lightBlue,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color:
                      !widget.isMe
                          ? isDark
                              ? const Color(0xFF2A2A2A)
                              : const Color(0xFFEEF2F7)
                          : null,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.isMe ? 20 : 4),
                    topRight: Radius.circular(widget.isMe ? 4 : 20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          widget.isMe
                              ? ColorsManager.lightBlue.withOpacity(0.3)
                              : Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.isMe ? 20 : 4),
                    topRight: Radius.circular(widget.isMe ? 4 : 20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.tr('message_options')),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: padding,
                          vertical: widget.deviceInfo.screenHeight * 0.012,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              widget.isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.message.content,
                              style: TextStyle(
                                color:
                                    widget.isMe
                                        ? Colors.white
                                        : isDark
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.black87,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat(
                                    'h:mm a',
                                  ).format(widget.message.timestamp.toDate()),
                                  style: TextStyle(
                                    color:
                                        widget.isMe
                                            ? Colors.white70
                                            : isDark
                                            ? Colors.white60
                                            : Colors.black54,
                                    fontSize: timestampSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (widget.isMe) ...[
                                  SizedBox(
                                    width:
                                        widget.deviceInfo.screenWidth * 0.015,
                                  ),
                                  Icon(
                                    widget.message.status == MessageStatus.read
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: iconSize,
                                    color:
                                        widget.message.status ==
                                                MessageStatus.read
                                            ? Colors.lightBlueAccent
                                            : Colors.white70,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
