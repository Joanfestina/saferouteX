import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'constants.dart';

class RouteService {
  final String apiKey = ORS_API_KEY;

  // Convert address to coordinates
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final url = "https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(address)}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded.isNotEmpty) {
          final double lat = double.parse(decoded[0]['lat']);
          final double lon = double.parse(decoded[0]['lon']);
          return LatLng(lat, lon);
        } else {
          return null; // Address not found
        }
      } else {
        throw Exception("Failed to fetch coordinates for destination. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching coordinates: $e");
    }
  }

  // Generate route points
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    try {
      final url =
          "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}";

      print("Requesting route from: $start to $end"); // Debug log
      print("Request URL: $url"); // Debug log

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // Ensure the response contains the expected structure
        if (decoded["features"] != null &&
            decoded["features"].isNotEmpty &&
            decoded["features"][0]["geometry"] != null &&
            decoded["features"][0]["geometry"]["coordinates"] != null) {
          List<dynamic> coordinates = decoded["features"][0]["geometry"]["coordinates"];
          return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
        } else {
          throw Exception("Invalid route data received from the API.");
        }
      } else {
        print("Error response: ${response.body}"); // Debug log
        throw Exception("Failed to load route. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching route: $e");
    }
  }
}
