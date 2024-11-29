// ignore_for_file: avoid_print

import 'package:ctmap/pages/screens/Home_Map/edit_sheet.dart';
import 'package:ctmap/pages/screens/Home_Map/info_sheet.dart';
import 'package:ctmap/state_management/accident_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/data/type.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:share_plus/share_plus.dart';

class DetailSheet extends ConsumerStatefulWidget {
  final AccidentData accidentData;
  //final Function(bool) isMarkerDeleted; 

  const DetailSheet({
    super.key, 
    required this.accidentData,
    //required this.isMarkerDeleted,
  });

  @override
  DetailSheetState createState() => DetailSheetState();
}

class DetailSheetState extends ConsumerState<DetailSheet> {
  late final AccidentData accidentData;


  @override
  void initState() {
    super.initState();
    accidentData = widget.accidentData;
  }

  @override
  Widget build(BuildContext context) {
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
                offset: const Offset(0, 5),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Chi tiết vụ tai nạn',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.red,
                            ),
                          ),
                          const SizedBox(width: 8,),
                          IconButton(
                            icon: const Icon(
                              AppIcons.info,
                              color: AppColors.blue,
                            ),
                            onPressed: () {
                              showInfoModal(context);
                            },
                            padding: EdgeInsets.zero
                          ),
                        ],
                        
                      ),
                      IconButton(
                        icon: const Icon(AppIcons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('Ngày',
                      '${accidentData.date.day}/${accidentData.date.month}/${accidentData.date.year}'),
                  const SizedBox(height: 10),
                  _buildSeverityRow(accidentData.level),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      'Loại tai nạn', _displayCause(accidentData.cause)),
                  const SizedBox(height: 10),
                  _buildInfoRow('Số phương tiện liên quan',
                      '${accidentData.sophuongtienlienquan}'),
                  const SizedBox(height: 10),
                  _buildInfoRow('Số người chết', '${accidentData.deaths}'),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      'Số người bị thương', '${accidentData.injuries}'),
                  const SizedBox(height: 10),
                  _buildInfoRow('Địa điểm', accidentData.location),
                  const SizedBox(height: 10),
                  _buildInfoRow('Thành phố', accidentData.city),
                  if (accidentData.showUserName &&
                      accidentData.userName.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _buildInfoRow('Tên người dùng', accidentData.userName),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          AppIcons.share, 
                          color: AppColors.blue
                        ),
                        onPressed: () {
                          _shareAccidentDetails();
                        },
                      ),
                      if ((username.isNotEmpty) &&
                          (username == accidentData.userName ||
                              userState.email == accidentData.userName))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(AppIcons.delete, color: AppColors.red),
                              onPressed: () {
                                _handleDelete(context);
                              },
                            ),
                            const SizedBox(width: 10,),
                            IconButton(
                              icon: const Icon(AppIcons.edit, color: AppColors.blue),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return EditSheet(accidentData: accidentData);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
  
  void _handleDelete(BuildContext context) {
    final parentContext = context;
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
                Navigator.of(context).pop();
                //thêm dòng này trước await
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await deleteAccident(accidentData.id);
                  ref.read(accidentProvider.notifier).removeAccident(accidentData);               
                  if(!parentContext.mounted) return;
                  Navigator.of(parentContext).pop();
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text('Vụ tai nạn đã được xóa thành công')),
                  );
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
                  messenger.showSnackBar(
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

  void showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext context) {
        return const Dialog(
          child: InfoSheet(),
        );

      },
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
          child: NumberedLocationIcon(
            iconData: AppIcons.location,
            number: level,
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
