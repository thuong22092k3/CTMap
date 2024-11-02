import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/state_management/accident_state.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:ctmap/widgets/components/Dropdown/Dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  List<String> acciType = [
    'Rượu bia/ Ma túy',
    'Vi phạm tốc độ, mất lái ...',
    'Phương tiện không đảm bảo an toàn',
    'Thời tiết',
    'Cơ sở hạ tầng giao thông',
    'Khác',
  ];

  String selectedAcciType = 'Rượu bia/ Ma túy';
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  int selectedLevel = 1;

  late TextEditingController _tuNgayController;
  late TextEditingController _denNgayController;

  @override
  void initState() {
    super.initState();
    _tuNgayController = TextEditingController();
    _denNgayController = TextEditingController();
  }

  @override
  void dispose() {
    _tuNgayController.dispose();
    _denNgayController.dispose();
    super.dispose();
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null) {
      setState(() {
        selectedFromDate = pickedDate;
        _tuNgayController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null) {
      setState(() {
        selectedToDate = pickedDate;
        _denNgayController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
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
                    'Lọc vụ tai nạn',
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
              _buildDayInputRow(
                  "Từ ngày", _tuNgayController, () => _selectFromDate(context)),
              _buildDayInputRow(
                  "Đến ngày", _denNgayController, () => _selectToDate(context)),
              _buildLevelInputRow("Mức độ tai nạn"),
              _buildDropdownRow("Loại tai nạn"),
              const SizedBox(
                height: 20,
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
                    onTap: () {
                      final container = ProviderScope.containerOf(context);
                      final accidentNotifier =
                          container.read(accidentProvider.notifier);
                      accidentNotifier.filterAccidents(
                        startDate: selectedFromDate,
                        endDate: selectedToDate,
                        level: selectedLevel,
                        cause: acciType.indexOf(selectedAcciType) + 1,
                      );
                  print('start: ${selectedFromDate}');
                  print('end: ${selectedToDate}');
                  print('Level: ${selectedLevel}');
                  print('Cause: ${acciType}');
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

  Widget _buildLevelInputRow(String label) {
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
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedLevel = i;
                });
              },
              child: NumberedLocationIcon(
                iconData: AppIcons.location,
                number: i,
                isMatched: i == selectedLevel,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String label) {
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
          Expanded(
            child: SizedBox(
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
            ),
          ),
        ],
      ),
    );
  }
}
