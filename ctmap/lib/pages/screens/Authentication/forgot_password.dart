// ignore_for_file: avoid_print

import 'package:ctmap/pages/routes/routes.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/widgets/components/button/text_button.dart';
import 'package:ctmap/widgets/components/text_input/text_input.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/services/api.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
  final String forgotPasswordText;
  final bool showButton;

  const ForgotPassword({
      super.key, 
      this.forgotPasswordText = 'Quên mật khẩu', 
      this.showButton = true
  });
}

class ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final TextEditingController _controller = TextEditingController();

  Future<void> sendVerificationCode(String email) async {
    print('Sending OTP to email: $email');
    bool success = await sendVerificationCodeToEmail(email);
    if (success) {
      print("OTP sent successfully to $email");
      //Chưa sửa
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Confirm(email: email),
      //   ),
      // );

      print("Navigated to Confirm page");
      final userState = ref.watch(userStateProvider);
      if (userState.isLoggedIn == false) {
        if(!mounted) return;
        context.go(
          RoutePaths.confirm,
          extra: {
            'email': email,
            'showButton': true,
          },
        );
      } else {
        if(!mounted) return;
        context.go('${RoutePaths.profile}/forgotPassword/confirm',
            extra: email);
      }
    } else {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể gửi mã OTP. Vui lòng thử lại.')),
      );
      print("Failed to send OTP");
    }
  }

  void _handleBefore() {
    final userState = ref.watch(userStateProvider);
    if (userState.isLoggedIn == false) {
      context.go(RoutePaths.login);
    } else {
      context.go(RoutePaths.profile);
    }
  }

  void _handleLater() {
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CustomTextButton(
                onTap: _handleBefore,
                icon: AppIcons.leftArrow,
                iconSize: 30,
              ),
              Text(
                widget.forgotPasswordText,
                style: const TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            const SizedBox(height: 20),
            const Text(
              'Vui lòng nhập email của tài khoản để nhận mã xác nhận thay đổi mật khẩu!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGray,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Email',
              icon: AppIcons.email,
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
            ),
            const SizedBox(height: 40),
            CustomButton(
              onTap: () {
                sendVerificationCode(_controller.text);
                print("Verification code requested for ${_controller.text}");
              },
              btnText: 'Xác nhận',
              btnWidth: 300,
              btnHeight: 50,
            ),
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
    );
  }
}
