import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final IconData? icon;
  final TextEditingController controller;
  final bool isLeftIcon; // thuộc tính trái hay phải của icon
  final Color iconColor; // màu của icon
  final Color backgroundColor; // màu của background
  final Color hintTextColor; // màu của hint text
  final bool isPassword; // thuộc tính xác định input là password
  final double textFieldWidth;
  final double textFieldHeight;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.icon,
    required this.controller,
    this.isLeftIcon = true,
    this.iconColor = AppColors.primaryGray,
    this.backgroundColor = AppColors.lightGrey,
    this.hintTextColor = AppColors.lightGrey,
    this.isPassword = false, // Mặc định không phải là input password
    this.textFieldWidth = double.infinity,
    this.textFieldHeight = 50,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.textFieldWidth,
      height: widget.textFieldHeight,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (widget.isLeftIcon)
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(widget.icon, color: widget.iconColor),
            ),
          Expanded(
            child: TextField(
              enableSuggestions: false,
              autocorrect: false,
              controller: widget.controller,
              style: TextStyle(color: Colors.black),
              obscureText: widget.isPassword ? _obscureText : false,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    color: widget.hintTextColor,
                    fontSize: 14,
                    fontFamily: 'Mulish'),
                border: InputBorder.none,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? AppIcons.visibility_off
                              : AppIcons.visibility,
                          color: AppColors.primaryGray,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(100),
                //   borderSide: BorderSide.none,
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(100),
                //   borderSide: BorderSide.none,
                // ),
              ),
            ),
          ),
          if (!widget.isLeftIcon) Icon(widget.icon, color: widget.iconColor),
        ],
      ),
    );
  }
}
