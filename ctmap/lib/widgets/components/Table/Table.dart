import 'package:flutter/material.dart';
import 'package:ctmap/data/type.dart';
import 'package:ctmap/assets/colors/colors.dart';

class CustomTable extends StatelessWidget {
  final List<AccidentData> accidentDataList;

  const CustomTable({super.key, required this.accidentDataList});

  @override
  Widget build(BuildContext context) {
    Map<String, int> cityAccidentCount = _getCityAccidentCount();

    List<String> sortedCities = cityAccidentCount.keys.toList()
      ..sort((a, b) => cityAccidentCount[b]!.compareTo(cityAccidentCount[a]!));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        // width: 350, // Đặt chiều rộng bảng
        child: DataTable(
          columnSpacing: 20,
          columns: const [
            DataColumn(
              label: Text(
                'STT',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    backgroundColor: AppColors.gray),
              ),
            ),
            DataColumn(
              label: Text(
                'Tỉnh thành',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    backgroundColor: AppColors.gray),
              ),
            ),
            DataColumn(
              label: Text(
                'Số lượng tai nạn',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    backgroundColor: AppColors.gray),
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            sortedCities.length,
            (index) => DataRow(
              cells: [
                DataCell(Center(child: Text('${index + 1}'))), // STT
                DataCell(
                    Center(child: Text(sortedCities[index]))), // Tỉnh thành
                DataCell(Center(
                    child: Text(cityAccidentCount[sortedCities[index]]
                        .toString()))), // Số lượng tai nạn
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, int> _getCityAccidentCount() {
    Map<String, int> cityAccidentCount = {};

    for (AccidentData accident in accidentDataList) {
      String city = accident.city;

      if (cityAccidentCount.containsKey(city)) {
        cityAccidentCount[city] = cityAccidentCount[city]! + 1;
      } else {
        cityAccidentCount[city] = 1;
      }
    }

    return cityAccidentCount;
  }
}
