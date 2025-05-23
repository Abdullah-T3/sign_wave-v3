import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:characters/characters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sign_wave_v3/core/Responsive/Models/device_info.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/common/cherryToast/CherryToastMsgs.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/features/home/data/model/chat_message.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/cubits/chat_cubit.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/cubits/chat_state.dart'
    show ChatState, ChatStatus;
import '../../../../core/common/send_call_button.dart';
import '../../../../core/helper/format_name.dart';
import '../../../../core/services/di.dart' show getIt;
import '../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../core/theming/styles.dart' show TextStyles;
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
    print("receiver id ${widget.receiverId}");
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
      print("lolololololo" + message);
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
      print("lolololololo" + message);
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
            leading: const BackButton(color: Colors.white),
            backgroundColor: ColorsManager.blue,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorsManager.lightBlue,
                  child: Text(
                    widget.receiverName[0].toUpperCase(),
                    style: TextStyles.buttonsTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: deviceInfo.screenWidth * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatName(widget.receiverName),
                      style: TextStyles.title.copyWith(
                        color: Colors.white,
                        fontSize: deviceInfo.screenWidth * 0.038,
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
                                  color: Colors.green.withOpacity(0.8),
                                ),
                              ),
                            ],
                          );
                        }
                        if (state.isReceiverOnline) {
                          return Text(
                            context.tr('online'),
                            style: TextStyles.title.copyWith(
                              color: Colors.green,
                              fontSize: deviceInfo.screenWidth * 0.037,
                            ),
                          );
                        }
                        if (state.receiverLastSeen != null) {
                          final lastSeen = state.receiverLastSeen!.toDate();
                          return Text(
                            "${context.tr('last_seen_at')} ${DateFormat('h:mm a').format(lastSeen)}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: deviceInfo.screenWidth * 0.035,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              SendCallButton(
                userID: widget.receiverId,
                userName: widget.receiverName,
                onCallFinished: onSendCallInvitationFinished,
              ),
              SizedBox(width: deviceInfo.screenWidth * 0.01),
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
                        print(
                          "messages status ${state.messages[index].status}",
                        );
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
                    Padding(
                      padding: EdgeInsets.all(deviceInfo.screenWidth * 0.02),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showEmoji = !_showEmoji;
                                    if (_showEmoji) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  });
                                },
                                icon: const Icon(Icons.emoji_emotions),
                              ),
                              SizedBox(width: deviceInfo.screenWidth * 0.02),
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
                                  decoration: InputDecoration(
                                    hintText: context.tr('type_a_message'),
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: deviceInfo.screenWidth * 0.03,
                                      vertical: deviceInfo.screenHeight * 0.01,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    fillColor: Theme.of(context).cardColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: deviceInfo.screenWidth * 0.02),
                              IconButton(
                                onPressed:
                                    _isComposing ? _handleSendMessage : null,
                                icon: Icon(
                                  Icons.send,
                                  color:
                                      _isComposing
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.primary
                                          : Colors.grey,
                                ),
                              ),
                            ],
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

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.deviceInfo,
  });
  final DeviceInfo deviceInfo;
  @override
  Widget build(BuildContext context) {
    final double bubbleMaxWidth = deviceInfo.screenWidth * 0.75;
    final double fontSize = deviceInfo.screenWidth * 0.04;
    final double timestampSize = deviceInfo.screenWidth * 0.03;
    final double iconSize = deviceInfo.screenWidth * 0.035;
    final double padding = deviceInfo.screenWidth * 0.03;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
        margin: EdgeInsets.only(
          left: isMe ? deviceInfo.screenWidth * 0.15 : padding,
          right: isMe ? padding : deviceInfo.screenWidth * 0.15,
          bottom: deviceInfo.screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color:
              isMe
                  ? ColorsManager.blue
                  : Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFEEF2F7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 16 : 4),
            topRight: Radius.circular(isMe ? 4 : 16),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 16 : 4),
            topRight: Radius.circular(isMe ? 4 : 16),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('message_options'))),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: deviceInfo.screenHeight * 0.01,
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        color:
                            isMe
                                ? Colors.white
                                : Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.white.withOpacity(0.9)
                                : Colors.black87,
                        fontSize: fontSize,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat(
                            'h:mm a',
                          ).format(message.timestamp.toDate()),
                          style: TextStyle(
                            color:
                                isMe
                                    ? Colors.white70
                                    : Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white60
                                    : Colors.black54,
                            fontSize: timestampSize,
                          ),
                        ),
                        if (isMe) ...[
                          SizedBox(width: deviceInfo.screenWidth * 0.01),
                          Icon(
                            message.status == MessageStatus.read
                                ? Icons.done_all
                                : Icons.done,
                            size: iconSize,
                            color:
                                message.status == MessageStatus.read
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
    );
  }
}
