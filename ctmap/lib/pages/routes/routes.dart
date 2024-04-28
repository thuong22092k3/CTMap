import 'package:ctmap/widgets/bottom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ctmap/pages/screens/Home_Map/home_map.dart';
import 'package:ctmap/pages/screens/News/news.dart';
import 'package:ctmap/pages/screens/statistic.dart';
import 'package:ctmap/pages/screens/Profile/profile.dart';
import 'package:ctmap/pages/screens/Profile/edit_profile.dart';
import 'package:ctmap/pages/screens/Authentication/login.dart';
import 'package:ctmap/pages/screens/Authentication/sign_up.dart';
import 'package:ctmap/pages/screens/Authentication/confirm.dart';
import 'package:ctmap/pages/screens/Authentication/forgot_password.dart';
import 'package:ctmap/pages/screens/Authentication/change_password.dart';

class RoutePaths {
  static const String home = '/home';
  static const String news = '/news';
  static const String statistic = '/statistic';
  static const String profile = '/profile';
  static const String editProfile = '/edit_profile';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String confirm = '/confirm';
  static const String forgotPassword = '/forgot_password';
  static const String changePassword = '/change_password';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
  return GoRouter(
    initialLocation: RoutePaths.home,
    navigatorKey: rootNavKey,
    routes: [
      StatefulShellRoute.indexedStack(
          builder: ((context, state, navigationShell) => ScaffoldWithNavBar(navigationShell: navigationShell)),
          branches: [
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: RoutePaths.home,
                  builder: (context, state) => Home(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: RoutePaths.news,
                  builder: (context, state) => News(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: RoutePaths.statistic,
                  builder: (context, state) => Statistic(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: RoutePaths.profile,
                  builder: (context, state) => Profile(),
                ),
              ],
            ),
          ]),
      GoRoute(
        path: RoutePaths.editProfile,
        builder: (context, state) => EditProfile(),
      ),
      GoRoute(
        path: RoutePaths.confirm,
        builder: (context, state) => Confirm(
          confirmText: 'Đổi mật khẩu',
          showButton: false,
        ),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => ForgotPassword(
          forgotPasswordText: 'Đổi mật khẩu',
          showButton: false,
        ),
      ),
      GoRoute(
        path: RoutePaths.changePassword,
        builder: (context, state) => ChangePassword(
          changePasswordText: 'Đổi mật khẩu',
          showButton: false,
        ),
      ),
    ],
  );
});