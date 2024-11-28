// ignore_for_file: avoid_print

import 'dart:async';

import 'package:ctmap/pages/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/widgets/components/button/text_button.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:ctmap/services/api.dart';
import 'package:go_router/go_router.dart';

class Confirm extends ConsumerStatefulWidget {
  final String? email;
  final String confirmText;
  final bool showButton;

  const Confirm(
      {super.key,
      this.email,
      this.confirmText = 'Quên mật khẩu',
      this.showButton = true});

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends ConsumerState<Confirm> {
  final TextEditingController _controller = TextEditingController();
  int _remainingTime = 60;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      _remainingTime = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtpCode(String code) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xác thực mã OTP...')),
      );

      String email = widget.email ?? ref.read(userStateProvider).email;
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email không hợp lệ.')),
        );
        return;
      }

      bool isValid = await verifyCode(email, code);
      if (isValid) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChangePassword(email: email),
        //   ),
        // );

        //Chưa sửa
        // context.go(RoutePaths.changePassword, extra: email);
        final userState = ref.watch(userStateProvider);
        if (userState.isLoggedIn == false) {
          context.go(
            RoutePaths.changePassword,
            extra: {
              'email': email,
              'showButton': true,
            },
          );
        } else {
          context.go(
            '${RoutePaths.profile}/forgotPassword/confirm/changePassword',
            extra: email,
          );
        }
        print("OTP is valid: $code");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mã OTP không hợp lệ. Vui lòng thử lại.')),
        );
        print("Invalid OTP: $code");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại sau.')),
      );
      print("Error verifying OTP: $error");
    }
  }

  Future<void> resendCode() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang gửi lại mã OTP...')),
      );
      String email = widget.email ?? ref.read(userStateProvider).email;
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email không hợp lệ.')),
        );
        return;
      }

      final messenger = ScaffoldMessenger.of(context);
      bool success = await sendVerificationCodeToEmail(email);
      if (success) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Mã OTP đã được gửi lại!')),
        );
        startCountdown();
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Không thể gửi mã OTP. Vui lòng thử lại.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại sau.')),
      );
      print("Error resending OTP: $error");
    }
  }

  void _handleBefore() {
    // context.go(RoutePaths.forgotPassword);
    final userState = ref.watch(userStateProvider);
    if (userState.isLoggedIn == false) {
      context.go(
        RoutePaths.forgotPassword,
      );
    } else {
      context.go('${RoutePaths.profile}/forgotPassword', extra: false);
    }
  }

  void _handleLater() {
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CustomTextButton(
                onTap: _handleBefore,
                icon: AppIcons.leftArrow,
                iconSize: 30,
              ),
              Text(
                widget.confirmText,
                style: const TextStyle(
                  fontSize: 32,
                  color: AppColors.red,
                ),
              ),
            ]),
            const SizedBox(height: 20),
            const Text(
              'Vui lòng nhập mã OTP đã gửi đến email của bạn!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGray,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập mã OTP',
                ),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              onTap: () {
                verifyOtpCode(_controller.text);
              },
              btnText: 'Xác nhận',
              btnWidth: 300,
              btnHeight: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Chưa nhận được mã?',
                  style: TextStyle(fontSize: 14, color: AppColors.black),
                ),
                CustomTextButton(
                  onTap: _remainingTime == 0 ? resendCode : null,
                  btnText: 'Gửi lại mã',
                  fontSize: 14,
                  btnTextColor:
                      _remainingTime > 0 ? AppColors.gray : AppColors.red,
                )
              ],
            ),
            Text(
              'Yêu cầu gửi lại mã trong 00:${_remainingTime.toString().padLeft(2, '0')}s',
              style: TextStyle(
                fontSize: 14,
                color: _remainingTime > 0 ? AppColors.red : AppColors.gray,
              ),
            ),
            // SizedBox(height: 20),
            const Spacer(),
            if (widget.showButton)
              CustomTextButton(
                onTap: _handleLater,
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
