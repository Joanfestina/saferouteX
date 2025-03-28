import 'package:flutter/material.dart';
import './ui/screens/home_scren.dart'; // Corrected import
import './ui/screens/sos_screen.dart';
import './ui/screens/report_screen.dart';
import './ui/screens/resources.dart';
import './ui/screens/login_screen.dart'; // Added Login Screen
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Import Firebase options
import './ui/screens/map_screen.dart'; // Ensure this is for Flutter Map, not Google Maps

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  // Simulated userType variable
  String userType = 'user'; // Change this to 'authority' to simulate authority user

  runApp(SafeRouteXApp(userType: userType));
}

class SafeRouteXApp extends StatelessWidget {
  final String userType; // Add userType parameter

  const SafeRouteXApp({super.key, required this.userType}); // Make userType required

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRouteX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirebaseAuth.instance.currentUser == null 
          ? const LoginScreen() 
          : HomeScreen(userType: userType), // Pass userType to HomeScreen
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const HomeScreen(userType: 'user'), // Pass userType to HomeScreen
    const ReportScreen(),
    const SosScreen(),
    ResourcesScreen(),
    const MapScreen(), // Ensure this uses Flutter Map
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("MainScreen is loaded!"); // Debugging check

    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeRouteX'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'map'),
          BottomNavigationBarItem(icon: Icon(Icons.sos), label: 'SOS'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Resources'),
        ],
      ),
    );
  }
}
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => const AuthReportScreen()),
// );

// If needed, move this code into a valid method or function, such as:
// void navigateToAuthReportScreen(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => const AuthReportScreen()),
//   );
// }

