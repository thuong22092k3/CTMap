// ignore_for_file: avoid_print

import 'package:ctmap/data/type.dart';
import 'package:ctmap/state_management/accident_state.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/components/button/button.dart';
import '../../widgets/components/dropdown/dropdown.dart';
import '../../widgets/components/chart/bar_chart.dart';
import '../../widgets/components/table/table.dart';

// sửa ở statefulwidget -> ConsumerStatefulWidget
class Statistic extends ConsumerStatefulWidget {
  const Statistic({super.key});

  @override
  StatisticState createState() => StatisticState();
}

// sửa ở state -> ConsumerState
class StatisticState extends ConsumerState<Statistic> {
  List<String> cities = ['Tất cả'];
  String selectedCity = 'Tất cả';
  String selectedOption = 'Ngày';
  DateTime selectedDate = DateTime.now();
  List<String> options = ['Ngày', 'Tuần', 'Tháng', 'Quý', 'Năm'];
  bool showChart = true;
  bool isListButtonSelected = false;
  bool isChartButtonSelected = true;
  List<AccidentData> accidentDataList = [];
  List<AccidentData> filteredAccidentDataList = [];
  List<AccidentData> accidentCountByCity = [];
  List<AccidentData> accidentDataListTable = [];

  @override
  void initState() {
    super.initState();
    // getAccidents();

    fetchAccidents();
  }

  void countAccidentsByCity(List<AccidentData> accidents) {
    Map<String, int> cityAccidentCount = {};
    setState(() {
      for (var accident in accidents) {
        cityAccidentCount[accident.city] =
            (cityAccidentCount[accident.city] ?? 0) + 1;
      }
    });
    // return cityAccidentCount;
  }
  
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> fetchAccidents() async {
    await ref.read(accidentProvider.notifier).getAccidents();
    final accidentProviderData = ref.watch(accidentProvider);
    Set<String> uniqueCities =
        accidentProviderData.map((accident) => accident.city).toSet();

    setState(() {
      accidentDataList = accidentProviderData;
      filteredAccidentDataList = accidentProviderData;
      accidentCountByCity = accidentProviderData;
      cities = ['Tất cả', ...uniqueCities];
    });
  }

  List<AccidentData> getFilteredAccidents(List<AccidentData> accidentDataList) {
    DateTimeRange dateRange = getDateRange(selectedOption, selectedDate);

    return accidentDataList.where((accident) {
      bool isInDateRange = accident.date
              .isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
          accident.date.isBefore(dateRange.end.add(const Duration(days: 1)));
      bool isInCity = selectedCity == 'Tất cả' || accident.city == selectedCity;
      return isInDateRange && isInCity;
    }).toList();
  }

  DateTimeRange getDateRange(String selectedOption, DateTime selectedDate) {
    DateTime startDate;
    DateTime endDate;

    switch (selectedOption) {
      case 'Ngày':
        startDate = selectedDate;
        endDate = selectedDate;
        break;
      case 'Tuần':
        startDate =
            selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        endDate = startDate.add(const Duration(days: 6));
        break;
      case 'Tháng':
        startDate = DateTime(selectedDate.year, selectedDate.month, 1);
        endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        break;
      case 'Quý':
        int quarter = ((selectedDate.month - 1) ~/ 3) + 1;
        startDate = DateTime(selectedDate.year, (quarter - 1) * 3 + 1, 1);
        endDate = DateTime(selectedDate.year, quarter * 3 + 1, 0);
        break;
      case 'Năm':
        startDate = DateTime(selectedDate.year, 1, 1);
        endDate = DateTime(selectedDate.year, 12, 31);
        break;
      default:
        startDate = selectedDate;
        endDate = selectedDate;
        break;
    }

    return DateTimeRange(start: startDate, end: endDate);
  }

