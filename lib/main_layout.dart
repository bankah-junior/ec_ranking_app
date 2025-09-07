import 'package:flutter/material.dart';
import 'package:ec_ranking/views/home_screen.dart';
import 'package:ec_ranking/views/events_screen.dart';
import 'package:ec_ranking/views/setting_screen.dart';
import 'package:ec_ranking/widgets/bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    EventsScreen(),
    SettingScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabTapped, // 👈 let parent control state
      ),
    );
  }
}
