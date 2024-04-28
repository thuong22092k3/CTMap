import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Dropdown/Dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

class NewSheet extends StatefulWidget {
  const NewSheet({super.key});

  @override
  _NewSheetState createState() => _NewSheetState();
  
}

class _NewSheetState extends State
{
  List<String> acciType = [
    'Rượu bia/ Ma túy',
    'Vi phạm tốc độ, mất lái ...',
    'Phương tiện không đảm bảo an toàn',
    'Thời tiết',
    'Cơ sở hạ tầng giao thông',
    'Khác',
  ];

  String selectedAcciType = 'Rượu bia/ Ma túy';

  late TextEditingController _ngayController;
  //late TextEditingController _mucDoController;
  late TextEditingController _loaiController;
  late TextEditingController _soPhuongTienController;
  late TextEditingController _soNguoiChetController;
  late TextEditingController _soNguoiBiThuongController;

  @override
  void initState() {
    super.initState();
    _ngayController = TextEditingController();
    //_mucDoController = TextEditingController();
    _loaiController = TextEditingController();
    _soPhuongTienController = TextEditingController();
    _soNguoiChetController = TextEditingController();
    _soNguoiBiThuongController = TextEditingController();
  }

  @override
  void dispose() {
    _ngayController.dispose();
    //_mucDoController.dispose();
    _loaiController.dispose();
    _soPhuongTienController.dispose();
    _soNguoiChetController.dispose();
    _soNguoiBiThuongController.dispose();
    super.dispose();
  }
  int calculateAccidentLevel(int deaths, int injuries) {
    if (deaths == 0) {
      if(injuries < 2) {
        return 1;
      }
      else {
        return 2;
      }
    }
    else if (deaths == 1) {
      return 3;
    }
    else if (deaths == 2) {
      return 4;
    }
    else {
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
        _ngayController.text = pickedDate.toString().split(" ")[0];
      });
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
                  const Text(
                    'Thêm vụ tai nạn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              _buildDayInputRow("Ngày", _ngayController, () => _selectDate(context)),
              _buildLevelInputRow("Mức độ tai nạn", _soNguoiChetController, _soNguoiBiThuongController),
              _buildDropdownRow("Loại tai nạn", _loaiController),
              _buildNumberInputRow("Số phương tiện liên quan", _soPhuongTienController),
              _buildNumberInputRow("Số người chết", _soNguoiChetController),
              _buildNumberInputRow("Số người bị thương", _soNguoiBiThuongController),
              const SizedBox(height: 20,),
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
                    onTap: () {
                      Navigator.of(context).pop();
                    },
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

  Widget _buildDayInputRow(String label, TextEditingController controller, [VoidCallback? onTap]) {
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
                fontSize: 14,
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
                fontSize: 14,
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
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), 
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

  
  Widget _buildDropdownRow(String label, TextEditingController controller, [VoidCallback? onTap]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Mulish',
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
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
          )
        ],
      ),
    );
  }



  Widget _buildNumberInputRow(String label, TextEditingController controller, [VoidCallback? onTap]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 200,
            height: 40,
            child: TextFormField(
              style: const TextStyle(fontSize: 14),
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}$'))],
              //onTap: onTap,
              readOnly: false, 
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.lightGrey, 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), 
                  borderSide: BorderSide.none, 
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), 
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLevelInputRow(String label, TextEditingController soNguoiChetController, TextEditingController soNguoiBiThuongController) {
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
                fontSize: 14,
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