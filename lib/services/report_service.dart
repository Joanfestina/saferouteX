import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch reports from Firestore
  Future<List<Map<String, dynamic>>> fetchReports() async {
    try {
      final querySnapshot = await _firestore.collection('reports').get();
      return querySnapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(), // Include all fields from Firestore document
      }).toList();
    } catch (e) {
      print("Error fetching reports: $e");
      return [];
    }
  }
}
