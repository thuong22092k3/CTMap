import 'package:flutter/material.dart';
import '../widgets/bottom_tab.dart';
import '../pages/screens/home_map.dart';
import '../pages/screens/news.dart';
import '../pages/screens/statistic.dart';
import '../pages/screens/profile.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    News(),
    Statistic(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'Mulish'), // Set fontFamily to Mulish
          bodyText2: TextStyle(fontFamily: 'Mulish'), // Set fontFamily to Mulish
        ),
      ),
      home: Scaffold(
        body: Stack(
          children: _screens
              .asMap()
              .map((index, screen) => MapEntry(
                    index,
                    Offstage(
                      offstage: _selectedIndex != index,
                      child: screen,
                    ),
                  ))
              .values
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationWidget(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
