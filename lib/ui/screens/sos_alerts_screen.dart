import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SosAlertsScreen extends StatelessWidget {
  const SosAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active SOS Alerts')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sos_alerts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return ListTile(
                title: Text(alert['user_name']),
                subtitle: Text('Location: ${alert['location']}\nTime: ${alert['time']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    FirebaseFirestore.instance.collection('sos_alerts').doc(alert.id).delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
