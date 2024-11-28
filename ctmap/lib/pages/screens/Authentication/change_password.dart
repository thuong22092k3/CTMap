// ignore_for_file: avoid_print

import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/widgets/components/button/text_button.dart';
import 'package:ctmap/widgets/components/text_input/text_input.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Thêm import này

class ChangePassword extends ConsumerStatefulWidget {
  final String email;
  final String changePasswordText;
  final bool showButton;

  const ChangePassword(
      {super.key,
      required this.email,
      this.changePasswordText = 'Đổi mật khẩu',
      this.showButton = true});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends ConsumerState<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _handleChangePassword() async {
    String newPassword = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mật khẩu và nhập lại mật khẩu không giống nhau')),
      );
      return;
    }

    final userState = ref.watch(userStateProvider);
    if (userState.isLoggedIn) {
      String userId = userState.id;
      Map<String, dynamic> userData = {'password': newPassword};

      final messenger = ScaffoldMessenger.of(context);
      final result = await updateUser(userId, userData);

      if (result['success']) {
        messenger.showSnackBar(
          const SnackBar(
              content: Text(
            'Đổi mật khẩu thành công',
            style: TextStyle(
              // fontSize: 32,
              color: Colors.green,
            ),
          )),
        );
        //Sửa ở đây
        if(!mounted) return;
        context.go(RoutePaths.profile);
      } else {
        print('Đổi mật khẩu thất bại: ${result['message']}');
        messenger.showSnackBar(
          SnackBar(
              content: Text('Đổi mật khẩu thất bại: ${result['message']}')),
        );
      }
    } else {
      final messenger = ScaffoldMessenger.of(context);
      final result = await changePassword(widget.email, newPassword);

      if (result['success']) {
        messenger.showSnackBar(
          const SnackBar(
              content: Text(
            'Đổi mật khẩu thành công',
            style: TextStyle(
              // fontSize: 32,
              color: Colors.green,
            ),
          )),
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => Login()),
        // );
        //Sửa ở đây
        if(!mounted) return;
        context.go(RoutePaths.login);
      } else {
        print('Đổi mật khẩu thất bại: ${result['message']}');
        messenger.showSnackBar(
          SnackBar(
              content: Text('Đổi mật khẩu thất bại: ${result['message']}')),
        );
      }
    }
  }

  void _handleBefore() {
    // context.go(RoutePaths.confirm);
    final userState = ref.watch(userStateProvider);
    if (userState.isLoggedIn == false) {
      context.go(
        RoutePaths.confirm,
      );
    } else {
      context.go(
        '${RoutePaths.profile}/forgotPassword/confirm',
      );
    }
  }

  void _handleLater() {
    context.go(RoutePaths.home);
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       resizeToAvoidBottomInset: true,
  //       body: SingleChildScrollView(
  //           child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //             Padding(
  //               padding: EdgeInsets.all(25),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Row(mainAxisAlignment: MainAxisAlignment.start, children: [
  //                     CustomTextButton(
  //                       onTap: _handleBefore,
  //                       icon: AppIcons.left_arrow,
  //                       iconSize: 30,
  //                     ),
  //                     Text(
  //                       widget.changePasswordText,
  //                       style: TextStyle(
  //                         fontSize: 32,
  //                         color: AppColors.red,
  //                       ),
  //                     ),
  //                   ]),
  //                   SizedBox(height: 20),
  //                   Text(
  //                     'Vui lòng nhập mật khẩu mới!',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: AppColors.primaryGray,
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),
  //                   CustomTextField(
  //                     hintText: 'Mật khẩu',
  //                     icon: AppIcons.lock,
  //                     controller: _passwordController,
  //                     backgroundColor: AppColors.lightGrey,
  //                     iconColor: AppColors.primaryGray,
  //                     hintTextColor: AppColors.gray,
  //                     isPassword: true,
  //                   ),
  //                   SizedBox(height: 20),
  //                   CustomTextField(
  //                     hintText: 'Nhập lại mật khẩu',
  //                     icon: AppIcons.lock,
  //                     controller: _confirmPasswordController,
  //                     backgroundColor: AppColors.lightGrey,
  //                     iconColor: AppColors.primaryGray,
  //                     hintTextColor: AppColors.gray,
  //                     isPassword: true,
  //                   ),
  //                   SizedBox(height: 40),
  //                   CustomButton(
  //                     onTap: _handleChangePassword,
  //                     btnText: 'Đổi mật khẩu',
  //                     btnWidth: 300,
  //                     btnHeight: 50,
  //                   ),
  //                   SizedBox(height: 20),
  //                   //Spacer(),
  //                   if (widget.showButton)
  //                     CustomTextButton(
  //                       onTap: _handleLater,
  //                       btnText: 'Lúc khác',
  //                       fontSize: 14,
  //                       btnTextColor: AppColors.primaryGray,
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ])));
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextButton(
                              onTap: _handleBefore,
                              icon: AppIcons.leftArrow,
                              iconSize: 30,
                            ),
                            Text(
                              widget.changePasswordText,
                              style: const TextStyle(
                                fontSize: 32,
                                color: AppColors.red,
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      const Text(
                        'Vui lòng nhập mật khẩu mới!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryGray,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Mật khẩu',
                        icon: AppIcons.lock,
                        controller: _passwordController,
                        backgroundColor: AppColors.lightGrey,
                        iconColor: AppColors.primaryGray,
                        hintTextColor: AppColors.gray,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Nhập lại mật khẩu',
                        icon: AppIcons.lock,
                        controller: _confirmPasswordController,
                        backgroundColor: AppColors.lightGrey,
                        iconColor: AppColors.primaryGray,
                        hintTextColor: AppColors.gray,
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        onTap: _handleChangePassword,
                        btnText: 'Đổi mật khẩu',
                        btnWidth: 300,
                        btnHeight: 50,
                      ),
                      // SizedBox(height: 20),
                      const Spacer(),
                      if (widget.showButton)
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
}
