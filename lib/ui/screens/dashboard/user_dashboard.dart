import 'package:flutter/material.dart';
import '../map_screen.dart';
import '../sos_screen.dart';
import '../report_screen.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildCard(
                  context,
                  'Safety Map',
                  Icons.map,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  ),
                ),
                _buildCard(
                  context,
                  'SOS',
                  Icons.warning_amber_rounded,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SosScreen()),
                  ),
                ),
                _buildCard(
                  context,
                  'Report Incident',
                  Icons.report,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.purple),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
