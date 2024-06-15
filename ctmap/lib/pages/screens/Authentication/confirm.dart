import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Authentication/change_password.dart';
import 'package:ctmap/pages/screens/Authentication/forgot_password.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:ctmap/services/api.dart';

class Confirm extends ConsumerStatefulWidget {
  final String? email;
  final String confirmText;
  final bool showButton;

  Confirm(
      {Key? key,
      this.email,
      this.confirmText = 'Quên mật khẩu',
      this.showButton = true})
      : super(key: key);

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends ConsumerState<Confirm> {
  final TextEditingController _controller = TextEditingController();

  Future<void> verifyOtpCode(String code) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đang xác thực mã OTP...')),
      );

      String email = widget.email ?? ref.read(userStateProvider).email;
      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email không hợp lệ.')),
        );
        return;
      }

      bool isValid = await verifyCode(email, code);
      if (isValid) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePassword(email: email),
          ),
        );
        print("OTP is valid: $code");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mã OTP không hợp lệ. Vui lòng thử lại.')),
        );
        print("Invalid OTP: $code");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại sau.')),
      );
      print("Error verifying OTP: $error");
    }
  }

  void resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mã OTP đã được gửi lại!')),
    );
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                },
                icon: AppIcons.left_arrow,
                iconSize: 30,
              ),
              Text(
                widget.confirmText,
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            SizedBox(height: 20),
            Text(
              'Vui lòng nhập mã OTP đã gửi đến email của bạn!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGray,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mã OTP',
                ),
              ),
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                verifyOtpCode(_controller.text);
              },
              btnText: 'Xác nhận',
              btnWidth: 300,
              btnHeight: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chưa nhận được mã?',
                  style: TextStyle(fontSize: 14, color: AppColors.black),
                ),
                CustomTextButton(
                  onTap: resendCode,
                  btnText: 'Gửi lại mã',
                  fontSize: 14,
                )
              ],
            ),
            Text(
              'Yêu cầu gửi lại mã trong 00:30s',
              style: TextStyle(fontSize: 13, color: AppColors.gray),
            ),
            Spacer(),
            if (widget.showButton)
              CustomTextButton(
                onTap: () {
                  // Handle 'Lúc khác'
                },
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
