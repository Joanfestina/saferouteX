import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (const bool.fromEnvironment('dart.library.html')) {
      // Web
      return const FirebaseOptions(
        apiKey: "AIzaSyC1pz_TCY4x7N9JPYz2sdhdf_LW3RFyrZY", // Ensure this matches your Firebase project
        authDomain: "saferoutex-07.firebaseapp.com",
        projectId: "saferoutex-07",
        storageBucket: "saferoutex-07.firebasestorage.app",
        messagingSenderId: "197515958191",
        appId: "1:197515958191:web:98a93764ec3976a8adc15a",
      );
    } else if (const bool.fromEnvironment('dart.library.io')) {
      // Android/iOS
      return const FirebaseOptions(
        apiKey: "AIzaSyC1pz_TCY4x7N9JPYz2sdhdf_LW3RFyrZY", // Ensure this matches your Firebase project
        authDomain: "saferoutex-07.firebaseapp.com",
        projectId: "saferoutex-07",
        storageBucket: "saferoutex-07.firebasestorage.app",
        messagingSenderId: "197515958191",
        appId: "1:197515958191:web:98a93764ec3976a8adc15a",
      );
    }
    throw UnsupportedError('DefaultFirebaseOptions are not supported on this platform.');
  }
}
