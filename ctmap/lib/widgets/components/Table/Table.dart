import 'package:flutter/material.dart';
import 'package:ctmap/data/type.dart';
import 'package:geocoding/geocoding.dart';

class CustomTable extends StatelessWidget {
  final List<AccidentData> accidentDataList;

  const CustomTable({Key? key, required this.accidentDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    Map<String, int> cityAccidentCount = {};
    accidentDataList.forEach((accident) {
      String city = accident.position.toString();
      if (cityAccidentCount.containsKey(city)) {
        cityAccidentCount[city] = cityAccidentCount[city]! + 1;
      } else {
        cityAccidentCount[city] = 1;
      }
    });

    // Sắp xếp danh sách các thành phố dựa trên số lượng tai nạn
    List<String> sortedCities = cityAccidentCount.keys.toList()
      ..sort((a, b) => cityAccidentCount[b]!.compareTo(cityAccidentCount[a]!));

    return DataTable(
      columns: [
        DataColumn(label: Text('Thành phố')),
        DataColumn(label: Text('SL')),
      ],
      rows: sortedCities
          .map((city) => DataRow(cells: [
                DataCell(Text(city)),
                DataCell(Text(cityAccidentCount[city].toString())),
              ]))
          .toList(),
    );
  }
}
