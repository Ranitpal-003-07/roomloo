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
      home: Scaffold(
        appBar: AppBar(
          title: Text("Roomloo"),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Roommates"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleTheme,
          child: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
        ),
      ),
    );
  }
}
