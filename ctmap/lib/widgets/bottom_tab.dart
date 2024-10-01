import 'package:ctmap/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../assets/icons/icons.dart';


class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(AppIcons.map, size: 30.0),
            label: 'Bản đồ',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.newspaper, size: 30.0),
            label: 'An toàn giao thông',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.barChart, size: 30.0),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.person, size: 30.0),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
        selectedItemColor: AppColors.red,
        unselectedItemColor: AppColors.primaryGray,
        showUnselectedLabels: true,
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
