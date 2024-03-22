import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ctmap/assets/colors/colors.dart';


class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isLeftIcon; // thuộc tính trái hay phải của icon
  final Color iconColor; // màu của icon
  final Color backgroundColor; // màu của background
  final Color hintTextColor; // màu của hint text

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isLeftIcon = true, 
    this.iconColor = AppColors.primaryGray, 
    this.backgroundColor = AppColors.lightGrey,
    this.hintTextColor = AppColors.lightGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor, 
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (isLeftIcon) // check icon bên trái
            Icon(icon, color: iconColor), 
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(  
                hintText: hintText,
                hintStyle: TextStyle(color: hintTextColor),
                border: InputBorder.none,
              ),
            ),
          ),
          if (!isLeftIcon) // check icon bên phải
            Icon(icon, color: iconColor),
        ],
      ),
    );
  }
}
