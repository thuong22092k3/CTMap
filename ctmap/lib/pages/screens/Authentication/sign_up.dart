// ignore_for_file: avoid_print

import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/widgets/components/button/text_button.dart';
import 'package:ctmap/widgets/components/text_input/text_input.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/services/api.dart';
import 'package:go_router/go_router.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State <Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    //Sửa ở đây
    _passwordConfirmController.dispose();
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
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: true,
  //     body: Padding(
  //       padding: EdgeInsets.all(25),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 CustomTextButton(
  //                   onTap: _handleBefore,
  //                   icon: AppIcons.left_arrow,
  //                   iconSize: 30,
  //                 ),
  //                 SizedBox(width: 25),
  //                 Text(
  //                   'Đăng Ký',
  //                   style: TextStyle(
  //                     fontSize: 32,
  //                     color: AppColors.red,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 60),
  //             CustomTextField(
  //               hintText: 'Username',
  //               icon: AppIcons.person,
  //               controller: _usernameController,
  //               backgroundColor: AppColors.lightGrey,
  //               iconColor: AppColors.primaryGray,
  //               hintTextColor: AppColors.gray,
  //             ),
  //             SizedBox(height: 30),
  //             CustomTextField(
  //               hintText: 'Email',
  //               icon: AppIcons.email,
  //               controller: _emailController,
  //               backgroundColor: AppColors.lightGrey,
  //               iconColor: AppColors.primaryGray,
  //               hintTextColor: AppColors.gray,
  //             ),
  //             SizedBox(height: 30),
  //             CustomTextField(
  //               hintText: 'Mật khẩu',
  //               icon: AppIcons.lock,
  //               controller: _passwordController,
  //               backgroundColor: AppColors.lightGrey,
  //               iconColor: AppColors.primaryGray,
  //               hintTextColor: AppColors.gray,
  //               isPassword: true,
  //             ),
  //             SizedBox(height: 30),
  //             CustomTextField(
  //               hintText: 'Nhập lại mật khẩu',
  //               icon: AppIcons.lock,
  //               controller: _passwordConfirmController,
  //               backgroundColor: AppColors.lightGrey,
  //               iconColor: AppColors.primaryGray,
  //               hintTextColor: AppColors.gray,
  //               isPassword: true,
  //             ),
  //             SizedBox(height: 40),
  //             CustomButton(
  //               onTap: _signUp,
  //               btnText: 'Đăng ký',
  //               btnWidth: 300,
  //               btnHeight: 50,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'Đã có tài khoản?',
  //                   style: TextStyle(fontSize: 14, color: AppColors.black),
  //                 ),
  //                 CustomTextButton(
  //                   onTap: _handleBefore,
  //                   btnText: 'Đăng nhập',
  //                   fontSize: 14,
  //                 )
  //               ],
  //             ),
  //             SizedBox(height: 20),
  //             //const Spacer(),
  //             CustomTextButton(
  //               onTap: _handleLater,
  //               btnText: 'Lúc khác',
  //               fontSize: 14,
  //               btnTextColor: AppColors.primaryGray,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextButton(
                            onTap: _handleBefore,
                            icon: AppIcons.leftArrow,
                            iconSize: 30,
                          ),
                          const SizedBox(width: 25),
                          const Text(
                            'Đăng Ký',
                            style: TextStyle(
                              fontSize: 32,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      CustomTextField(
                        hintText: 'Username',
                        icon: AppIcons.person,
                        controller: _usernameController,
                        backgroundColor: AppColors.lightGrey,
                        iconColor: AppColors.primaryGray,
                        hintTextColor: AppColors.gray,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: 'Email',
                        icon: AppIcons.email,
                        controller: _emailController,
                        backgroundColor: AppColors.lightGrey,
                        iconColor: AppColors.primaryGray,
                        hintTextColor: AppColors.gray,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: 'Mật khẩu',
                        icon: AppIcons.lock,
                        controller: _passwordController,
                        backgroundColor: AppColors.lightGrey,
                        iconColor: AppColors.primaryGray,
                        hintTextColor: AppColors.gray,
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: 'Nhập lại mật khẩu',
                        icon: AppIcons.lock,
                        controller: _passwordConfirmController,
                        backgroundColor: AppColors.lightGrey,
                        iconColor: AppColors.primaryGray,
                        hintTextColor: AppColors.gray,
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        onTap: _signUp,
                        btnText: 'Đăng ký',
                        btnWidth: 300,
                        btnHeight: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Đã có tài khoản?',
                            style:
                                TextStyle(fontSize: 14, color: AppColors.black),
                          ),
                          CustomTextButton(
                            onTap: _handleBefore,
                            btnText: 'Đăng nhập',
                            fontSize: 14,
                          )
                        ],
                      ),
                      // const SizedBox(height: 20),
                      const Spacer(),
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
          );
        },
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordConfirm = _passwordConfirmController
        .text; // Get the text from the confirm password field

    var userData = {
      'userName': username,
      'email': email,
      'password': password,
    };

    print('User data: $userData');

    if (password != passwordConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mật khẩu và nhập lại mật khẩu không giống nhau')),
      );

      _passwordConfirmController.clear();

      return;
    } else {
      try {
        await signUp(userData);
        print("User is successfully created");
        context.go(RoutePaths.login);
      } catch (error) {
        print("Error occurred during sign up: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã có lỗi xảy ra. Vui lòng thử lại.')),
        );
      }
    }
  }
}
