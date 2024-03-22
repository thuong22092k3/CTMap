import 'package:ctmap/assets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        value: selectedItem,
        onChanged: onChanged,
        underline: SizedBox(), // Ẩn underline mặc định của dropdown
        icon: Icon(AppIcons.dropdown, color: AppColors.red), // Icon mũi tên màu đỏ
        iconSize: 24,
        isExpanded: true,
        style: TextStyle(color: Colors.black),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
