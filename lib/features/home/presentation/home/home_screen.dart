import 'package:flutter/material.dart';
import 'package:sign_wave_v3/core/Responsive/ui_component/info_widget.dart';
import 'package:sign_wave_v3/core/theming/styles.dart';
import 'package:sign_wave_v3/features/home/presentation/chat/chat_massage_screen.dart';
import 'package:animations/animations.dart';

import '../../../auth/data/repositories/auth_repository.dart';
import '../../data/repo/chat_repository.dart';
import '../../data/repo/contact_repository.dart';
import '../../../../../core/services/di.dart';
import '../../../auth/logic/auth/auth_cubit.dart';
import '../../../auth/screens/auth/login_screen.dart';
import '../widgets/chat_list_tile.dart';
import '../../../../../router/app_router.dart';
import '../about/about_screen.dart';
import '../translator/translator_screen.dart';

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
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Contacts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _contactRepository.getRegisteredUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No contacts found"));
                    }
                    final contacts = snapshot.data!;
                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        final contactName = contact["name"] ?? "Unknown";
                        final contactInitial =
                            contactName.isNotEmpty
                                ? contactName[0].toUpperCase()
                                : "U";
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Text(contactInitial),
                          ),
                          title: Text(contactName),
                          onTap: () {
                            getIt<AppRouter>().push(
                              ChatMessageScreen(
                                receiverId: contact['id'],
                                receiverName: contact['name'],
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
  }

  Widget _getBody(deviceInfo) {
    switch (_selectedIndex) {
      case 0:
        return StreamBuilder(
          stream: _chatRepository.getChatRooms(_currentUserId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text("error:${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final chats = snapshot.data!;
            if (chats.isEmpty) {
              return const Center(child: Text("No recent chats"));
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
                    print("home screen current user id $_currentUserId");
                    final otherUserName =
                        chat.participantsName?[otherUserId] ?? "Unknown";
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
        return const AboutScreen();
      default:
        return const Center(child: Text("Page not found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InfoWidget(
        builder: (context, deviceInfo) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              leading: Image.asset("assets/images/logo.png"),
              leadingWidth: deviceInfo.screenWidth * 0.2,
              title: Text(
                _selectedIndex == 0
                    ? "Chats"
                    : _selectedIndex == 1
                    ? "Translator"
                    : "About",
                style: TextStyles.title.copyWith(
                  fontSize: deviceInfo.screenWidth * 0.05,
                  color: Colors.white,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                    right: deviceInfo.screenWidth * 0.03,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await getIt<AuthCubit>().signOut();
                      getIt<AppRouter>().pushAndRemoveUntil(
                        const LoginScreen(),
                      );
                    },
                    child: Icon(
                      Icons.logout,
                      size: deviceInfo.screenWidth * 0.07,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: PageTransitionSwitcher(
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _getBody(deviceInfo),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.translate),
                  label: 'Translator',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
              ],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
            floatingActionButton:
                _selectedIndex == 0
                    ? FloatingActionButton(
                      onPressed: () => _showContactsList(context),
                      child: const Icon(Icons.chat, color: Colors.white),
                    )
                    : null,
          );
        },
      ),
    );
  }
}
