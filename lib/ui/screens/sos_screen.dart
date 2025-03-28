// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';

// class SosScreen extends StatelessWidget {
//   const SosScreen({super.key});

//   Future<void> sendSOS(BuildContext context) async {
//     try {
//       // Check and request location permissions
//       var status = await Permission.location.request();
//       if (status.isGranted) {
//         // Get current location
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );

//         // Send data to Firestore
//         await FirebaseFirestore.instance.collection('sos_alerts').add({
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('SOS Triggered! Location sent successfully.'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Location permission denied. Enable it to send SOS.'),
//             backgroundColor: Colors.orange,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SOS Alert'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Emergency SOS',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                 textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               onPressed: () => sendSOS(context),
//               child: const Text('SEND SOS'),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Voice Command Supported: Say "Help Me!" to trigger SOS.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  Future<void> sendSOS(BuildContext context) async {
    try {
      // Check and request location permissions
      var status = await Permission.location.request();
      if (status.isGranted) {
        // Get current location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Replace 'Your Name' with the actual user's name if available
        const String userName = 'Your Name'; // Replace with dynamic user name if needed
        final String location =
            'Lat: ${position.latitude}, Lng: ${position.longitude}';

        // Send data to Firestore
        await FirebaseFirestore.instance.collection('sos_alerts').add({
          'user_name': userName,
          'location': location,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SOS Triggered! Location sent successfully.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Handle location permission denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied. Enable it to send SOS.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Alert'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Emergency SOS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              ),
              onPressed: () => sendSOS(context),
              child: const Text('SEND SOS'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Voice Command Supported: Say "Help Me!" to trigger SOS.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
