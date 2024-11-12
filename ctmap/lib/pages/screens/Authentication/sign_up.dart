import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Authentication/login.dart';
import 'package:ctmap/services/api.dart';
import 'package:go_router/go_router.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleBefore() {
    context.go(RoutePaths.login);
  }

  void _handleLater() {
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextButton(
                    onTap: _handleBefore,
                    icon: AppIcons.left_arrow,
                    iconSize: 30,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Đăng Ký',
                    style: TextStyle(
                      fontSize: 32,
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              CustomTextField(
                hintText: 'Username',
                icon: AppIcons.person,
                controller: _usernameController,
                backgroundColor: AppColors.lightGrey,
                iconColor: AppColors.primaryGray,
                hintTextColor: AppColors.gray,
              ),
              SizedBox(height: 30),
              CustomTextField(
                hintText: 'Email',
                icon: AppIcons.email,
                controller: _emailController,
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
              CustomTextField(
                hintText: 'Nhập lại mật khẩu',
                icon: AppIcons.lock,
                controller: _passwordController,
                backgroundColor: AppColors.lightGrey,
                iconColor: AppColors.primaryGray,
                hintTextColor: AppColors.gray,
                isPassword: true,
              ),
              SizedBox(height: 40),
              CustomButton(
                onTap: _signUp,
                btnText: 'Đăng ký',
                btnWidth: 300,
                btnHeight: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã có tài khoản?',
                    style: TextStyle(fontSize: 14, color: AppColors.black),
                  ),
                  CustomTextButton(
                    onTap: _handleBefore,
                    btnText: 'Đăng nhập',
                    fontSize: 14,
                  )
                ],
              ),
              SizedBox(height: 20),
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
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    var userData = {
      'userName': username,
      'email': email,
      'password': password,
    };
    print('User data: $userData');
    try {
      await signUp(userData);
      print("User is successfully created");
      //Sửa ở đây
      context.go(RoutePaths.login);
    } catch (error) {
      print("Error occurred during sign up: $error");
    }
  }
}
