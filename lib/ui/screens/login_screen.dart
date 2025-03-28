import 'package:flutter/material.dart';
import './home_scren.dart'; // Import HomeScreen
import './sign_in_screen.dart'; // Import SignInScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'User'; // Default role

  // Static Credentials
  final Map<String, String> staticCredentials = {
    'user@saferoutex.com': 'user12345',
    'authority@saferoutex.com': 'authority12345',
  };

  // Login Logic for Static Credentials
  void _loginWithEmailPassword() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Email and password cannot be empty.");
      return;
    }

    if (staticCredentials[email] == password) {
      if ((_selectedRole == 'User' && email == 'user@saferoutex.com') ||
          (_selectedRole == 'Authority' && email == 'authority@saferoutex.com')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userType: _selectedRole.toLowerCase()), // Pass userType to HomeScreen
          ),
        );
      } else {
        _showError("Selected role does not match your email.");
      }
    } else {
      _showError("Invalid email or password.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'SafeRouteX',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 40),
              
              // Email Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              
              // Password Input
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Dropdown with better styling
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                    items: ['User', 'Authority'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role, style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: _loginWithEmailPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 16),

              // Sign Up Option
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()), // Navigate to SignInScreen
                  );
                },
                child: const Text(
                  "New User? Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}