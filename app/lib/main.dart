import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/chat_page.dart';
import 'screens/roommate_finder_page.dart';
import 'screens/profile_page.dart';

void main() {
  runApp(const RoomlooApp());
}

class RoomlooApp extends StatefulWidget {
  const RoomlooApp({super.key});

  @override
  State<RoomlooApp> createState() => _RoomlooAppState();
}

class _RoomlooAppState extends State<RoomlooApp> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; // Track theme mode

  final List<Widget> _screens = [
    HomePage(),
    ChatPage(),
    RoommateFinderPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/', // Define initial route
      routes: {
        '/': (context) => MainScreen(
              screens: _screens,
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              toggleTheme: _toggleTheme,
              isDarkMode: _isDarkMode,
            ),
        '/profile': (context) => const ProfilePage(), // Named route for Profile
      },
    );
  }
}

// Extracted Scaffold into a separate widget for better organization
class MainScreen extends StatelessWidget {
  final List<Widget> screens;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.screens,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Roomloo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, '/profile'); // Use named route
            },
          ),
        ],
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Roommates"),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleTheme,
        child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
