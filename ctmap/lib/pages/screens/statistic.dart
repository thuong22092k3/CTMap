import 'package:ctmap/data/type.dart';
import 'package:ctmap/services/api.dart';
import 'package:flutter/material.dart';
import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import '../../widgets/components/Button/Button.dart';
import '../../widgets/components/Dropdown/Dropdown.dart';
import '../../widgets/components/Chart/BarChart.dart';
import '../../widgets/components/Table/Table.dart';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  List<String> cities = ['TP Hồ Chí Minh', 'Gia Lai', 'Bình Dương'];
  String selectedCity = 'TP Hồ Chí Minh';
  List<String> options = ['Ngày', 'Tuần', 'Tháng'];
  String selectedOption = 'Ngày';
  bool showChart = true;
  bool isListButtonSelected = false;
  bool isChartButtonSelected = true;
  List<AccidentData> accidentDataList = [];
  void initState() {
    super.initState();
    getAccidents();
  }

  Future<void> getAccidents() async {
    List<AccidentData> accidents = await getAllAccidents();
    if (accidents.isNotEmpty) {
      print('Dữ liệu đã được lấy thành công.');
    } else {
      print('Không có dữ liệu.');
    }
    setState(() {
      accidentDataList = accidents;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final accidentDataList = context.read(accidentDataProvider).state;
    print('Accident Data List in Statistic: $accidentDataList');
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
                    'Tổng số vụ tai nạn: ${accidentDataList.length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  if (showChart)
                    // Container(
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 20, horizontal: 20),

                    //   // decoration: BoxDecoration(
                    //   //   color: Colors.white,
                    //   //   borderRadius: BorderRadius.circular(10),
                    //   //   boxShadow: [
                    //   //     BoxShadow(
                    //   //       color: Colors.grey.withOpacity(0.5),
                    //   //       spreadRadius: 2,
                    //   //       blurRadius: 5,
                    //   //       offset: Offset(0, 3),
                    //   //     ),
                    //   //   ],
                    //   // ),
                    //   // child: Column(
                    //   //   crossAxisAlignment: CrossAxisAlignment.stretch,
                    //   //   children: [
                    //   //     CustomDropdown(
                    //   //       items: cities,
                    //   //       selectedItem: selectedCity,
                    //   //       dropdownHeight: 30,
                    //   //       onChanged: (newValue) {
                    //   //         setState(() {
                    //   //           selectedCity = newValue ?? selectedCity;
                    //   //         });
                    //   //       },
                    //   //     ),
                    //   //     SizedBox(height: 10),
                    //   //     Row(
                    //   //       children: [
                    //   //         Expanded(
                    //   //           flex: 1,
                    //   //           child: CustomDropdown(
                    //   //             items: options,
                    //   //             selectedItem: selectedOption,
                    //   //             dropdownHeight: 30,
                    //   //             borderRadius: 0,
                    //   //             onChanged: (newValue) {
                    //   //               setState(() {
                    //   //                 selectedOption =
                    //   //                     newValue ?? selectedOption;
                    //   //               });
                    //   //             },
                    //   //           ),
                    //   //         ),
                    //   //         VerticalDivider(color: AppColors.black),
                    //   //         Expanded(
                    //   //           flex: 1,
                    //   //           child: CustomButton(
                    //   //             onTap: () {},
                    //   //             icon: AppIcons.calendar,
                    //   //             iconColor: AppColors.red,
                    //   //             btnHeight: 35,
                    //   //             btnColor: AppColors.lightGrey,
                    //   //           ),
                    //   //         )
                    //   //       ],
                    //   //     ),
                    //   //     SizedBox(height: 10),
                    //   //     CustomButton(
                    //   //       onTap: () {},
                    //   //       btnText: "Tìm kiếm",
                    //   //       btnHeight: 30,
                    //   //       borderRadius: 5,
                    //   //       btnWidth: 140,
                    //   //       fontSize: 14,
                    //   //     ),
                    //   //   ],
                    //   // ),
                    // ),
                    // SizedBox(height: 20),
                    if (showChart)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 300,
                              child: CustomBarChart(
                                dataMode: DataMode.level,
                                accidentDataList: accidentDataList,
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 300,
                              child: CustomBarChart(
                                dataMode: DataMode.cause,
                                accidentDataList: accidentDataList,
                              ),
                            ),
                          ],
                        ),
                      ),
                  if (!showChart)
                    SizedBox(
                      child: CustomTable(accidentDataList: accidentDataList),
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
