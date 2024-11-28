// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>(
  (ref) => UserStateNotifier(),
);

class UserState {
  final String id;
  final String userName;
  final String email;
  final String password;
  final bool isLoggedIn;
  final String? resetPasswordToken;
  final DateTime? resetPasswordExpires;
  final String? resetPasswordEmail;

  UserState({
    this.id = '',
    this.userName = '',
    this.email = '',
    this.password = '',
    this.isLoggedIn = false,
    this.resetPasswordToken,
    this.resetPasswordExpires,
    this.resetPasswordEmail,
  });
}

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(UserState());

  void logIn(String id, String userName, String email, String password,
      {String? resetPasswordToken, DateTime? resetPasswordExpires}) {
    state = UserState(
      id: id,
      userName: userName,
      email: email,
      password: password,
      isLoggedIn: true,
      resetPasswordToken: resetPasswordToken,
      resetPasswordExpires: resetPasswordExpires,
    );
    print('User logged in: $email');
  }

  void logOut() {
    state = UserState();
    print('User logged out');
  }

  void setResetPasswordEmail(String email,
      {String? resetPasswordToken, DateTime? resetPasswordExpires}) {
    state = UserState(
      id: state.id,
      userName: state.userName,
      email: state.email,
      password: state.password,
      isLoggedIn: state.isLoggedIn,
      resetPasswordToken: resetPasswordToken,
      resetPasswordExpires: resetPasswordExpires,
      resetPasswordEmail: email,
    );
    print('Reset password email set in UserStateNotifier: $email');
  }
}
