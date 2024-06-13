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

  UserState({
    this.id = '',
    this.userName = '',
    this.email = '',
    this.password = '',
    this.isLoggedIn = false,
    this.resetPasswordToken,
    this.resetPasswordExpires,
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
  }

  void logOut() {
    state = UserState();
  }
}
