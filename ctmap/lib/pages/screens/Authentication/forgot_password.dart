import 'package:ctmap/pages/routes/routes.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Authentication/confirm.dart';
import 'package:ctmap/services/api.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
  final String forgotPasswordText;
  final bool showButton;

  ForgotPassword(
      {this.forgotPasswordText = 'Quên mật khẩu', this.showButton = true});
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
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
        context.go(
          RoutePaths.confirm,
          extra: {
            'email': email,
            'showButton': true,
          },
        );
      } else {
        context.go('${RoutePaths.profile}/forgotPassword/confirm',
            extra: email);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể gửi mã OTP. Vui lòng thử lại.')),
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
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CustomTextButton(
                onTap: _handleBefore,
                icon: AppIcons.left_arrow,
                iconSize: 30,
              ),
              Text(
                widget.forgotPasswordText,
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            SizedBox(height: 20),
            Text(
              'Vui lòng nhập email của tài khoản để nhận mã xác nhận thay đổi mật khẩu!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGray,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: 'Email',
              icon: AppIcons.email,
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                sendVerificationCode(_controller.text);
                print("Verification code requested for ${_controller.text}");
              },
              btnText: 'Xác nhận',
              btnWidth: 300,
              btnHeight: 50,
            ),
            Spacer(),
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
