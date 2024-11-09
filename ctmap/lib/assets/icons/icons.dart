import 'package:ctmap/assets/colors/colors.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static const IconData map = Icons.map;
  static const IconData newspaper = Icons.newspaper;
  static const IconData barChart = Icons.bar_chart;
  static const IconData person = Icons.person_outline;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_alt;
  static const IconData add_location = Icons.add_location_alt_outlined;
  static const IconData location = Icons.location_on_rounded;
  static const IconData email = Icons.email_outlined;
  static const IconData lock = Icons.lock_outline;
  static const IconData calendar = Icons.calendar_month_outlined;
  static const IconData help = Icons.help_outline;
  static const IconData logout = Icons.logout;
  static const IconData dropdown = Icons.keyboard_arrow_down_rounded;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibility_off = Icons.visibility_off_outlined;
  static const IconData left_arrow = Icons.arrow_back;
  static const IconData edit = Icons.edit_outlined;
  static const IconData camera = Icons.photo_camera_outlined;
  static const IconData delete = Icons.delete_outlined;
  static const IconData back = Icons.arrow_back_ios;
  static const IconData close = Icons.close;
  static const IconData menu = Icons.menu;
  static const IconData share = Icons.emergency_share_outlined;
  static const IconData info = Icons.info_outline;
  static const double defaultSize = 24.0;

  static Icon getIcon(IconData iconData,
      {double size = defaultSize, Color? color}) {
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}

class NumberedLocationIcon extends StatelessWidget {
  final IconData iconData;
  final int number;
  final double iconSize;
  final bool isMatched;

  NumberedLocationIcon({
    required this.iconData,
    required this.number,
    this.iconSize = 40,
    this.isMatched = true,
  });

  // Hàm trả về màu dựa trên số
  Color getColorBasedOnNumber(int number) {
    switch (number) {
      case 1:
        return Color(0xFFB7D63E);
      case 2:
        return Color(0xFFFFD632);
      case 3:
        return Color(0xFFFF914D);
      case 4:
        return Color(0xFFF40F2B);
      case 5:
        return Color(0xFFA151D1);
      default:
        return AppColors.dartGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color numberColor =
        isMatched ? getColorBasedOnNumber(number) : AppColors.dartGrey;

    return Stack(
      children: [
        Icon(
          iconData,
          color: numberColor,
          size: iconSize,
        ),
        Positioned(
          top: iconSize / 6,
          left: iconSize / 2.8,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              number.toString(),
              style: TextStyle(
                color: isMatched ? numberColor : AppColors.dartGrey,
                fontWeight: FontWeight.bold,
                fontSize: iconSize / 5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
