import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../services/route_service.dart';

class RouteSuggestionScreen extends StatelessWidget {
  const RouteSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suggest Safer Route')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['name']),
                subtitle: Text(user['email']),
                trailing: IconButton(
                  icon: const Icon(Icons.directions),
                  onPressed: () {
                    _suggestRoute(context, user.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _suggestRoute(BuildContext context, String userId) {
    final TextEditingController startController = TextEditingController();
    final TextEditingController destinationController = TextEditingController();
    final RouteService _routeService = RouteService();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Suggest Route'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startController,
                decoration: const InputDecoration(labelText: 'Start Location'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final startCoords = await _routeService.getCoordinatesFromAddress(
                    startController.text.trim());
                final endCoords = await _routeService.getCoordinatesFromAddress(
                    destinationController.text.trim());

                if (startCoords == null || endCoords == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Invalid locations. Please try again.")),
                  );
                  return;
                }

                try {
                  final routePoints =
                      await _routeService.getRoute(startCoords, endCoords);

                  await FirebaseFirestore.instance
                      .collection('route_suggestions')
                      .add({
                    'user_id': userId,
                    'start_location': {
                      'lat': startCoords.latitude,
                      'lng': startCoords.longitude,
                    },
                    'destination': {
                      'lat': endCoords.latitude,
                      'lng': endCoords.longitude,
                    },
                    'route_points': routePoints
                        .map((point) => {
                              'lat': point.latitude,
                              'lng': point.longitude
                            })
                        .toList(),
                    'suggested_at': Timestamp.now(),
                  });

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Route successfully suggested!")),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error suggesting route: $e")),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
