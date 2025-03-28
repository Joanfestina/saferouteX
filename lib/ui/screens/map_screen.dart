import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../services/location_service.dart';
import '../../services/route_service.dart';
import '../../services/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationService _locationService;
  late RouteService _routeService;  
  final MapController _mapController = MapController();

  LatLng _currentPosition = LatLng(37.7749, -122.4194);
  LatLng? _destinationPosition;
  
  List<Polyline> _safeRoutePolylines = [];
  List<Polyline> _unsafeRoutePolylines = [];

  bool _locationFetched = false;
  bool _isLoading = false;

  String _travelDuration = ""; // Travel duration state

  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _routeService = RouteService();
    _getCurrentLocation();
  }

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

  Future<void> _setDestination(String destination) async {
    if (destination.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid destination.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final LatLng? destinationLatLng =
          await _routeService.getCoordinatesFromAddress(destination);

      if (destinationLatLng != null) {
        final routeData = await _routeService.getRouteWithDuration(
          _currentPosition,
          destinationLatLng,
        );

        setState(() {
          _destinationPosition = destinationLatLng;
          _safeRoutePolylines = routeData['polylines']; // Green polylines
          _travelDuration = routeData['duration']; // Travel duration
        });

        // Move the map to the destination
        _mapController.move(_destinationPosition!, 15.0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Destination not found.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Map')),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Current Location',
                    prefixIcon: const Icon(Icons.my_location),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 228, 253, 227),
                  ),
                  controller: TextEditingController(
                    text:
                        "${_currentPosition.latitude}, ${_currentPosition.longitude}",
                  ),
                ),
              ),

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
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              if (_isLoading) const Center(child: CircularProgressIndicator()),

              Expanded(
                child: _locationFetched
                    ? FlutterMap(
                        mapController: _mapController,
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
                                point: _currentPosition,
                                builder: (ctx) => const Icon(
                                  Icons.my_location,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),

                              if (_destinationPosition != null)
                                Marker(
                                  point: _destinationPosition!,
                                  builder: (ctx) => const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                            ],
                          ),

                          // Safe and Unsafe Routes Display
                          PolylineLayer(
                            polylines: [
                              ..._safeRoutePolylines,   // Safe route (Green)
                              ..._unsafeRoutePolylines, // Unsafe route (Red)
                            ],
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
          if (_travelDuration.isNotEmpty)
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // SOS Button
                  ElevatedButton(
                    onPressed: () {
                      // Add SOS functionality here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("SOS button pressed!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red color for SOS button
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "SOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0), // Spacing between SOS and duration
                  // Duration Display
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Duration: $_travelDuration",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
