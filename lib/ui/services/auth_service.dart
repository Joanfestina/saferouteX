import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // Fetch user role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc['role'];
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  // Sign up with email and password
  Future<String?> signUpWithEmailPassword(String name, String email, String password) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Store user details in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'role': 'user', // Default role
        'createdAt': FieldValue.serverTimestamp(),
      });

      return "User registered successfully!";
    } catch (e) {
      print("Sign-up error: $e");
      return "Error: ${e.toString()}";
    }
  }
}
