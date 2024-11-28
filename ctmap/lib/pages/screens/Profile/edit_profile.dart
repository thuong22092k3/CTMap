// ignore_for_file: avoid_print

import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/widgets/components/button/text_button.dart';
import 'package:ctmap/widgets/components/text_input/text_input.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {
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
      context.go(RoutePaths.profile);
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
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: AppColors.red,
            height: 86,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextButton(
                  onTap: _handleBefore,
                  icon: AppIcons.leftArrow,
                  iconSize: 30,
                  btnTextColor: AppColors.white,
                ),
                const Text(
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: const Alignment(1.5, 1.7),
                  children: [
                    const CircleAvatar(
                      radius: 50,
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle camera icon press
                      },
                      icon: const Icon(AppIcons.camera),
                      color: AppColors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                CustomTextField(
                  hintText: 'Username',
                  icon: AppIcons.person,
                  controller: _usernameController,
                  backgroundColor: AppColors.lightGrey,
                  iconColor: AppColors.primaryGray,
                  hintTextColor: AppColors.gray,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Email',
                  icon: AppIcons.email,
                  controller: _emailController,
                  backgroundColor: AppColors.lightGrey,
                  iconColor: AppColors.primaryGray,
                  hintTextColor: AppColors.gray,
                ),
                const SizedBox(height: 40),
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
    ));
  }
}
