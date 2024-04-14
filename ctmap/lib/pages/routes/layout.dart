// import 'package:ctmap/pages/screens/Authentication/change_password.dart';
// import 'package:ctmap/pages/screens/Authentication/confirm.dart';
// import 'package:ctmap/pages/screens/Authentication/forgot_password.dart';
// import 'package:ctmap/pages/screens/Profile/edit_profile.dart';
// import 'package:flutter/material.dart';
// import '../../widgets/bottom_tab.dart';
// import '../screens/Home_Map/home_map.dart';
// import '../screens/News/news.dart';
// import '../screens/statistic.dart';
// import '../screens/Profile/profile.dart';

// class MainLayout extends StatefulWidget {
//   @override
//   _MainLayoutState createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     Home(),
//     News(),
//     Statistic(),
//     Profile(),
//     EditProfile(),
//     ChangePassword(
//       changePasswordText: 'Đổi mật khẩu',
//       showButton: false,
//     ),
//     Confirm(
//       confirmText: 'Đổi mật khẩu',
//       showButton: false,
//     ),
//     ForgotPassword(
//       forgotPasswordText: 'Đổi mật khẩu',
//       showButton: false,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         textTheme: TextTheme(
//           bodyText1: TextStyle(fontFamily: 'Mulish'), // Set fontFamily to Mulish
//           bodyText2: TextStyle(fontFamily: 'Mulish'), // Set fontFamily to Mulish
//         ),
//       ),
//       home: Scaffold(
//         body: Stack(
//           children: _screens
//               .asMap()
//               .map((index, screen) => MapEntry(
//                     index,
//                     Offstage(
//                       offstage: _selectedIndex != index,
//                       child: screen,
//                     ),
//                   ))
//               .values
//               .toList(),
//         ),
//         bottomNavigationBar: BottomNavigationWidget(),
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
// }
