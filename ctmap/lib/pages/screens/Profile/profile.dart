import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';

class Profile extends StatelessWidget {
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tài Khoản',
                  style: TextStyle(fontSize: 28, color: AppColors.primaryWhite),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                ),
                SizedBox(height: 10),
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.red,
                  ),
                ),
                Text(
                  'user@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Phần 1: Các nút chức năng
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomButton(
                          onTap: () {
                            // Xử lý khi nhấn vào nút "Chỉnh sửa thông tin"
                          },
                          btnText: 'Chỉnh sửa thông tin',
                          icon: AppIcons.edit,
                          btnColor: null, // Màu trong suốt
                          btnTextColor: AppColors.black, // Màu chữ
                          iconColor: AppColors.black.withOpacity(0.5),
                          borderRadius: 0,
                          fontSize: 16,
                        ),
                        CustomButton(
                          onTap: () {
                            // Xử lý khi nhấn vào nút "Đổi mật khẩu"
                          },
                          btnText: 'Đổi mật khẩu',
                          icon: AppIcons.lock,
                          btnColor: null, // Màu trong suốt
                          btnTextColor: AppColors.black, // Màu chữ
                          iconColor: AppColors.black.withOpacity(0.5),
                          borderRadius: 0,
                          fontSize: 16,
                        ),
                        CustomButton(
                          onTap: () {
                            // Xử lý khi nhấn vào nút "Trợ giúp"
                          },
                          btnText: 'Trợ giúp',
                          icon: AppIcons.help,
                          btnColor: null, // Màu trong suốt
                          btnTextColor: AppColors.black, // Màu chữ
                          iconColor: AppColors.black.withOpacity(0.5),
                          borderRadius: 0,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Phần 2: Nút Đăng xuất
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      onTap: () {
                        // Xử lý khi nhấn vào nút "Đăng xuất"
                      },
                      btnText: 'Đăng xuất',
                      icon: AppIcons.logout,
                      btnColor: null, // Màu trong suốt
                      btnTextColor: AppColors.black, // Màu chữ
                      iconColor: AppColors.black.withOpacity(0.5),
                      borderRadius: 0,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
