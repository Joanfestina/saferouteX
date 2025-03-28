// import 'package:flutter/material.dart';
// import 'package:women_safety_app/ui/screens/auth_report_screen.dart';
// import '../report_screen.dart';
// import '../sos_alerts_screen.dart'; // Import SosAlertsScreen
// import '../route_suggestion_screen.dart'; // Import RouteSuggestionScreen

// class AuthorityDashboard extends StatelessWidget {
//   const AuthorityDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Authority Dashboard'),
//         backgroundColor: Colors.red,
//       ),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           _buildCard(
//             context,
//             'Manage Reports',
//             Icons.assignment,
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AuthReportScreen()),
//             ),
//           ),
//           _buildCard(
//             context,
//             'Monitor SOS Alerts',
//             Icons.sos,
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SosAlertsScreen()),
//             ),
//           ),
//           _buildCard(
//             context,
//             'Suggest Safer Routes',
//             Icons.directions,
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const RouteSuggestionScreen()),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(
//       BuildContext context, String title, IconData icon, VoidCallback onTap) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50, color: Colors.red),
//             const SizedBox(height: 10),
//             Text(title, style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:women_safety_app/ui/screens/sos_alerts_screen.dart';
import '../auth_report_screen.dart'; // Import AuthReportScreen

class AuthorityDashboard extends StatelessWidget {
  const AuthorityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authority Dashboard'),
        backgroundColor: Colors.red,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(
            context,
            'Manage Reports',
            Icons.assignment,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthReportScreen()),
            ),
          ),
          _buildCard(
            context,
            'Monitor SOS Alerts',
            Icons.sos,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const  SosAlertsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.redAccent),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}