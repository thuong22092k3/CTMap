import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Authentication/change_password.dart';
import 'package:ctmap/pages/screens/Authentication/forgot_password.dart';


class Confirm extends StatefulWidget {
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                },
                icon: AppIcons.left_arrow,
                iconSize: 30,
              ),
              SizedBox(width: 25),
              Text(
                'Xác nhận',
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            SizedBox(height: 20),
            Text(
              'Vui lòng nhập mã xác nhận được gửi qua email của bạn để .........!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGray,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50, // Độ rộng cụ thể của TextField
                  child: TextField(),
                ),
                SizedBox(width: 5), // Khoảng cách giữa các TextField
                Container(
                  width: 50, // Độ rộng cụ thể của TextField
                  child: TextField(),
                ),
                SizedBox(width: 5), // Khoảng cách giữa các TextField
                Container(
                  width: 50, // Độ rộng cụ thể của TextField
                  child: TextField(),
                ),
                SizedBox(width: 5), // Khoảng cách giữa các TextField
                Container(
                  width: 50, // Độ rộng cụ thể của TextField
                  child: TextField(),
                ),
                SizedBox(width: 5), // Khoảng cách giữa các TextField
                Container(
                  width: 50, // Độ rộng cụ thể của TextField
                  child: TextField(),
                ),
                SizedBox(width: 5), // Khoảng cách giữa các TextField
                Container(
                  width: 50, // Độ rộng cụ thể của TextField
                  child: TextField(),
                ),
              ],
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                // Xử lý khi nhấn vào nút "Xác nhận"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
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
                  onTap: () {
                    // Xử lý khi nhấn vào nút "Quên mật khẩu"
                  },
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
