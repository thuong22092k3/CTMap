import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _controller = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25), //thêm padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CustomTextButton(
                onTap: () {},
                icon: AppIcons.left_arrow,
                iconSize: 30,
              ),
              Text(
                'Quên mật khẩu',
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            SizedBox(height: 20),
            Text(
              'Vui lòng nhập email của tài khoản để nhận mã xác nhận thay đổi mật khẩu',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGray,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: 'Mật khẩu',
              icon: AppIcons.email, // Thay đổi icon tùy ý
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                // Xử lý khi nhấn vào nút "Đăng nhập"
              },
              btnText: 'Xác nhận',
              btnWidth: 300,
              btnHeight: 50,
            ),
            Spacer(),
            CustomTextButton(
              onTap: () {
                // Xử lý khi nhấn vào nút "Quên mật khẩu"
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
