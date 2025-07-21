import 'package:flutter/material.dart';
import 'package:toonflix_fe/app/viewmodel/main_viewmodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MainViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _viewModel.pageController,
        onPageChanged: _viewModel.onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _viewModel.allTabs.map((tab) => tab.screen).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _viewModel.currentIndex,
        onDestinationSelected: _viewModel.onTabSelected,
        destinations: _viewModel.allTabs
            .map(
              (tab) =>
                  NavigationDestination(icon: tab.icon, label: tab.displayName),
            )
            .toList(),
      ),
    );
  }
}
