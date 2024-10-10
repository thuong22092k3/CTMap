import 'package:latlong2/latlong.dart';

class AccidentData {
  final String id;
  final DateTime date;
  final int deaths;
  final int injuries;
  final int level;
  final int cause;
  final LatLng position;
  final String link;
  final int sophuongtienlienquan;
  final String userName;
  final String location;
  final String city;
  final bool showUserName;

  AccidentData({
    required this.id,
    required this.date,
    required this.deaths,
    required this.injuries,
    required this.position,
    required this.level,
    required this.cause,
    required this.link,
    required this.sophuongtienlienquan,
    required this.userName,
    required this.location,
    required this.city,
    required this.showUserName,
  });
}

class UserData {
  final String userName;
  final String email;
  final String password;
  final String? resetPasswordToken;
  final DateTime? resetPasswordExpires;

  UserData({
    required this.userName,
    required this.email,
    required this.password,
    this.resetPasswordToken,
    this.resetPasswordExpires,
  });
}

// List<AccidentData> accidentDataListtest = [
//   AccidentData(
//       id: "1",
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87824, 106.80629),
//       level: 1,
//       cause: 1,
//       sophuongtienlienquan: 2,
//       userName: "Thuong",
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       id: "2",
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87, 106.80305),
//       level: 2,
//       cause: 2,
//       sophuongtienlienquan: 2,
//       userName: "Thuong",
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       id: "3",
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87512, 106.80072),
//       level: 3,
//       cause: 3,
//       sophuongtienlienquan: 2,
//       userName: "Thuong",
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       id: "4",
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87564, 106.79916),
//       level: 4,
//       cause: 4,
//       sophuongtienlienquan: 2,
//       userName: "Thuong",
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 5,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87758, 106.80161),
//       level: 5,
//       cause: 5,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 6,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.88055, 106.80538),
//       level: 3,
//       cause: 6,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 7,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87359, 106.80435),
//       level: 5,
//       cause: 5,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 8,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87532, 106.80602),
//       level: 2,
//       cause: 3,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 9,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87778, 106.80833),
//       level: 4,
//       cause: 3,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 10,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87673, 106.80414),
//       level: 5,
//       cause: 5,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 11,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87137, 106.80722),
//       level: 3,
//       cause: 2,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 12,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.8737, 106.80176),
//       level: 4,
//       cause: 1,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 13,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87683, 106.80058),
//       level: 2,
//       cause: 4,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 14,
//       date: DateTime(2024, 4, 10),
//       deaths: 3,
//       injuries: 5,
//       position: LatLng(10.87683, 106.80058),
//       level: 3,
//       cause: 5,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 15,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87771, 1106.80275),
//       level: 1,
//       cause: 4,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 16,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.88256, 106.79915),
//       level: 3,
//       cause: 2,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 17,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87482, 106.79869),
//       level: 3,
//       cause: 6,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 18,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.87977, 106.79792),
//       level: 1,
//       cause: 4,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
//   AccidentData(
//       //id: 19,
//       date: DateTime(2024, 4, 10),
//       deaths: 2,
//       injuries: 5,
//       position: LatLng(10.88325, 106.80817),
//       level: 2,
//       cause: 2,
//       sophuongtienlienquan: 2,
//       link:
//           "https://www.google.com/maps/d/u/0/edit?mid=1FqIp7_zZ58ExkAKXDiuRJ5Xsj7OdANo&ll=10.878405478230093%2C106.80511190809617&z=15"),
// ];
