import 'package:flutter/material.dart';
import 'package:ctmap/pages/screens/home_map.dart';
import 'package:ctmap/pages/screens/news.dart';
import 'package:ctmap/pages/screens/statistic.dart';
import 'package:ctmap/pages/screens/Profile/profile.dart';
import 'package:ctmap/pages/screens/Profile/edit_profile.dart';
import 'package:ctmap/pages/screens/Authentication/login.dart';
import 'package:ctmap/pages/screens/Authentication/sign_up.dart';
import 'package:ctmap/pages/screens/Authentication/confirm.dart';
import 'package:ctmap/pages/screens/Authentication/forgot_password.dart';
import 'package:ctmap/pages/screens/Authentication/change_password.dart';


class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Root App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}

final Map<String, WidgetBuilder> routes = {
  '/': (context) => Home(), 
  '/news': (context) => News(),
  '/statistic': (context) => Statistic(),
  '/profile': (context) => Profile(),
  '/login': (context) => Login(),
  '/signup': (context) => Signup(),
  '/confirm': (context) => Confirm(),
  'change_password': (context) => ChangePassword(),
  'forgot_password': (context) => ForgotPassword(),
  'edit_profile': (context) => EditProfile(),
};
