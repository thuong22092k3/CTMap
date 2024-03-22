import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Color borderColor;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsetsGeometry margin; // Thêm thuộc tính margin

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(3)),
    this.borderColor = AppColors.primaryGray,
    this.activeColor = AppColors.red,
    this.inactiveColor = AppColors.white,
    this.margin = const EdgeInsets.all(0), // Gán giá trị mặc định cho margin
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        margin: widget.margin, // Thêm margin vào Container
        width: 15.0,
        height: 15.0,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: Border.all(
            width: widget.borderWidth,
            color: widget.borderColor,
          ),
          color: widget.value ? widget.activeColor : widget.inactiveColor,
        ),
        child: widget.value
            ? Icon(
                Icons.check,
                size: 12.0,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
