import 'package:flutter/material.dart';
import 'package:ctmap/pages/screens/home_map.dart';
import 'package:ctmap/pages/screens/news.dart';
import 'package:ctmap/pages/screens/statistic.dart';
import 'package:ctmap/pages/screens/profile.dart';

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
};
