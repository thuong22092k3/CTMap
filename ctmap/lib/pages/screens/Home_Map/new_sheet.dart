// ignore_for_file: avoid_print

import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/routes/routes.dart';
import 'package:ctmap/pages/screens/Home_Map/info_sheet.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/state_management/accident_state.dart';
import 'package:ctmap/state_management/user_state.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/widgets/components/dropdown/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewSheet extends ConsumerStatefulWidget {
  final LatLng addPosition;

  const NewSheet({super.key, required this.addPosition});

  @override
  NewSheetState createState() => NewSheetState();
}

class NewSheetState extends ConsumerState<NewSheet> {
  bool showUserName = false;
  List<String> acciType = [
    'Rượu bia/ Ma túy',
    'Vi phạm tốc độ, thiếu quan sát, vượt đèn đỏ, mất lái…',
    'Phương tiện không đảm bảo an toàn',
    'Thời tiết',
    'Cơ sở hạ tầng giao thông',
    'Khác',
  ];

  String selectedAcciType = 'Rượu bia/ Ma túy';

  late TextEditingController _ngayController;
  late TextEditingController _loaiController;
  late TextEditingController _soPhuongTienController;
  late TextEditingController _soNguoiChetController;
  late TextEditingController _soNguoiBiThuongController;

  @override
  void initState() {
    super.initState();
    _ngayController = TextEditingController();
    _ngayController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _loaiController = TextEditingController();
    _soPhuongTienController = TextEditingController();
    _soNguoiChetController = TextEditingController();
    _soNguoiBiThuongController = TextEditingController();
  }

  @override
  void dispose() {
    _ngayController.dispose();
    _loaiController.dispose();
    _soPhuongTienController.dispose();
    _soNguoiChetController.dispose();
    _soNguoiBiThuongController.dispose();
    super.dispose();
  }

