import 'package:flutter/services.dart' show rootBundle;

class CSVService {
  static Future<List<Map<String, dynamic>>> loadCrimeData() async {
    final data = await rootBundle.loadString('assets/crime_data.csv');
    List<Map<String, dynamic>> crimeList = [];

    List<String> lines = data.split('\n');
    List<String> headers = lines[0].split(',');

    for (int i = 1; i < lines.length; i++) {
      List<String> values = lines[i].split(',');
      if (values.length == headers.length) {
        Map<String, dynamic> crime = {
          'latitude': double.parse(values[0]),
          'longitude': double.parse(values[1]),
          'crime_type': values[2],
          'date': values[3],
          'time': values[4],
        };
        crimeList.add(crime);
      }
    }
    return crimeList;
  }
}