import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:go_router/go_router.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: AppColors.red,
            height: 86,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: const Column(
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  // You can add image or avatar here
                ),
                const SizedBox(height: 10),
                Text(
                  ref.watch(userStateProvider).userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.red,
                  ),
                ),
                Text(
                  ref.watch(userStateProvider).email,
                  style: const TextStyle(
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomButton(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => EditProfile()),
                            // );
                            context.go('${RoutePaths.profile}/edit');
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
                            context.go('${RoutePaths.profile}/forgotPassword',
                                extra: false);
                          },
                          btnText: 'Đổi mật khẩu',
                          icon: AppIcons.lock,
                          btnColor: null,
                          btnTextColor: AppColors.black,
                          iconColor: AppColors.black.withOpacity(0.5),
                          borderRadius: 0,
                          fontSize: 16,
                        ),
                        CustomButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Trợ giúp',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.red)),
                                  content: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          'Nếu có lỗi hoặc trục trặc kĩ thuật xin liên hệ CSKH.'),
                                      SizedBox(height: 10),
                                      Text('Email: 21521509@gmail.com'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Đóng',
                                        style: TextStyle(color: AppColors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          btnText: 'Trợ giúp',
                          icon: AppIcons.help,
                          btnColor: null,
                          btnTextColor: AppColors.black,
                          iconColor: AppColors.black.withOpacity(0.5),
                          borderRadius: 0,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      onTap: () {
                        ref.read(userStateProvider.notifier).logOut();
                        // Navigator.pushReplacementNamed(context, '/login');
                        context.go(RoutePaths.login);
                      },
                      btnText: 'Đăng xuất',
                      icon: AppIcons.logout,
                      btnColor: null,
                      btnTextColor: AppColors.black,
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
