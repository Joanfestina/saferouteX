// import 'package:flutter/material.dart';
// import '../../services/report_service.dart';

// class AuthReportScreen extends StatefulWidget {
//   const AuthReportScreen({super.key});

//   @override
//   State<AuthReportScreen> createState() => _AuthReportScreenState();
// }

// class _AuthReportScreenState extends State<AuthReportScreen> {
//   final ReportService _reportService = ReportService();
//   late Future<List<Map<String, dynamic>>> _reportData;

//   @override
//   void initState() {
//     super.initState();
//     _reportData = _reportService.fetchReports();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Reports'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _reportData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error fetching reports.'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No reports available.'));
//           }

//           final reports = snapshot.data!;

//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: reports.length,
//             itemBuilder: (context, index) {
//               final report = reports[index];
//               return Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.only(bottom: 16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(Icons.report, color: Colors.redAccent),
//                           const SizedBox(width: 8.0),
//                           Text(
//                             report['title'] ?? 'No Title',
//                             style: const TextStyle(
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text(
//                         report['description'] ?? 'No Description',
//                         style: const TextStyle(fontSize: 16.0),
//                       ),
//                       const SizedBox(height: 12.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Date: ${report['date'] ?? 'N/A'}',
//                             style: const TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               // Add action for managing the report
//                             },
//                             icon: const Icon(Icons.manage_accounts),
//                             label: const Text('Manage'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.redAccent,
//                               foregroundColor: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
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

class AuthReportScreen extends StatefulWidget {
  const AuthReportScreen({super.key});

  @override
  State<AuthReportScreen> createState() => _AuthReportScreenState();
}

class _AuthReportScreenState extends State<AuthReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Reports'),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('incidents')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reports available.'));
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.report, color: Colors.redAccent),
                          const SizedBox(width: 8.0),
                          Text(
                            report['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        report['description'] ?? 'No Description',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 12.0),
                      if (report['photoUrl'] != null && report['photoUrl'] != '')
                        Image.network(
                          report['photoUrl'],
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date: ${report['timestamp'] != null ? (report['timestamp'] as Timestamp).toDate().toString() : 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add action for managing the report
                            },
                            icon: const Icon(Icons.manage_accounts),
                            label: const Text('Manage'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
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