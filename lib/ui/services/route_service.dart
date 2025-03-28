import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class RouteService {
  final String apiKey = ORS_API_KEY;
  final Distance distance = Distance();

  /// List of unsafe areas (Latitude, Longitude)
  static final List<LatLng> unsafeLocations = [
    LatLng(12.865, 80.221),
    LatLng(12.870, 80.225),
    LatLng(12.880, 80.230),
  ];

  /// Convert an address to coordinates using OpenStreetMap Nominatim API
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse("https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(address)}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded.isNotEmpty) {
          return LatLng(
            double.parse(decoded[0]['lat']),
            double.parse(decoded[0]['lon']),
          );
        }
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching coordinates: $e");
    }
  }

  /// Fetch route from OpenRouteService API
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final coordinates = decoded["features"]?[0]["geometry"]["coordinates"];
        if (coordinates != null) {
          List<LatLng> routePoints = coordinates.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
          return filterUnsafeRoute(routePoints);
        }
      }
      throw Exception("Invalid route data received.");
    } catch (e) {
      throw Exception("Error fetching route: $e");
    }
  }

  /// Generate route with accurate duration using OpenRouteService API
  Future<Map<String, dynamic>> getRouteWithDuration(
      LatLng start, LatLng end) async {
    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded["features"] != null &&
            decoded["features"].isNotEmpty &&
            decoded["features"][0]["properties"] != null) {
          final durationInSeconds =
              decoded["features"][0]["properties"]["segments"][0]["duration"];
          final durationInMinutes = (durationInSeconds / 60).round();

          // Extract route points
          final coordinates =
              decoded["features"][0]["geometry"]["coordinates"];
          final routePoints = coordinates
              .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
              .toList();

          return {
            "polylines": [
              Polyline(
                points: routePoints,
                color: Colors.green,
                strokeWidth: 4.0,
              ),
            ],
            "duration": "$durationInMinutes min",
          };
        } else {
          throw Exception("Invalid route data received from the API.");
        }
      } else {
        throw Exception("Failed to load route. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching route with duration: $e");
    }
  }

  /// Filter unsafe points in a route
  List<LatLng> filterUnsafeRoute(List<LatLng> route) {
    const double unsafeThreshold = 100.0; // 100 meters
    for (LatLng point in route) {
      for (LatLng unsafePoint in unsafeLocations) {
        if (distance.as(LengthUnit.Meter, point, unsafePoint) < unsafeThreshold) {
          print("⚠ Route passes through an unsafe area! Suggesting alternative.");
          return [];
        }
      }
    }
    return route;
  }
}

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(12.865, 80.221),
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
      ],
    );
  }
}

class RouteSuggestionScreen extends StatelessWidget {
  const RouteSuggestionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Suggestion')),
      body: const Center(child: Text('Route Suggestion Screen')),
    );
  }
}