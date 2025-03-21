import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Resources')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emergency Contacts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('- Police: 100'),
            Text('- Ambulance: 102'),
            Text('- Fire Brigade: 101'),
            SizedBox(height: 20),
            Text('Self-Defense Tips',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('- Stay aware of your surroundings.'),
            Text('- Trust your instincts.'),
            Text('- Carry a personal safety device.'),
          ],
        ),
      ),
    );
  }
}
