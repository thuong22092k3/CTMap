import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/data/type.dart';
import 'package:ctmap/state_management/accident_state.dart';
import 'package:ctmap/state_management/filter_state.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:ctmap/widgets/components/dropdown/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterSheet extends ConsumerStatefulWidget {
  final Function(List<AccidentData>) onFilterApplied;
  final Function(bool) onFilterStatusChanged; 
  //final bool isFiltered;

  const FilterSheet({
    super.key, 
    required this.onFilterApplied, 
    required this.onFilterStatusChanged
  });

  @override
  FilterSheetState createState() => FilterSheetState();
}

class FilterSheetState extends ConsumerState<FilterSheet> {
  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  final Map<String, int> acciTypeMap = {
    'Tất cả': 0,
    'Rượu bia/ Ma túy': 1,
    'Vi phạm tốc độ, mất lái ...': 2,
    'Phương tiện không đảm bảo an toàn': 3,
    'Thời tiết': 4,
    'Cơ sở hạ tầng giao thông': 5,
    'Khác': 6,
  };

  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  //int selectedLevel = 1;
  List<int> selectedLevels = [1, 2, 3, 4, 5];
  int selectedAcciType = 0; 

  List<AccidentData> accidentDataList = [];
  List<AccidentData> filteredAccidentDataList = [];
  bool isFilterPressed = false;

  Future<void> fetchAccidents() async {
    await ref.read(accidentProvider.notifier).getAccidents();
    final accidentProviderData = ref.watch(accidentProvider);

    setState(() {
      accidentDataList = accidentProviderData;
      filteredAccidentDataList = accidentProviderData;
    });
  }

  List<AccidentData> getFilteredAccidents(
    List<AccidentData> accidentDataList, 
    DateTime fromDate, 
    DateTime toDate, 
    //int level, 
    List<int> levels,
    int cause
    ) {

    if (cause == 0) {
      return accidentDataList.where((accident) {
        bool isInDateRange =
          accident.date.isAfter(fromDate.subtract(const Duration(days: 1))) && 
          accident.date.isBefore(toDate.add(const Duration(days: 1)));    
        bool isLevel = levels.contains(accident.level);

        return isInDateRange && isLevel;
      }).toList();
    }   
    else {
      return accidentDataList.where((accident) {
        bool isInDateRange =
            accident.date.isAfter(fromDate) && 
            accident.date.isBefore(toDate);
        //bool isLevel = accident.level == level;
        bool isLevel = levels.contains(accident.level);
        bool isCause = accident.cause == cause;

        return isInDateRange && isLevel && isCause;
      }).toList();
    }
    
  }

  @override
  void initState() {
    super.initState();
    fetchAccidents();
    final filterState = ref.read(filterProvider); 
    fromDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(filterState.selectedFromDate),
    );
    toDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(filterState.selectedToDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterProvider); 
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.3),
            //     blurRadius: 10,
            //     offset: const Offset(0, 5),
            //   ),
            // ],
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
              buildDayInputRow(
                "Từ ngày",
                fromDateController,
                () => selectFromDate(context),
              ),
              buildDayInputRow(
                "Đến ngày",
                toDateController,
                () => selectToDate(context),
              ),
              buildLevelInputRow("Mức độ tai nạn", filterState.selectedLevels),
              buildDropdownRow("Loại tai nạn", filterState.selectedAcciType),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onTap: () {
                      ref.read(filterProvider.notifier).resetFilters(); 

                      fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
                      toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

                      widget.onFilterApplied(accidentDataList);  
                      widget.onFilterStatusChanged(false);
                    },
                    btnColor: AppColors.dartGrey,
                    btnText: "Xóa lọc",
                    btnTextColor: AppColors.white,
                    btnHeight: 30,
                    borderRadius: 5,
                    btnWidth: 140,
                    fontSize: 14,
                  ),
                  CustomButton(
                    onTap: () {
                      if (filterState.selectedFromDate.isAfter(filterState.selectedToDate)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.')),
                        );
                        return;
                      }
                      widget.onFilterApplied(
                        getFilteredAccidents(
                          accidentDataList,
                          filterState.selectedFromDate,
                          filterState.selectedToDate,
                          filterState.selectedLevels,
                          filterState.selectedAcciType,
                        ),
                      );
                      widget.onFilterStatusChanged(true);

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

    Widget buildDayInputRow(
    String label,
    TextEditingController controller,
    VoidCallback onTap,
  ) {
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

  Widget buildLevelInputRow(String label, List<int> selectedLevels) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontFamily: 'Mulish'),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          for (int i = 1; i <= 5; i++)
            GestureDetector(
              onTap: () {
                ref.read(filterProvider.notifier).updateFilters(
                  levels: selectedLevels.contains(i)
                      ? selectedLevels.where((level) => level != i).toList()
                      : [...selectedLevels, i],
                );
              },
              child: NumberedLocationIcon(
                iconData: AppIcons.location,
                number: i,
                isMatched: selectedLevels.contains(i),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDropdownRow(String label, int selectedAcciType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontFamily: 'Mulish'),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 40,
              child: CustomDropdown(
                items: acciTypeMap.keys.toList(),
                selectedItem: acciTypeMap.keys.firstWhere(
                  (key) => acciTypeMap[key] == selectedAcciType,
                  orElse: () => 'Tất cả',
                ),
                dropdownHeight: 40,
                onChanged: (newValue) {
                  final newType = acciTypeMap[newValue];
                  if (newType != null) {
                    ref.read(filterProvider.notifier).updateFilters(
                      acciType: newType,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      fromDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      ref.read(filterProvider.notifier).updateFilters(fromDate: selectedDate);
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      toDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      ref.read(filterProvider.notifier).updateFilters(toDate: selectedDate);
    }
  }

}
