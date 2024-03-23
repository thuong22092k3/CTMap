import 'package:flutter/material.dart';
import '../pages/screens/home_map.dart';
import '../pages/screens/news.dart';
import '../pages/screens/statistic.dart';
import '../pages/screens/Profile/profile.dart';
import '../assets/icons/icons.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    News(),
    Statistic(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: AppIcons.getIcon(AppIcons.map, size: 30.0), 
            label: 'Bản đồ',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.getIcon(AppIcons.newspaper, size: 30.0), 
            label: 'Tin tức',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.getIcon(AppIcons.barChart, size: 30.0), 
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.getIcon(AppIcons.person, size: 30.0), 
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red, 
        unselectedItemColor: Colors.grey, 
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
