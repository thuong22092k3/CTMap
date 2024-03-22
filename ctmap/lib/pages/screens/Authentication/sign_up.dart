import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
              SizedBox(width: 25),
              Text(
                'Đăng Ký',
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            SizedBox(height: 60),
            CustomTextField(
              hintText: 'Username',
              icon: AppIcons.person, // Thay đổi icon tùy ý
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
            ),
            SizedBox(height: 30),
            CustomTextField(
              hintText: 'Email',
              icon: AppIcons.email, // Thay đổi icon tùy ý
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
            ),
            SizedBox(height: 30),
            CustomTextField(
              hintText: 'Mật khẩu',
              icon: AppIcons.lock, // Thay đổi icon tùy ý
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
              isPassword: true,
            ),
            SizedBox(height: 30),
            CustomTextField(
              hintText: 'Nhập lại mật khẩu',
              icon: AppIcons.lock, // Thay đổi icon tùy ý
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
              isPassword: true,
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                // Xử lý khi nhấn vào nút "Đăng nhập"
              },
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
                  onTap: () {
                    // Xử lý khi nhấn vào nút "Quên mật khẩu"
                  },
                  btnText: 'Đăng nhập',
                  fontSize: 14,
                )
              ],
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
