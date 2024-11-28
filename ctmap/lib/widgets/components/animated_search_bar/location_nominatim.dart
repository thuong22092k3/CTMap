import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Location>> searchLocation(String query) async {
  // giới hạn 3000 request 1 ngày
  final url =
      'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&filter=countrycode:vn&lang=vi&apiKey=0f7058e62bce4594b2f4acdca2b518b5';
  
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['features'] != null && data['features'] is List) {
      final List features = data['features'];

      return features.map((feature) {
        return Location.fromJson(feature);
      }).toList();
    } else {
      throw Exception('No location features found');
    }
  } else {
    throw Exception('Failed to load locations with status code: ${response.statusCode}');
  }
}

class Location {
  final double lat;
  final double lon;
  final String displayName;

  Location({
    required this.lat,
    required this.lon,
    required this.displayName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry']['coordinates'];
    return Location(
      lat: geometry[1],  
      lon: geometry[0],
      displayName: json['properties']['formatted'],
    );
  }
}

