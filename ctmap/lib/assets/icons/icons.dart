import 'package:flutter/material.dart';

class AppIcons {
  static const IconData map = Icons.map;
  static const IconData newspaper = Icons.newspaper;
  static const IconData barChart = Icons.bar_chart;
  static const IconData person = Icons.person_outline;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_alt;
  static const IconData add_location = Icons.add_location_alt_outlined;
  static const IconData email = Icons.email_outlined;
  static const IconData lock = Icons.lock_outline;
  static const IconData calendar = Icons.calendar_month_outlined;
  static const IconData help = Icons.help_outline;
  static const IconData logout = Icons.logout;
  static const IconData dropdown = Icons.arrow_drop_down;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibility_off = Icons.visibility_off_outlined;
  static const IconData left_arrow = Icons.arrow_back;
  static const IconData edit = Icons.edit_outlined;
  static const IconData camera = Icons.photo_camera_outlined;

  // Định nghĩa kích thước mặc định của icon
  static const double defaultSize = 24.0; // Kích thước mặc định 24x24

  // Hàm tạo icon với kích thước được chỉ định
  static Icon getIcon(IconData iconData,
      {double size = defaultSize, Color? color}) {
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}
