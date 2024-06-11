import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>(
  (ref) => UserStateNotifier(),
);

class UserState {
  final String username;
  final String email;
  final String password;
  final bool isLoggedIn;

  UserState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.isLoggedIn = false,
  });
}

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(UserState());

  void logIn(String username, String email, String password) {
    state = UserState(
      username: username,
      email: email,
      password: password,
      isLoggedIn: true,
    );
  }

  void logOut() {
    state = UserState();
  }
}