  int calculateAccidentLevel(int deaths, int injuries) {
    if (deaths == 0) {
      if (injuries < 2) {
        return 1;
      } else {
        return 2;
      }
    } else if (deaths == 1) {
      return 3;
    } else if (deaths == 2) {
      return 4;
    } else {
      return 5;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null) {
      setState(() {
        _ngayController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  void _validateAndSubmit() async {
    if (_ngayController.text.isEmpty ||
        _soPhuongTienController.text.isEmpty ||
        _soNguoiChetController.text.isEmpty ||
        _soNguoiBiThuongController.text.isEmpty ||
        selectedAcciType.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Lỗi",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            content: const Text(
              "Vui lòng nhập đầy đủ thông tin.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            actions: [
              Center(
                child: CustomButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  btnColor: AppColors.red,
                  btnText: "Đã hiểu",
                  btnTextColor: AppColors.white,
                  btnHeight: 30,
                  borderRadius: 5,
                  btnWidth: 140,
                  fontSize: 14,
                ),
              ),
            ],
          );
        },
      );
    } else {
      try {
        final userState = ref.read(userStateProvider);

        DateTime date = DateFormat('dd/MM/yyyy').parse(_ngayController.text);
        int sophuongtienlienquan = int.parse(_soPhuongTienController.text);
        int deaths = int.parse(_soNguoiChetController.text);
        int injuries = int.parse(_soNguoiBiThuongController.text);
        int level = calculateAccidentLevel(deaths, injuries);
        int cause = acciType.indexOf(selectedAcciType) + 1;
        LatLng position = widget.addPosition;
        String positionStr = '${position.latitude}, ${position.longitude}';
        String link = '';
        String userName = userState.userName;

        final accidentData = {
          'date': DateFormat('dd/MM/yyyy').format(date),
          'deaths': deaths.toString(),
          'injuries': injuries.toString(),
          'level': level.toString(),
          'cause': cause.toString(),
          'position': positionStr,
          'link': link.toString(),
          'userName': userName,
          'showUserName': showUserName,
          'sophuongtienlienquan': sophuongtienlienquan.toString(),
        };

        await addAccident(accidentData);
        ref.read(accidentProvider.notifier).addAccident(accidentData);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Home()));
        if(!mounted) return;
        context.push(RoutePaths.home);
      } catch (e) {
        print('Error: $e');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Lỗi",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              content: const Text(
                "Đã xảy ra lỗi khi thêm vụ tai nạn. Vui lòng thử lại sau.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              actions: [
                Center(
                  child: CustomButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    btnColor: AppColors.red,
                    btnText: "Đã hiểu",
                    btnTextColor: AppColors.white,
                    btnHeight: 30,
                    borderRadius: 5,
                    btnWidth: 140,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
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
          child: Column(
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
                      const SizedBox(
                        width: 8,
                      ),
                      IconButton(
                          icon: const Icon(
                            AppIcons.info,
                            color: AppColors.blue,
                          ),
                          onPressed: () {
                            showInfoModal(context);
                          },
                          padding: EdgeInsets.zero),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              _buildDayInputRow(
                  "Ngày", _ngayController, () => _selectDate(context)),
              _buildLevelInputRow("Mức độ tai nạn", _soNguoiChetController,
                  _soNguoiBiThuongController),
              _buildDropdownRow("Loại tai nạn", _loaiController),
              _buildNumberInputRow(
                  "Số phương tiện liên quan", _soPhuongTienController),
              _buildNumberInputRow("Số người chết", _soNguoiChetController),
              _buildNumberInputRow(
                  "Số người bị thương", _soNguoiBiThuongController),
              // const SizedBox(
              //   height: 20,
              // ),
              CheckboxListTile(
                title: const Text(
                  "Hiển thị tên của bạn",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Mulish',
                  ),
                ),
                value: showUserName,
                onChanged: (bool? value) {
                  setState(() {
                    showUserName = value ?? false;
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    btnColor: AppColors.dartGrey,
                    btnText: "Hủy",
                    btnTextColor: AppColors.white,
                    btnHeight: 30,
                    borderRadius: 5,
                    btnWidth: 140,
                    fontSize: 14,
                  ),
                  CustomButton(
                    onTap: _validateAndSubmit,
                    btnColor: AppColors.red,
                    btnText: "Xác nhận",
                    btnTextColor: AppColors.white,
                    btnHeight: 30,
                    borderRadius: 5,
                    btnWidth: 140,
                    fontSize: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildDayInputRow(String label, TextEditingController controller,
      [VoidCallback? onTap]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 200,
            height: 40,
            child: TextFormField(
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Mulish',
              ),
              controller: controller,
              onTap: onTap,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                suffixIcon: InkWell(
                  onTap: onTap,
                  child: const Icon(
                    AppIcons.calendar,
                    color: AppColors.red,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Mulish',
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: SizedBox(
            width: 250,
            height: 40,
            child: CustomDropdown(
              items: acciType,
              selectedItem: selectedAcciType,
              dropdownHeight: 40,
              onChanged: (newValue) {
                setState(() {
                  selectedAcciType = newValue ?? selectedAcciType;
                });
              },
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildNumberInputRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 200,
            height: 40,
            child: TextFormField(
              style: const TextStyle(fontSize: 12),
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}$'))
              ],
              //onTap: onTap,
              readOnly: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelInputRow(
      String label,
      TextEditingController soNguoiChetController,
      TextEditingController soNguoiBiThuongController) {
    int fatalities = int.tryParse(soNguoiChetController.text) ?? 0;
    int injuries = int.tryParse(soNguoiBiThuongController.text) ?? 0;
    int accidentLevel = calculateAccidentLevel(fatalities, injuries);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Mulish',
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          for (int i = 1; i <= 5; i++)
            NumberedLocationIcon(
              iconData: AppIcons.location,
              number: i,
              isMatched: i == accidentLevel,
            ),
        ],
      ),
    );
  }
}
