import 'package:flutter/material.dart';
import './ui/screens/home_scren.dart';
// import './ui/screens/map_screen.dart';
import './ui/screens/report_screen.dart';

void main() {
  runApp(const SafeRouteXApp());
}

class SafeRouteXApp extends StatelessWidget {
  const SafeRouteXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRouteX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
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
    const HomeScreen(),
    // const MapScreen(),
    // const SosScreen(),
    const ReportScreen(),
    // const ResourcesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.sos), label: 'SOS'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Resources'),
        ],
      ),
    );
  }
}
