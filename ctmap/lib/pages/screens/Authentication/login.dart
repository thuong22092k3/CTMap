import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/Checkbox/Checkbox.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            Text(
              'Đăng Nhập',
              style: TextStyle(fontSize: 32, color: AppColors.red),
            ),
            SizedBox(height: 70),
            CustomTextField(
              hintText: 'Email hoặc Username',
              icon: AppIcons.email,
              controller: _controller,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
            ),
            SizedBox(height: 30),
            CustomTextField(
              hintText: 'Mật khẩu',
              icon: AppIcons.lock, 
              controller: _controller,
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
                  // Các thuộc tính khác của CustomCheckbox
                ),
                Text(
                  'Ghi nhớ đăng nhập',
                  style: TextStyle(fontSize: 11, color: AppColors.black),
                ),
                Spacer(),
                CustomTextButton(
                  onTap: () {
                    // Xử lý khi nhấn vào nút "Quên mật khẩu"
                  },
                  btnText: 'Quên mật khẩu?',
                )
              ],
            ),
            SizedBox(height: 30),
            CustomButton(
              onTap: () {
                // Xử lý khi nhấn vào nút "Đăng nhập"
              },
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
                    // Xử lý khi nhấn vào nút "Quên mật khẩu"
                  },
                  btnText: 'Đăng ký',
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
