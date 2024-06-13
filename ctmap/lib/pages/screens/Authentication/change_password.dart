import 'package:ctmap/pages/screens/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:flutter/services.dart';
import 'package:ctmap/pages/screens/Authentication/forgot_password.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerStatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
  final String changePasswordText;
  final bool showButton;

  ChangePassword(
      {this.changePasswordText = 'Quên mật khẩu', this.showButton = true});
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _handleChangePassword() async {
    String userId = ref.read(userStateProvider).id;
    String newPassword = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Mật khẩu và nhập lại mật khẩu không giống nhau')),
      );
      return;
    }

    Map<String, dynamic> userData = {'password': newPassword};

    final result = await updateUser(userId, userData);

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    } else {
      print('Đổi mật khẩu thất bại: ${result['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đổi mật khẩu thất bại: ${result['message']}')),
      );
    }
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
                widget.changePasswordText,
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            SizedBox(height: 20),
            Text(
              'Vui lòng nhập mật khẩu mới!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGray,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: 'Mật khẩu',
              icon: AppIcons.lock,
              controller: _passwordController,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
              // obscureText: true,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: 'Nhập lại mật khẩu',
              icon: AppIcons.lock,
              controller: _confirmPasswordController,
              backgroundColor: AppColors.lightGrey,
              iconColor: AppColors.primaryGray,
              hintTextColor: AppColors.gray,
              // obscureText: true,
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: _handleChangePassword,
              btnText: 'Đổi mật khẩu',
              btnWidth: 300,
              btnHeight: 50,
            ),
            Spacer(),
            if (widget.showButton)
              CustomTextButton(
                onTap: () {
                  // Handle later button tap
                },
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
