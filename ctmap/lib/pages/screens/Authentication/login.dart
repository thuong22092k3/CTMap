import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/Checkbox/Checkbox.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Authentication/forgot_password.dart';
import 'package:ctmap/pages/screens/Authentication/sign_up.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:ctmap/pages/screens/Home_Map/home_map.dart';
import 'package:go_router/go_router.dart';

class Login extends ConsumerStatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    String userName = _usernameController.text;
    String password = _passwordController.text;
    var response = await login(userName, password);

    if (response['success']) {
      String id = response['data']['_id'];
      String email = response['data']['email'];
      if (id.isNotEmpty && email.isNotEmpty) {
        ref
            .read(userStateProvider.notifier)
            .logIn(id, userName, email, password);
        final userState = ref.read(userStateProvider);

        print('Login successful for user: ${userState.userName}');
        print('User ID: ${userState.id}');
        print('User email: ${userState.email}');
        print('User password: ${userState.password}');
        print('Is user logged in: ${userState.isLoggedIn}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        print('Login failed: Missing user ID or email');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
        );
      }
    } else {
      print('Login failed: ${response['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại!')),
      );
    }
  }

  void _handleLater() {
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Đăng Nhập',
              style: TextStyle(fontSize: 32, color: AppColors.red),
            ),
            SizedBox(height: 70),
            CustomTextField(
              hintText: 'Email hoặc Username',
              icon: AppIcons.email,
              controller: _usernameController,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
            ),
            SizedBox(height: 30),
            CustomTextField(
              hintText: 'Mật khẩu',
              icon: AppIcons.lock,
              controller: _passwordController,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
              isPassword: true,
            ),
            SizedBox(height: 30),
            Row(
              children: [
                CustomCheckbox(
                  value: _isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      _isChecked = newValue ?? false;
                    });
                  },
                  margin: EdgeInsets.only(right: 8.0),
                ),
                Text(
                  'Ghi nhớ đăng nhập',
                  style: TextStyle(fontSize: 11, color: AppColors.black),
                ),
                Spacer(),
                CustomTextButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  btnText: 'Quên mật khẩu?',
                )
              ],
            ),
            SizedBox(height: 30),
            CustomButton(
              onTap: _handleLogin,
              btnText: 'Đăng nhập',
              btnWidth: 300,
              btnHeight: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chưa có tài khoản?',
                  style: TextStyle(fontSize: 14, color: AppColors.black),
                ),
                CustomTextButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  btnText: 'Đăng ký',
                  fontSize: 14,
                )
              ],
            ),
            Spacer(),
            CustomTextButton(
              onTap: _handleLater,
              btnText: 'Lúc khác',
              fontSize: 14,
              btnTextColor: AppColors.primaryGray,
            )
          ],
        ),
      ),
    );
  }
}
