import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? btnWidth;
  final double? btnHeight;
  final String? btnText;
  final Color? btnTextColor;
  final double? fontSize;
  final Color btnColor;
  final IconData? icon; 

  const CustomButton({
    Key? key,
    required this.onTap,
    this.btnText, 
    this.btnTextColor = AppColors.white,
    this.fontSize = 14,
    this.btnWidth,
    this.btnHeight,
    this.btnColor = AppColors.red,
    this.icon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth ?? MediaQuery.of(context).size.width,
            btnHeight ?? MediaQuery.of(context).size.height * 0.06),
        backgroundColor: btnColor,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: Row( 
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: btnTextColor),
            if (icon != null && btnText != null) SizedBox(width: 8),
            if (btnText != null) 
              Text(
                btnText!,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: fontSize,
                  color: btnTextColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
