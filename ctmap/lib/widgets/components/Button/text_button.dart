import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? btnText;
  final Color? btnTextColor;
  final double? fontSize;
  final IconData? icon;
  final double? iconSize;

  const CustomTextButton({
    super.key,
    required this.onTap,
    this.btnText,
    this.btnTextColor = AppColors.red,
    this.fontSize = 11,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: btnTextColor,
                size: iconSize,
              ),
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
