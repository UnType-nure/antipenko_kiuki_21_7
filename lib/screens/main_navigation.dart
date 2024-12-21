import 'package:flutter/material.dart';
import 'specializations_view.dart';
import 'learners_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentTabIndex = 0;

  final List<Widget> _views = [
    const SpecializationsView(),
    const LearnersView(),
  ];

  void _changeTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTabIndex == 0 ? 'Specializations' : 'Learners'),
      ),
      body: _views[_currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _changeTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            label: 'Specializations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Learners',
          ),
        ],
      ),
    );
  }
}
