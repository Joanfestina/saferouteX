import 'package:flutter/material.dart';
import 'user_login.dart';
import 'authority_login.dart';

class LoginSelectionPage extends StatelessWidget {
  const LoginSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Selection')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Icon(
              Icons.lock,
              size: 100,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserLoginPage()),
              );
            },
            child: const Text('User Login'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthorityLoginPage()),
              );
            },
            child: const Text('Authority Login'),
          ),
        ],
      ),
    );
  }
}