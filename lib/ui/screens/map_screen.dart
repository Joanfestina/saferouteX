import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io'; // Add this import
import '../../services/location_service.dart';
import '../../services/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationService _locationService;
  LatLng _currentPosition = LatLng(37.7749, -122.4194); // Initial position (San Francisco)
  LatLng? _destinationPosition;
  bool _locationFetched = false;
  bool _isLoading = false; // Loading indicator state

  final TextEditingController _destinationController = TextEditingController();

  List<LatLng> _routePoints = []; // List to store route points

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _getCurrentLocation();
  }

  // Function to fetch the user's current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationFetched = true;
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  // Function to find the destination's coordinates and draw a route
  Future<void> _setDestination(String destination) async {
    if (destination.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid destination.")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      List<Location> locations = await locationFromAddress(destination);
      if (locations.isNotEmpty) {
        final LatLng destinationLatLng = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );

        setState(() {
          _destinationPosition = destinationLatLng;
          _routePoints = [
            _currentPosition, // Starting point
            _destinationPosition!, // Destination point
          ];
        });

        // Debug print to confirm destination coordinates
        print("Destination coordinates: $_destinationPosition");

        // Update map camera position and zoom to fit both points
        final bounds = LatLngBounds.fromPoints([_currentPosition, _destinationPosition!]);
        final mapController = MapController(); // Ensure you have a MapController instance
        mapController.fitBounds(
          bounds,
          options: const FitBoundsOptions(padding: EdgeInsets.all(50)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Destination not found. Please check the address format.")),
        );
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No internet connection. Please try again later.")),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Function to draw a route between current location and destination
  void _drawRoute() {
    if (_destinationPosition != null) {
      setState(() {
        _routePoints = [
          _currentPosition, // Starting point
          _destinationPosition!, // Destination point
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Map'),
      ),
      body: Column(
        children: [
          // Current Location Bar with clickable icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Current Location',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                ),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              controller: TextEditingController(
                text: "${_currentPosition.latitude}, ${_currentPosition.longitude}",
              ),
            ),
          ),

          // Destination Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Enter Destination',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _setDestination(_destinationController.text),
                ),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),

          // Map Section
          Expanded(
            child: _locationFetched
                ? FlutterMap(
                    options: MapOptions(
                      center: _currentPosition,
                      zoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),

                      // Current Location Marker
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _currentPosition,
                            builder: (ctx) => const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),

                          // Destination Marker
                          if (_destinationPosition != null)
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _destinationPosition!,
                              builder: (ctx) => const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                        ],
                      ),

                      // Route Display
                      if (_routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
