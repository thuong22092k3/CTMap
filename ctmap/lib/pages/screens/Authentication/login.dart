import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class Login extends ConsumerStatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _isChecked = prefs.getBool('rememberMe') ?? false;
    if (_isChecked) {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    }
    setState(() {});
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_isChecked) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', _isChecked);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
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
        await _saveCredentials();
        context.go(RoutePaths.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
        );
      }
    } else {
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: AutofillGroup(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Đăng Nhập',
                    style: TextStyle(fontSize: 32, color: AppColors.red),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    hintText: 'Email hoặc Username',
                    icon: AppIcons.email,
                    controller: _usernameController,
                    backgroundColor: AppColors.lightGrey,
                    iconColor: AppColors.primaryGray,
                    hintTextColor: AppColors.gray,
                    autofillHints: [AutofillHints.username],
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Mật khẩu',
                    icon: AppIcons.lock,
                    controller: _passwordController,
                    backgroundColor: AppColors.lightGrey,
                    iconColor: AppColors.primaryGray,
                    hintTextColor: AppColors.gray,
                    isPassword: true,
                    autofillHints: [AutofillHints.password],
                  ),
                  const SizedBox(height: 30),
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
                      const Text(
                        'Ghi nhớ đăng nhập',
                        style: TextStyle(fontSize: 11, color: AppColors.black),
                      ),
                      const Spacer(),
                      CustomTextButton(
                        onTap: () {
                          context.go(RoutePaths.forgotPassword, extra: true);
                        },
                        btnText: 'Quên mật khẩu?',
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onTap: () {
                      _handleLogin();
                      TextInput.finishAutofillContext();
                    },
                    btnText: 'Đăng nhập',
                    btnWidth: 300,
                    btnHeight: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Chưa có tài khoản?',
                        style: TextStyle(fontSize: 14, color: AppColors.black),
                      ),
                      CustomTextButton(
                        onTap: () {
                          context.go(RoutePaths.signUp);
                        },
                        btnText: 'Đăng ký',
                        fontSize: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextButton(
                    onTap: _handleLater,
                    btnText: 'Lúc khác',
                    fontSize: 14,
                    btnTextColor: AppColors.primaryGray,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
