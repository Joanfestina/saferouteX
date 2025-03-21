// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SafeRouteX', style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.account_circle, size: 28),
//             onPressed: () {}, // Profile navigation
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Welcome Back!',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Stay safe with AI-powered route suggestions and instant SOS assistance.',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 1.1,
//                 ),
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   final icons = [
//                     Icons.map,
//                     Icons.sos,
//                     Icons.report,
//                     Icons.library_books,
//                   ];
//                   final titles = [
//                     'Safety Map',
//                     'SOS Alert',
//                     'Report Incident',
//                     'Resources'
//                   ];

//                   return _buildFeatureCard(icons[index], titles[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureCard(IconData icon, String title) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 6,
//       shadowColor: Colors.blueAccent.withOpacity(0.3),
//       child: InkWell(
//         onTap: () {}, // Navigation for each feature
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 48, color: Colors.blueAccent),
//             const SizedBox(height: 12),
//             Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeRouteX', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            onPressed: () {}, // Profile navigation
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Stay safe with AI-powered route suggestions and instant SOS assistance.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  '', // Placeholder for future widgets
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
