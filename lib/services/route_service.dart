// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:latlong2/latlong.dart';

// class RouteService {
//   final String apiKey = "1qQCqGaIle4U6ZozeJxMUL19zptYNcBNHvahg1L2yIo"; // Replace with your key

//   Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
//     final url =
//         "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}";

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       List<dynamic> coordinates =
//           decoded["routes"][0]["geometry"]["coordinates"];

//       return coordinates
//           .map((coord) => LatLng(coord[1], coord[0])) // Convert to LatLng
//           .toList();
//     } else {
//       throw Exception("Failed to load route");
//     }
//   }
// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class RouteService {
  final String apiKey = "1qQCqGaIle4U6ZozeJxMUL19zptYNcBNHvahg1L2yIo"; // Replace with your key

  // Geocoding to convert text to LatLng
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final url = "https://nominatim.openstreetmap.org/search?format=json&q=$address";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded.isNotEmpty) {
        final double lat = double.parse(decoded[0]['lat']);
        final double lon = double.parse(decoded[0]['lon']);
        return LatLng(lat, lon);
      } else {
        return null;
      }
    } else {
      throw Exception("Failed to fetch coordinates for destination");
    }
  }

  // Route fetching logic
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<dynamic> coordinates =
          decoded["routes"][0]["geometry"]["coordinates"];

      return coordinates
          .map((coord) => LatLng(coord[1], coord[0])) // Convert to LatLng
          .toList();
    } else {
      throw Exception("Failed to load route");
    }
  }
}
