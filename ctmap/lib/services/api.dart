import 'dart:convert';
import 'package:ctmap/services/path.dart';
import 'package:http/http.dart' as http;
import 'package:ctmap/data/type.dart';
import 'package:latlong2/latlong.dart';

const String BASE_URL =
    'https://ctmap-be.onrender.com'; // đổi "192.168.137.104" thành địa chỉ IPV4 của máy

DateTime parseDate(String dateStr) {
  List<String> parts = dateStr.split('/');
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);
  return DateTime(year, month, day);
}

Future<List<AccidentData>> getAllAccidents() async {
  List<AccidentData> accidents = [];
  try {
    final response =
        await http.get(Uri.parse('$BASE_URL${PATH.Accident['GET_ACCIDENT']}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        final List<dynamic> accidentList = responseData['data'];
        accidentList.forEach((accident) {
          if (accident['position'] != null) {
            AccidentData accidentData = AccidentData(
              date: parseDate(accident['date']),
              deaths: accident['deaths'],
              injuries: accident['injuries'],
              level: accident['level'],
              cause: accident['cause'],
              position: LatLng(
                double.parse(accident['position'].split(' ')[1]),
                double.parse(accident['position'].split(' ')[0]),
              ),
              link: accident['link'],
              sophuongtienlienquan: accident['sophuongtienlienquan'],
            );
            accidents.add(accidentData);
          } else {
            print('Warning: Accident position is null');
          }
        });
        print('Success');
      } else {
        print('Request failed with message: ${responseData['message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return accidents;
}

Future<void> addAccident(Map<String, dynamic> accidentData) async {
  try {
    final response = await http.post(
      Uri.parse('$BASE_URL${PATH.Accident['ADD_ACCIDENT']}'),
      body: accidentData,
    );
    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> signUp(Map<String, dynamic> userData) async {
  try {
    final response = await http.post(
      Uri.parse('$BASE_URL${PATH.User['SIGN_UP']}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(userData),
    );
    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<Map<String, dynamic>> login(String userName, String password) async {
  try {
    final loginUrl =
        '$BASE_URL${PATH.User['LOGIN']}?userName=$userName&password=$password';
    final response = await http.get(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return {
        'success': true,
        'data': responseData['data'],
      };
    } else {
      return {
        'success': false,
        'message': 'Request failed with status: ${response.statusCode}',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Error: $e',
    };
  }
}

Future<Map<String, dynamic>> updateUser(
    String id, Map<String, dynamic> userData) async {
  final String updateUrl = '$BASE_URL${PATH.User['EDIT']}';

  print('Updating user with ID: $id');
  print('Update URL: $updateUrl');
  print('User Data: $userData');

  try {
    final response = await http.put(
      Uri.parse(updateUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'id': id,
        ...userData,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Update response data: $responseData');
      return {
        'success': true,
        'data': responseData,
      };
    } else {
      print('Request failed with status: ${response.statusCode}');
      return {
        'success': false,
        'message': 'Request failed with status: ${response.statusCode}',
      };
    }
  } catch (e) {
    print('Error: $e');
    return {
      'success': false,
      'message': 'Error: $e',
    };
  }
}
