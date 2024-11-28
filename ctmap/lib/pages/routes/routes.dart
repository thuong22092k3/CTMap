// ignore_for_file: avoid_print

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
import 'package:ctmap/state_management/user_state.dart';

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
  //Logged in user
  static const String confirmLogged = '/confirm';
  static const String forgotPasswordLogged = '/forgot_password';
  static const String changePasswordLogged = '/change_password';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  return GoRouter(
    initialLocation: RoutePaths.home,
    navigatorKey: rootNavKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const Home(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.news,
                builder: (context, state) => const News(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.statistic,
                builder: (context, state) => const Statistic(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                builder: (context, state) {
                  final userState = ref.watch(userStateProvider);
                  print(
                      'Checking if user is logged in: ${userState.isLoggedIn}');
                  return userState.isLoggedIn ? const Profile() : const Login();
                },
                routes: [
                  // Đặt EditProfile là route con của Profile
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const EditProfile(),
                  ),
                  GoRoute(
                    path: 'forgotPassword',
                    builder: (context, state) {
                      final extraValue = state.extra;
                      final showButton =
                          (extraValue is bool) ? extraValue : true;
                      return ForgotPassword(
                        forgotPasswordText: 'Đổi mật khẩu',
                        showButton: showButton,
                      );
                    },
                    routes: [
                      GoRoute(
                          path: 'confirm',
                          builder: (context, state) {
                            final email = state.extra as String? ?? '';
                            return Confirm(
                              email: email,
                              confirmText: 'Đổi mật khẩu',
                              showButton: false,
                            );
                          },
                          routes: [
                            GoRoute(
                              path: 'changePassword',
                              builder: (context, state) {
                                final email = state.extra as String? ?? '';
                                return ChangePassword(
                                  email: email,
                                  changePasswordText: 'Đổi mật khẩu',
                                  showButton: false,
                                );
                              },
                            ),
                          ]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: RoutePaths.signUp,
        builder: (context, state) => const Signup(),
      ),
      GoRoute(
        path: RoutePaths.confirm,
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>? ?? {};
          final email = extraData['email'] as String? ?? '';
          final showButton = extraData['showButton'] as bool? ?? true;
          return Confirm(
            email: email,
            confirmText: 'Quên mật khẩu',
            showButton: showButton,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) {
          final extraValue = state.extra;
          final showButton = extraValue is bool ? extraValue : true;
          return ForgotPassword(
            forgotPasswordText: 'Quên mật khẩu',
            showButton: showButton,
          );
        },
      ),
      GoRoute(
        path: RoutePaths.changePassword,
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>? ?? {};
          final email = extraData['email'] as String? ?? '';
          final showButton = extraData['showButton'] as bool? ?? true;
          return ChangePassword(
            email: email,
            changePasswordText: 'Quên mật khẩu',
            showButton: showButton,
          );
        },
      ),
    ],
  );
});
