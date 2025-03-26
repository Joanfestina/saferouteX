// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController mapController;

//   final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Example location: San Francisco

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Safety Map'),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _initialPosition,
//           zoom: 12.0,
//         ),
//         markers: {
//           Marker(
//             markerId: const MarkerId('initial_position'),
//             position: _initialPosition,
//             infoWindow: const InfoWindow(
//               title: 'Safe Zone',
//               snippet: 'Recommended safe area',
//             ),
//           ),
//         },
//         mapType: MapType.normal, // Ensure mapType is set
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart'; // For LatLng
import '../../services/location_service.dart';
import '../../services/constants.dart';

// LocationService to handle location fetching
class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Location permissions are permanently denied.");
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationService _locationService;
  LatLng _currentPosition = LatLng(37.7749, -122.4194); // Initial position (San Francisco)
  bool _locationFetched = false;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _getCurrentLocation();
  }

  // Function to fetch current location and update the map
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationFetched = true;
      });
    } catch (e) {
      // Handle error, keep the default position
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Map'),
      ),
      body: _locationFetched
          ? FlutterMap(
              options: MapOptions(
                center: _currentPosition,
                zoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentPosition,
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(37.7749, -122.4194), // Example Safe Zone
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}