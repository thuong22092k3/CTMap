import 'package:ctmap/data/type.dart';
import 'package:ctmap/services/api.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import '../../widgets/components/Button/Button.dart';
import '../../widgets/components/Dropdown/Dropdown.dart';
import '../../widgets/components/Chart/BarChart.dart';
import '../../widgets/components/Table/Table.dart';
import '../../widgets/components/Calendar/Calendar.dart';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
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
  Map<String, int> accidentCountByCity = {};
  List<AccidentData> accidentDataListTable = [];

  @override
  void initState() {
    super.initState();
    getAccidents();
  }

  Future<void> getAccidents() async {
    List<AccidentData> accidents = await getAllAccidents();
    if (accidents.isNotEmpty) {
      print('Dữ liệu đã được lấy thành công.');

      Set<String> uniqueCities =
          accidents.map((accident) => accident.city).toSet();

      setState(() {
        accidentDataList = accidents;
        filteredAccidentDataList = accidents;
        cities = ['Tất cả', ...uniqueCities];
        accidentCountByCity = _countAccidentsByCity(accidents);
      });
    } else {
      print('Không có dữ liệu.');
    }
  }

  Map<String, int> _countAccidentsByCity(List<AccidentData> accidents) {
    Map<String, int> cityAccidentCount = {};
    for (var accident in accidents) {
      cityAccidentCount[accident.city] =
          (cityAccidentCount[accident.city] ?? 0) + 1;
    }
    return cityAccidentCount;
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
        endDate = startDate.add(Duration(days: 6));
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

  void filterAccidents() {
    DateTimeRange dateRange = getDateRange(selectedOption, selectedDate);

    setState(() {
      if (selectedCity == 'Tất cả') {
        filteredAccidentDataList = accidentDataList.where((accident) {
          return accident.date.isAfter(dateRange.start) &&
              accident.date.isBefore(dateRange.end);
        }).toList();
      } else {
        filteredAccidentDataList = accidentDataList
            .where((accident) =>
                accident.city == selectedCity &&
                accident.date.isAfter(dateRange.start) &&
                accident.date.isBefore(dateRange.end))
            .toList();
      }
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Filtered Accident Data List in Statistic: $filteredAccidentDataList');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverHeaderDelegate(
              minHeight: 86,
              maxHeight: 86,
              child: Container(
                color: AppColors.red,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: const Center(
                  child: Text(
                    'Thống Kê',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                      SizedBox(width: 20),
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
                  SizedBox(height: 20),
                  Text(
                    'Tổng số vụ tai nạn: ${filteredAccidentDataList.length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  if (showChart)
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
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
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
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
                                      Container(
                                        height: 30,
                                        child: VerticalDivider(
                                          color: AppColors.gray,
                                          thickness: 1,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
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
                                              ),
                                              Icon(
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
                          SizedBox(height: 10),
                          CustomButton(
                            onTap: () {
                              filterAccidents();
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
                  SizedBox(height: 20),
                  if (showChart)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: CustomBarChart(
                              dataMode: DataMode.level,
                              accidentDataList: filteredAccidentDataList,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 300,
                            child: CustomBarChart(
                              dataMode: DataMode.cause,
                              accidentDataList: filteredAccidentDataList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!showChart)
                    SizedBox(
                      child: CustomTable(
                          accidentDataList: filteredAccidentDataList),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
