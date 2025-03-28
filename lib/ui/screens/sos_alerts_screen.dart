// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SosAlertsScreen extends StatelessWidget {
//   const SosAlertsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Active SOS Alerts')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('sos_alerts').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No active SOS alerts.'));
//           }

//           final sosAlerts = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: sosAlerts.length,
//             itemBuilder: (context, index) {
//               final alert = sosAlerts[index];
//               final userName = alert['user_name'] ?? 'Unknown User'; // Handle missing field

//               return ListTile(
//                 title: Text(userName),
//                 subtitle: Text('Location: ${alert['location'] ?? 'Unknown'}'),
//                 trailing: Text(alert['timestamp']?.toDate().toString() ?? 'No Timestamp'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SosAlertsScreen extends StatelessWidget {
  const SosAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active SOS Alerts')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sos_alerts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No active SOS alerts.'));
          }

          final sosAlerts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sosAlerts.length,
            itemBuilder: (context, index) {
              final alert = sosAlerts[index];
              final userName = alert['user_name'] ?? 'Unknown User';
              final location = alert['location'] ?? 'Unknown Location';
              final timestamp = alert['timestamp'] != null
                  ? (alert['timestamp'] as Timestamp).toDate().toString()
                  : 'No Timestamp';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(userName),
                  subtitle: Text('Location: $location'),
                  trailing: Text(
                    timestamp,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}