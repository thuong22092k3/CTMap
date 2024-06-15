import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Button/TextButton.dart';
import 'package:ctmap/widgets/components/TextInput/TextInput.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Profile/profile.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends ConsumerStatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userState = ref.read(userStateProvider);
    _usernameController.text = userState.userName;
    _emailController.text = userState.email;
  }

  Future<void> _handleUpdate() async {
    String id = ref.read(userStateProvider).id;
    Map<String, dynamic> userData = {
      'userName': _usernameController.text,
      'email': _emailController.text,
    };

    final result = await updateUser(id, userData);

    if (result['success']) {
      ref.read(userStateProvider.notifier).logIn(
            id,
            _usernameController.text,
            _emailController.text,
            ref.read(userStateProvider).password,
          );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    } else {
      print('Update failed: ${result['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: ${result['message']}')),
      );
    }
  }

  void _handleBefore() {
    context.go(RoutePaths.profile);
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
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
              ],
            ),
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
                        // Handle camera icon press
                      },
                      icon: Icon(AppIcons.camera),
                      color: AppColors.red,
                    ),
                  ],
                ),
                SizedBox(height: 60),
                CustomTextField(
                  hintText: 'Username',
                  icon: AppIcons.person,
                  controller: _usernameController,
                  backgroundColor: AppColors.lightGrey,
                  iconColor: AppColors.primaryGray,
                  hintTextColor: AppColors.gray,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Email',
                  icon: AppIcons.email,
                  controller: _emailController,
                  backgroundColor: AppColors.lightGrey,
                  iconColor: AppColors.primaryGray,
                  hintTextColor: AppColors.gray,
                ),
                SizedBox(height: 40),
                CustomButton(
                  onTap: _handleUpdate,
                  btnText: 'Xác nhận',
                  btnWidth: 300,
                  btnHeight: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
