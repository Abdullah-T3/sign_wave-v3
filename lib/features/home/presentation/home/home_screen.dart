import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/localization/app_localizations.dart';
import 'package:sign_wave_v3/features/home/presentation/about/about_screen.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/chat_massage_screen.dart';
import 'package:animations/animations.dart';
import 'package:sign_wave_v3/features/home/presentation/profile/cubit/profile_cubit.dart';
import '../../../../core/common/call_status_widget.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../data/repo/chat_repository.dart';
import '../../data/repo/contact_repository.dart';
import '../../../../../core/services/di.dart';
import '../widgets/chat_list_tile.dart';
import '../../../../../router/app_router.dart';
import '../translator/translator_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ContactRepository _contactRepository;
  late final ChatRepository _chatRepository;
  late final String _currentUserId;
  int _selectedIndex = 0;

  @override
  void initState() {
    _contactRepository = getIt<ContactRepository>();
    _chatRepository = getIt<ChatRepository>();
    _currentUserId = getIt<AuthRepository>().currentUser?.uid ?? "";

    super.initState();
  }

  void _showContactsList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return InfoWidget(
          builder: (context, deviceInfo) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'All Users',
                    style: TextStyle(
                      fontSize: deviceInfo.screenWidth * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _contactRepository.getAllRegisteredUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(context.tr('No_users_found')),
                          );
                        }
                        final users = snapshot.data!;
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final userName = user["name"] ?? "Unknown";
                            final username = user["username"] ?? "";
                            final userInitial =
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : "U";
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                child: Text(userInitial),
                              ),
                              title: Text(userName),
                              subtitle:
                                  username.isNotEmpty
                                      ? Text("@$username")
                                      : null,
                              onTap: () {
                                getIt<AppRouter>().push(
                                  ChatMessageScreen(
                                    receiverId: user['id'],
                                    receiverName: user['name'],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _getBody(deviceInfo) {
    switch (_selectedIndex) {
      case 0:
        return StreamBuilder(
          stream: _chatRepository.getChatRooms(_currentUserId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("error:${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final chats = snapshot.data!;
            if (chats.isEmpty) {
              return Center(child: Text(context.tr('No_recent_chats')));
            }
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatListTile(
                  chat: chat,
                  currentUserId: _currentUserId,
                  onTap: () {
                    final otherUserId = chat.participants.firstWhere(
                      (id) => id != _currentUserId,
                    );
                    final otherUserName =
                        chat.participantsName?[otherUserId] ??
                        context.tr('unknownUser');
                    getIt<AppRouter>().push(
                      ChatMessageScreen(
                        receiverId: otherUserId,
                        receiverName: otherUserName,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      case 1:
        return const TranslatorScreen();
      case 2:
        return BlocProvider(
          create:
              (context) =>
                  ProfileCubit(authRepository: getIt<AuthRepository>()),
          child: const ProfileScreen(),
        );
      case 3:
        return const AboutScreen();
      default:
        return const Center(child: Text("Page not found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
    );
    return SafeArea(
      child: InfoWidget(
        builder: (context, deviceInfo) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Modern App Bar
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          deviceInfo.screenWidth * 0.05,
                        ),
                        bottomRight: Radius.circular(
                          deviceInfo.screenWidth * 0.05,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: deviceInfo.screenWidth * 0.04,
                          vertical: deviceInfo.screenHeight * 0.02,
                        ),
                        child: Row(
                          children: [
                            // App Logo
                            Container(
                              height: deviceInfo.screenHeight * 0.06,
                              width: deviceInfo.screenHeight * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: deviceInfo.screenWidth * 0.03),
                            // App Title
                            Expanded(
                              child: Text(
                                _getAppBarTitle(context),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceInfo.screenWidth * 0.05,
                                ),
                              ),
                            ),
                            // Status Indicator
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: deviceInfo.screenWidth * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Body Content
                  Expanded(
                    child: Column(
                      children: [
                        const CallStatusWidget(),
                        Expanded(
                          child: PageTransitionSwitcher(
                            transitionBuilder: (
                              child,
                              primaryAnimation,
                              secondaryAnimation,
                            ) {
                              return FadeThroughTransition(
                                animation: primaryAnimation,
                                secondaryAnimation: secondaryAnimation,
                                child: child,
                              );
                            },
                            child: _getBody(deviceInfo),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.6),
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 0
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _selectedIndex == 0
                            ? Icons.chat_bubble
                            : Icons.chat_bubble_outline,
                        size: 24,
                      ),
                    ),
                    label: context.tr('chats'),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 1
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _selectedIndex == 1
                            ? Icons.translate
                            : Icons.translate_outlined,
                        size: 24,
                      ),
                    ),
                    label: context.tr('translator'),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 2
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _selectedIndex == 2
                            ? Icons.person
                            : Icons.person_outline,
                        size: 24,
                      ),
                    ),
                    label: context.tr('profile'),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 3
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _selectedIndex == 3 ? Icons.info : Icons.info_outline,
                        size: 24,
                      ),
                    ),
                    label: context.tr('about'),
                  ),
                ],
              ),
            ),
            floatingActionButton:
                _selectedIndex == 0
                    ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        onPressed: () => _showContactsList(context),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: const Icon(
                          Icons.add_comment,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : null,
          );
        },
      ),
    );
  }

  // Get the AppBar title based on the selected index
  String _getAppBarTitle(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return context.tr('chats');
      case 1:
        return context.tr('translator');
      case 2:
        return context.tr('profile');
      default:
        return context.tr('chats');
    }
  }
}
