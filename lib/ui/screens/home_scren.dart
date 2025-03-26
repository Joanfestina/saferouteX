import 'package:flutter/material.dart';
import 'sos_screen.dart';
import 'report_screen.dart';
import 'resources.dart';
import 'dashboard/user_dashboard.dart'; // Import UserDashboard
import 'dashboard/authority_dashboard.dart'; // Import AuthorityDashboard

class HomeScreen extends StatefulWidget {
  final String userType; // Add userType parameter

  const HomeScreen({super.key, required this.userType}); // Make userType required

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = widget.userType == 'user'
        ? [
            const UserDashboard(),
            const ReportScreen(),
            const SosScreen(),
            const ResourcesScreen(),
          ]
        : [
            const AuthorityDashboard(),
            const ReportScreen(),
            const SosScreen(),
            const ResourcesScreen(),
          ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
            BottomNavigationBarItem(icon: Icon(Icons.sos), label: 'SOS'),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Resources'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      child: InkWell(
        onTap: () {}, // Navigation for each feature
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
