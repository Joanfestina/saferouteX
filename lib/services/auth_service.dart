class AuthService {
  Future<String?> signUpWithEmailPassword(String name, String email, String password) async {
    try {
      // Save user credentials to the database or authentication service
      // Example for Firebase:
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // Save additional user details (e.g., name) to Firestore or Realtime Database
      return "User registered successfully!";
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  Future<String?> signInWithEmailPassword(String email, String password) async {
    try {
      // Validate user credentials
      // Example for Firebase:
      // await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return "Login successful!";
    } catch (e) {
      return "Invalid email or password"; // Return user-friendly error
    }
  }
}