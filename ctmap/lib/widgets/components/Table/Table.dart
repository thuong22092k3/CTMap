import 'package:flutter/material.dart';
import 'package:ctmap/data/type.dart';
import 'package:geocoding/geocoding.dart';

class CustomTable extends StatelessWidget {
  final List<AccidentData> accidentDataList;

  const CustomTable({Key? key, required this.accidentDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _getCityAccidentCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); 
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); 
        } else {
          Map<String, int> cityAccidentCount = snapshot.data!;
        
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
      },
    );
  }

  Future<Map<String, int>> _getCityAccidentCount() async {
    Map<String, int> cityAccidentCount = {};

    for (AccidentData accident in accidentDataList) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          accident.position.latitude, accident.position.longitude);

      String city = placemarks.isNotEmpty
          ? placemarks[0].locality ?? 'Unknown'
          : 'Unknown';

      if (cityAccidentCount.containsKey(city)) {
        cityAccidentCount[city] = cityAccidentCount[city]! + 1;
      } else {
        cityAccidentCount[city] = 1;
      }
    }

    return cityAccidentCount;
  }
}
