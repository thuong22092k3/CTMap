import 'package:ctmap/assets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String?>? onChanged;
  final double? dropdownHeight;
  final double? dropdownWidth;
  final double? borderRadius;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
    this.onChanged,
    this.dropdownHeight,
    this.dropdownWidth,
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dropdownHeight,
      width: dropdownWidth,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<String>(
        value: selectedItem,
        onChanged: onChanged,
        underline: SizedBox(),
        icon: Icon(AppIcons.dropdown, color: AppColors.red),
        iconSize: 24,
        isExpanded: true,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Mulish',
          fontSize: 14,
        ),
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
