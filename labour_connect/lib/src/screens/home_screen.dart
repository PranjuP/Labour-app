import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../helper/helperfunctions.dart';
import 'feed_screen.dart';
import 'add_posting_screen.dart';
import 'profile_screen.dart';
import '../helper/authenticate.dart';

/// The main scaffold after login. Contains bottom navigation with:
///   0 — Feed (all postings)
///   1 — Add posting (FAB opens this screen)
///   2 — Profile / my posts
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final AuthMethods _auth = AuthMethods();

  final List<Widget> _pages = const [
    FeedScreen(),
    ProfileScreen(),
  ];

  Future<void> _logout() async {
    await HelperFunctions.clearAll();
    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Authenticate()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A4A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
                fontFamily: 'default', fontSize: 20, fontWeight: FontWeight.w600),
            children: [
              TextSpan(text: 'Labour', style: TextStyle(color: Colors.white)),
              TextSpan(
                  text: 'Connect',
                  style: TextStyle(color: Color(0xFF6EE89E))),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Logout?'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (confirm == true) _logout();
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddPostingScreen()),
          );
        },
        backgroundColor: const Color(0xFF1A4A2E),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Post',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        elevation: 4,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _currentIndex == 0
                            ? Icons.home_rounded
                            : Icons.home_outlined,
                        color: _currentIndex == 0
                            ? const Color(0xFF1A4A2E)
                            : Colors.grey.shade500,
                      ),
                      Text(
                        'Feed',
                        style: TextStyle(
                          fontSize: 11,
                          color: _currentIndex == 0
                              ? const Color(0xFF1A4A2E)
                              : Colors.grey.shade500,
                          fontWeight: _currentIndex == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: SizedBox()), // Space for FAB
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _currentIndex == 1
                            ? Icons.person_rounded
                            : Icons.person_outline_rounded,
                        color: _currentIndex == 1
                            ? const Color(0xFF1A4A2E)
                            : Colors.grey.shade500,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 11,
                          color: _currentIndex == 1
                              ? const Color(0xFF1A4A2E)
                              : Colors.grey.shade500,
                          fontWeight: _currentIndex == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
