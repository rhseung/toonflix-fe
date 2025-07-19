import 'package:flutter/material.dart';
import 'package:toonflix_fe/util/string_extensions.dart';
import 'package:toonflix_fe/view/chat_screen.dart';
import 'package:toonflix_fe/view/home_screen.dart';
import 'package:toonflix_fe/view/profile_screen.dart';
import 'package:toonflix_fe/view/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum NavigationTab {
  home,
  search,
  chat,
  profile;

  Widget get screen {
    switch (this) {
      case home:
        return const HomeScreen();
      case search:
        return const SearchScreen();
      case chat:
        return const ChatScreen();
      case profile:
        return const ProfileScreen();
    }
  }

  Widget get icon {
    switch (this) {
      case home:
        return const Icon(Icons.home_rounded);
      case search:
        return const Icon(Icons.search_rounded);
      case chat:
        return const Icon(Icons.chat_rounded);
      case profile:
        return const Icon(Icons.person);
    }
  }
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;
  late NavigationTab _currentTab;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentTab = NavigationTab.home;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentTab = NavigationTab.values[index];
    });
  }

  void onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: NavigationTab.values.map((tab) => tab.screen).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: NavigationTab.values.indexOf(_currentTab),
        onDestinationSelected: onNavTap,
        destinations: NavigationTab.values
            .map(
              (tab) => NavigationDestination(
                icon: tab.icon,
                label: tab.name.capitalizeFirstLetter(),
              ),
            )
            .toList(),
      ),
    );
  }
}
