import 'dart:convert';
import 'package:http/http.dart' as http;
Future<List<Location>> searchLocation(String query) async {
  //final url = 'https://nominatim.openstreetmap.org/search?q=$query&countryCodes=VN&format=json&addressdetails=1';
  final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&viewbox=102.14441,23.3925,109.46464,8.17966&bounded=1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((json) => Location.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load location');
  }
}

class Location {
  final double lat;
  final double lon;
  final String displayName;

  Location({required this.lat, required this.lon, required this.displayName});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      displayName: json['display_name'],
    );
  }
}
