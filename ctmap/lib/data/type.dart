import 'package:latlong2/latlong.dart';

class AccidentData {
  final DateTime date;
  final int deaths;
  final int injuries;
  final int? number;
  final LatLng position;

  AccidentData({
    required this.date,
    required this.deaths,
    required this.injuries,
    required this.position,
    this.number,
  });
}

List<AccidentData> accidentDataList = [
  AccidentData(
      date: DateTime(2024, 4, 10),
      deaths: 2,
      injuries: 5,
      position: LatLng(10.87824, 106.80629),
      number: 1),
  AccidentData(
      date: DateTime(2024, 4, 10),
      deaths: 2,
      injuries: 5,
      position: LatLng(10.87, 106.80305),
      number: 2),
  AccidentData(
      date: DateTime(2024, 4, 10),
      deaths: 2,
      injuries: 5,
      position: LatLng(10.87512, 106.80072),
      number: 3),
  AccidentData(
      date: DateTime(2024, 4, 10),
      deaths: 2,
      injuries: 5,
      position: LatLng(10.87564, 106.79916),
      number: 4),
  AccidentData(
      date: DateTime(2024, 4, 10),
      deaths: 2,
      injuries: 5,
      position: LatLng(10.87758, 106.80161),
      number: 5),
  // Thêm các điểm dữ liệu khác tại đây...
];
