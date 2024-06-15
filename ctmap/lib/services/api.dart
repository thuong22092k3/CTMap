import 'dart:convert';
import 'package:ctmap/services/path.dart';
import 'package:http/http.dart' as http;
import 'package:ctmap/data/type.dart';
import 'package:latlong2/latlong.dart';

const String BASE_URL = 'https://ctmap-be.onrender.com';

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
        print('Total accidents from API: ${accidentList.length}');

        for (var accident in accidentList) {
          try {
            print('Processing accident: $accident');
            String positionStr = accident['position']?.toString().trim() ?? '';
            List<String> positions = positionStr.split(' ');

            if (positions.length == 2) {
              try {
                double lng = double.parse(positions[0]);
                double lat = double.parse(positions[1]);
                AccidentData accidentData = AccidentData(
                  date: parseDate(
                      accident['date'] ?? '01/01/1970'), // Default date
                  deaths: int.parse(accident['deaths'].toString() ?? '0'),
                  injuries: int.parse(accident['injuries'].toString() ?? '0'),
                  level: int.parse(accident['level'].toString() ?? '0'),
                  cause: int.parse(accident['cause'].toString() ?? '0'),
                  position: LatLng(lat, lng),
                  link: accident['link'] ?? '',
                  sophuongtienlienquan: int.parse(
                      accident['sophuongtienlienquan'].toString() ?? '0'),
                );
                accidents.add(accidentData);
              } catch (e) {
                print(
                    'Error parsing position for accident: $accident. Error: $e');
              }
            } else {
              print('Warning: Invalid position format for accident: $accident');
            }
          } catch (e) {
            print('Error processing accident: $accident. Error: $e');
          }
        }
        print('Accidents with valid position: ${accidents.length}');
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
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(accidentData),
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

Future<void> deleteAccident(LatLng position) async {
  try {
    final response = await http.delete(
      Uri.parse('$BASE_URL${PATH.Accident['DELETE_ACCIDENT']}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Accident deleted successfully.');
      print('Response body: ${response.body}');
    } else {
      print('Failed to delete accident. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(
          'Failed to delete accident. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting accident: $e');
    throw Exception('Error deleting accident: $e');
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

Future<Map<String, dynamic>> login(String login, String password) async {
  try {
    final loginUrl =
        '$BASE_URL${PATH.User['LOGIN']}?login=$login&password=$password';
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

Future<bool> sendVerificationCodeToEmail(String email) async {
  print('Sending verification code to: $email');
  try {
    final response = await http.post(
      Uri.parse('$BASE_URL${PATH.User['SEND']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      print('Mã xác nhận đã được gửi đến email của bạn');
      return true;
    } else {
      print('Gửi mã xác nhận thất bại: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error sending verification code: $e');
    return false;
  }
}

Future<bool> verifyCode(String email, String code) async {
  print('Verifying code for email: $email with code: $code');

  try {
    final response = await http.post(
      Uri.parse('$BASE_URL${PATH.User['VERIFY']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'code': code}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('message')) {
        String message = responseData['message'];
        if (message == 'Mã xác nhận hợp lệ') {
          print('OTP verified successfully.');
          return true;
        } else {
          print('OTP verification failed: $message');
          return false;
        }
      } else {
        print('OTP verification response does not contain message key.');
        return false;
      }
    } else {
      print(
          'OTP verification request failed with status: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error during OTP verification: $e');
    return false;
  }
}

Future<Map<String, dynamic>> changePassword(
    String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$BASE_URL${PATH.User['CHANGE_PASSWORD']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Đổi mật khẩu thành công'};
    } else {
      var responseData = json.decode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Đổi mật khẩu thất bại'
      };
    }
  } catch (e) {
    print('Lỗi khi đổi mật khẩu: $e');
    return {
      'success': false,
      'message': 'Đổi mật khẩu thất bại do lỗi kết nối'
    };
  }
}