  bool isSearchButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final accidentDataList = ref.watch(accidentProvider);
    Set<String> uniqueCities =
        accidentDataList.map((accident) => accident.city).toSet();
    List<String> cities = ['Tất cả', ...uniqueCities];
    accidentCountByCity = accidentDataList;
    countAccidentsByCity(accidentCountByCity);
    print(
        'Filtered Accident Data List in Statistic: $filteredAccidentDataList');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thống Kê",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.normal
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: () {
                      setState(() {
                        showChart = true;
                        isListButtonSelected = false;
                        isChartButtonSelected = true;
                      });
                    },
                    btnText: "Biểu đồ",
                    btnHeight: 30,
                    borderRadius: 5,
                    btnWidth: 140,
                    fontSize: 14,
                    btnColor: isChartButtonSelected
                        ? AppColors.red
                        : AppColors.primaryGray,
                  ),
                  const SizedBox(width: 20),
                  CustomButton(
                    onTap: () {
                      setState(() {
                        showChart = false;
                        isListButtonSelected = true;
                        isChartButtonSelected = false;
                      });
                    },
                    btnText: "Danh sách",
                    btnHeight: 30,
                    borderRadius: 5,
                    btnWidth: 140,
                    fontSize: 14,
                    btnColor: isListButtonSelected
                        ? AppColors.red
                        : AppColors.primaryGray,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Tổng số vụ tai nạn: ${showChart ? (isSearchButtonPressed ? getFilteredAccidents(accidentDataList).length : accidentDataList.length) : accidentDataList.length}',
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 20),
              if (showChart)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomDropdown(
                        items: cities,
                        selectedItem: selectedCity,
                        dropdownHeight: 30,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCity = newValue ?? selectedCity;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: CustomDropdown(
                                        items: options,
                                        selectedItem: selectedOption,
                                        dropdownHeight: 30,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOption =
                                                newValue ?? selectedOption;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                    height: 30,
                                    child: VerticalDivider(
                                      color: AppColors.gray,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2025),
                                          helpText: 'Chọn ngày',
                                        );
                                        if (pickedDate != null) {
                                          setState(() {
                                            selectedDate = pickedDate;
                                          });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedOption == 'Ngày'
                                                ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                                                : selectedOption == 'Tuần'
                                                    ? "${getDateRange(selectedOption, selectedDate).start.day}/${getDateRange(selectedOption, selectedDate).start.month}/${getDateRange(selectedOption, selectedDate).start.year} - ${getDateRange(selectedOption, selectedDate).end.day}/${getDateRange(selectedOption, selectedDate).end.month}/${getDateRange(selectedOption, selectedDate).end.year}" // Week format, showing start and end of the week
                                                    : selectedOption ==
                                                            'Tháng'
                                                        ? "Tháng ${selectedDate.month}/${selectedDate.year}"
                                                        : selectedOption ==
                                                                'Quý'
                                                            ? "Quý ${((selectedDate.month - 1) ~/ 3) + 1}/${selectedDate.year}"
                                                            : "${selectedDate.year}",
                                            style: TextStyle(
                                              fontSize:
                                                  selectedOption == 'Tuần'
                                                      ? 12
                                                      : null,
                                            ),
                                          ),

                                          const Icon(
                                            AppIcons.calendar,
                                            color: AppColors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onTap: () {
                          setState(() {
                            filteredAccidentDataList =
                                getFilteredAccidents(accidentDataList);
                            isSearchButtonPressed = true;
                          });
                        },
                        btnText: "Tìm kiếm",
                        btnHeight: 30,
                        borderRadius: 5,
                        btnWidth: 140,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              if (showChart)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Biểu đồ thể hiện số vụ tai nạn theo mức độ tai nạn',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.red),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: CustomBarChart(
                          dataMode: DataMode.level,
                          accidentDataList: isSearchButtonPressed
                              ? getFilteredAccidents(accidentDataList)
                              : accidentDataList,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Biểu đồ thể hiện số vụ tai nạn theo loại tai nạn',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.red),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: CustomBarChart(
                          dataMode: DataMode.cause,
                          accidentDataList: isSearchButtonPressed
                              ? getFilteredAccidents(accidentDataList)
                              : accidentDataList,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!showChart)
                SizedBox(
                  child: CustomTable(accidentDataList: accidentCountByCity),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
