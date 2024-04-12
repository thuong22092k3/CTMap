import 'package:flutter/material.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/assets/colors/colors.dart';

class DetailSheet extends StatelessWidget {
  const DetailSheet({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero, 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chi tiết vụ tai nạn',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.red,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildInfoRow('Ngày', '10/04/2024'),
          SizedBox(height: 10),
          _buildSeverityRow(),
          SizedBox(height: 10),
          _buildInfoRow('Loại tai nạn', '...'),
          SizedBox(height: 10),
          _buildInfoRow('Số phương tiện liên quan', '...'),
          SizedBox(height: 10),
          _buildInfoRow('Số người chết', '...'),
          SizedBox(height: 10),
          _buildInfoRow('Cập nhật bởi', '...'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
    children: [
      Expanded(
        flex: 1,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            title + ':',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
      SizedBox(width: 20), 
      Expanded(
        flex: 2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildSeverityRow() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Mức độ:",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(width: 20), 
        Expanded(
          flex: 2,
          child: Row(
            children: [
              NumberedLocationIcon(
                iconData: AppIcons.location, 
                number: 0, 
              ),
              NumberedLocationIcon(
                iconData: AppIcons.location, 
                number: 0, 
              ),
              NumberedLocationIcon(
                iconData: AppIcons.location, 
                number: 0, 
              ),
              NumberedLocationIcon(
                iconData: AppIcons.location, 
                number: 4, 
              ),
              NumberedLocationIcon(
                iconData: AppIcons.location, 
                number: 0, 
              ),
            ],
          ),
        ),
      ],
    );
  }
}
