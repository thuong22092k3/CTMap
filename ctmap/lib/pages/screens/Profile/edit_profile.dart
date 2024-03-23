import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _controller = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: AppColors.red,
            height: 86,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CustomTextButton(
                onTap: () {},
                icon: AppIcons.left_arrow,
                iconSize: 30,
                btnTextColor: AppColors.white,
              ),
              Text(
                'Chỉnh sửa thông tin',
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.white,
                ),
              ),
            ]),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment(1.5, 1.7),
                  children: [
                    CircleAvatar(
                      radius: 50,
                    ),
                    IconButton(
                      onPressed: () {
                        // Xử lý khi nhấn vào biểu tượng camera
                      },
                      icon: Icon(AppIcons.camera),
                      color: AppColors.red, // Thay đổi màu sắc tùy ý
                    ),
                  ],
                ),
                SizedBox(height: 60),
                CustomTextField(
                  hintText: 'Username',
                  icon: AppIcons.person, // Thay đổi icon tùy ý
                  controller: _controller,
                  backgroundColor: AppColors.lightGrey,
                  iconColor: AppColors.primaryGray,
                  hintTextColor: AppColors.gray,
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
              ],
            ),
          ),
          // Body
        ],
      ),
    );
  }
}
