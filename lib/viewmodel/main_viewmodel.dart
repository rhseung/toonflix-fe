import 'package:flutter/material.dart';
import 'package:toonflix_fe/service/navigation_service.dart';
import 'package:toonflix_fe/view/chat_screen.dart';
import 'package:toonflix_fe/view/home_screen.dart';
import 'package:toonflix_fe/view/profile_screen.dart';
import 'package:toonflix_fe/view/search_screen.dart';

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

  String get displayName {
    switch (this) {
      case home:
        return 'Home';
      case search:
        return 'Search';
      case chat:
        return 'Chat';
      case profile:
        return 'Profile';
    }
  }

  // AppRoute와 연결
  AppRoute get appRoute {
    switch (this) {
      case home:
        return AppRoute.home;
      case search:
        return AppRoute.search;
      case chat:
        return AppRoute.chat;
      case profile:
        return AppRoute.profile;
    }
  }
}

class MainViewModel extends ChangeNotifier {
  NavigationTab _currentTab = NavigationTab.home;
  late final PageController _pageController;
  bool _useRouteNavigation = false; // 라우트 기반 네비게이션 사용 여부

  // Getters
  NavigationTab get currentTab => _currentTab;
  PageController get pageController => _pageController;
  int get currentIndex => NavigationTab.values.indexOf(_currentTab);
  List<NavigationTab> get allTabs => NavigationTab.values;
  bool get useRouteNavigation => _useRouteNavigation;

  // Constructor
  MainViewModel({bool useRouteNavigation = false}) {
    _pageController = PageController();
    _useRouteNavigation = useRouteNavigation;
  }

  // 라우트 네비게이션 모드 토글
  void setRouteNavigationMode(bool enabled) {
    _useRouteNavigation = enabled;
    notifyListeners();
  }

  // 페이지 변경 처리
  void onPageChanged(int index) {
    if (index >= 0 && index < NavigationTab.values.length) {
      _currentTab = NavigationTab.values[index];
      notifyListeners();
    }
  }

  // 네비게이션 탭 선택 처리
  void onTabSelected(int index) {
    if (index >= 0 && index < NavigationTab.values.length) {
      final tab = NavigationTab.values[index];

      if (_useRouteNavigation) {
        // 라우트 기반 네비게이션 사용
        _navigateWithRoute(tab);
      } else {
        // PageView 기반 네비게이션 사용 (기본)
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // 라우트 기반 네비게이션
  Future<void> _navigateWithRoute(NavigationTab tab) async {
    switch (tab) {
      case NavigationTab.home:
        await NavigationService.navigateToHome();
        break;
      case NavigationTab.search:
        await NavigationService.navigateToSearch();
        break;
      case NavigationTab.chat:
        await NavigationService.navigateToChat();
        break;
      case NavigationTab.profile:
        await NavigationService.navigateToProfile();
        break;
    }
    _currentTab = tab;
    notifyListeners();
  }

  // 특정 탭으로 이동
  void navigateToTab(NavigationTab tab) {
    final index = NavigationTab.values.indexOf(tab);
    onTabSelected(index);
  }

  // 홈으로 이동
  void navigateToHome() => navigateToTab(NavigationTab.home);

  // 검색으로 이동
  void navigateToSearch() => navigateToTab(NavigationTab.search);

  // 채팅으로 이동
  void navigateToChat() => navigateToTab(NavigationTab.chat);

  // 프로필로 이동
  void navigateToProfile() => navigateToTab(NavigationTab.profile);

  // 라우트 기반으로 직접 네비게이션 (외부에서 호출 시)
  Future<void> navigateToTabWithRoute(NavigationTab tab) async {
    await _navigateWithRoute(tab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
