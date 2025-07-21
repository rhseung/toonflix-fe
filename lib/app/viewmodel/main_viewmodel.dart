import 'package:flutter/material.dart';
import 'package:toonflix_fe/app/view/chat_screen.dart';
import 'package:toonflix_fe/app/view/home_screen.dart';
import 'package:toonflix_fe/app/view/profile_screen.dart';
import 'package:toonflix_fe/app/view/search_screen.dart';

enum NavigationTab {
  home(
    screen: HomeScreen(),
    icon: Icon(Icons.home_rounded),
    displayName: 'Home',
  ),
  search(
    screen: SearchScreen(),
    icon: Icon(Icons.search_rounded),
    displayName: 'Search',
  ),
  chat(
    screen: ChatScreen(),
    icon: Icon(Icons.chat_rounded),
    displayName: 'Chat',
  ),
  profile(
    screen: ProfileScreen(),
    icon: Icon(Icons.person),
    displayName: 'Profile',
  );

  const NavigationTab({
    required this.screen,
    required this.icon,
    required this.displayName,
  });

  final Widget screen;
  final Widget icon;
  final String displayName;
}

class MainViewModel extends ChangeNotifier {
  NavigationTab _currentTab = NavigationTab.home;
  late final PageController _pageController;
  bool _disposed = false;

  NavigationTab get currentTab => _currentTab;
  PageController get pageController => _pageController;
  int get currentIndex => NavigationTab.values.indexOf(_currentTab);
  List<NavigationTab> get allTabs => NavigationTab.values;

  MainViewModel({bool useRouteNavigation = false}) {
    _pageController = PageController();
  }

  void setRouteNavigationMode(bool enabled) {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void onPageChanged(int index) {
    if (index >= 0 && index < NavigationTab.values.length) {
      _currentTab = NavigationTab.values[index];
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  void onTabSelected(int index) {
    if (index >= 0 && index < NavigationTab.values.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void navigateToTab(NavigationTab tab) {
    final index = NavigationTab.values.indexOf(tab);
    onTabSelected(index);
  }

  void navigateToHome() => navigateToTab(NavigationTab.home);

  void navigateToSearch() => navigateToTab(NavigationTab.search);

  void navigateToChat() => navigateToTab(NavigationTab.chat);

  void navigateToProfile() => navigateToTab(NavigationTab.profile);

  @override
  void dispose() {
    _disposed = true;
    _pageController.dispose();
    super.dispose();
  }
}
