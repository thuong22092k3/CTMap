import 'package:ctmap/pages/screens/Home_Map/edit_sheet.dart';
import 'package:ctmap/pages/screens/Home_Map/home_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/data/type.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

class DetailSheet extends ConsumerWidget {
  final AccidentData accidentData;

  const DetailSheet({Key? key, required this.accidentData}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    final username = userState.userName;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chi tiết vụ tai nạn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.red,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(AppIcons.close),
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
                  _buildInfoRow(
                      'Loại tai nạn', '${_displayCause(accidentData.cause)}'),
                  SizedBox(height: 10),
                  _buildInfoRow('Số phương tiện liên quan',
                      '${accidentData.sophuongtienlienquan}'),
                  SizedBox(height: 10),
                  _buildInfoRow('Số người chết', '${accidentData.deaths}'),
                  SizedBox(height: 10),
                  _buildInfoRow(
                      'Số người bị thương', '${accidentData.injuries}'),
                  SizedBox(height: 10),
                  _buildInfoRow('Địa điểm', '${accidentData.location}'),
                  SizedBox(height: 10),
                  _buildInfoRow('Thành phố', '${accidentData.city}'),
                  if (accidentData.showUserName &&
                      accidentData.userName != null &&
                      accidentData.userName.isNotEmpty) ...[
                    SizedBox(height: 10),
                    _buildInfoRow('Tên người dùng', accidentData.userName),
                  ],
                  SizedBox(height: 10),
                ],
              ),
              if ((username != null && username.isNotEmpty) &&
                  (username == accidentData.userName ||
                      userState.email == accidentData.userName))
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(AppIcons.edit, color: AppColors.blue),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return EditSheet(accidentData: accidentData);
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(AppIcons.delete, color: AppColors.red),
                        onPressed: () {
                          _handleDelete(context);
                        },
                      ),
                    ],
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 50,
                child: IconButton(
                  icon: const Icon(AppIcons.share, color: AppColors.blue),
                  onPressed: () {
                    _shareAccidentDetails();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa vụ tai nạn này?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Xóa',
                style: TextStyle(color: AppColors.red),
              ),
              onPressed: () async {
                try {
                  await deleteAccident(accidentData.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vụ tai nạn đã được xóa thành công')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                  //Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Có lỗi xảy ra khi xóa vụ tai nạn: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _shareAccidentDetails() {
    String mapUrl =
        "//www.google.com/maps/search/?api=1&query=${accidentData.position.latitude},${accidentData.position.longitude}";

    String accidentDetails = '''
    ‼️  Vụ tai nạn tại ${accidentData.location} ‼️ 
      - Ngày: ${accidentData.date.day}/${accidentData.date.month}/${accidentData.date.year}
      - Nguyên nhân: ${_displayCause(accidentData.level)}
      - Số phương tiện liên quan: ${accidentData.sophuongtienlienquan}
      - Số người chết: ${accidentData.deaths}
      - Số người bị thương: ${accidentData.injuries}
      ➖➖➖➖➖➖➖➖➖
      📍Địa điểm: ${accidentData.location}
      📌Maps: "$mapUrl"
    ''';
    print(accidentDetails);
    Share.share(accidentDetails, subject: 'Thông tin vụ tai nạn giao thông');
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
              '$title:',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityRow(int level) {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Mức độ:",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              for (int i = 1; i <= 5; i++)
                NumberedLocationIcon(
                  iconData: AppIcons.location,
                  number: i,
                  isMatched: i == level,
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _displayCause(int cause) {
    switch (cause) {
      case 1:
        return "Rượu bia/ Ma túy";
      case 2:
        return "Vi phạm tốc độ, thiếu quan sát, vượt đèn đỏ, mất lái…";
      case 3:
        return "Phương tiện không đảm bảo an toàn";
      case 4:
        return "Thời tiết";
      case 5:
        return "Cơ sở hạ tầng giao thông";
      default:
        return "Khác";
    }
  }
}
