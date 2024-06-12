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

  UserState({
    this.id = '',
    this.userName = '',
    this.email = '',
    this.password = '',
    this.isLoggedIn = false,
  });
}

class UserStateNotifier extends StateNotifier<UserState> {
  UserStateNotifier() : super(UserState());

  void logIn(String id, String userName, String email, String password) {
    state = UserState(
      id: id,
      userName: userName,
      email: email,
      password: password,
      isLoggedIn: true,
    );
  }

  void logOut() {
    state = UserState();
  }
}
