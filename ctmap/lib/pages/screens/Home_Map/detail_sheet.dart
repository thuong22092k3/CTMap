import 'package:ctmap/data/type.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/assets/colors/colors.dart';

class DetailSheet extends StatelessWidget {
  final AccidentData accidentData;
  const DetailSheet({Key? key, required this.accidentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
              _buildInfoRow('Ngày',
                  '${accidentData.date.day}/${accidentData.date.month}/${accidentData.date.year}'),
              SizedBox(height: 10),
              _buildSeverityRow(accidentData.level),
              SizedBox(height: 10),
              _buildInfoRow('Loại tai nạn', '${accidentData.cause}'),
              SizedBox(height: 10),
              _buildInfoRow('Số phương tiện liên quan',
                  '${accidentData.sophuongtienlienquan}'),
              SizedBox(height: 10),
              _buildInfoRow('Số người chết', '${accidentData.deaths}'),
              SizedBox(height: 10),
              _buildInfoRow('Số người bị thương', '${accidentData.injuries}'),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  AppIcons.edit,
                  color: AppColors.blue,
                ),
                onPressed: () {
                  // Xử lý sự kiện khi nút chỉnh sửa được nhấn
                },
              ),
              IconButton(
                icon: Icon(
                  AppIcons.delete,
                  color: AppColors.red,
                ),
                onPressed: () {
                  // Xử lý sự kiện khi nút xóa được nhấn
                },
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildSeverityRow(int level) {
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
              for (int i = 1; i <= 5; i++)
                NumberedLocationIcon(
                  iconData: AppIcons.location,
                  number: i,
                  isMatched:
                      i == level, 
                ),
            ],
          ),
        ),
      ],
    );
  }
}
