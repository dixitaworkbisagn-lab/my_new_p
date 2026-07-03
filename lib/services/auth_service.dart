// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   User? get currentUser => _auth.currentUser;
//
//   bool get isLoggedIn => _auth.currentUser != null;
//
//   String? get userId => _auth.currentUser?.uid;
//
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
//
//   Future<UserCredential?> signUp({
//     required String email,
//     required String password,
//     required String displayName,
//   }) async {
//     try {
//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Update display name
//       await credential.user?.updateDisplayName(displayName);
//       await credential.user?.reload();
//
//       return credential;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         throw Exception('Password is too weak');
//       } else if (e.code == 'email-already-in-use') {
//         throw Exception('Email already registered');
//       } else if (e.code == 'invalid-email') {
//         throw Exception('Invalid email format');
//       } else {
//         throw Exception('Sign up failed: ${e.message}');
//       }
//     } catch (e) {
//       throw Exception('Sign up error: $e');
//     }
//   }
//
//   // Sign in with email and password
//   Future<UserCredential?> signIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return credential;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         throw Exception('No user found with this email');
//       } else if (e.code == 'wrong-password') {
//         throw Exception('Wrong password');
//       } else if (e.code == 'invalid-email') {
//         throw Exception('Invalid email format');
//       } else if (e.code == 'user-disabled') {
//         throw Exception('User account has been disabled');
//       } else {
//         throw Exception('Sign in failed: ${e.message}');
//       }
//     } catch (e) {
//       throw Exception('Sign in error: $e');
//     }
//   }
//
//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (e) {
//       throw Exception('Sign out error: $e');
//     }
//   }
//
//   // Password reset
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       throw Exception('Password reset error: $e');
//     }
//   }
//
//   // Update profile
//   Future<void> updateProfile({
//     String? displayName,
//     String? photoURL,
//   }) async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         await user.updateDisplayName(displayName ?? user.displayName);
//         await user.updatePhotoURL(photoURL ?? user.photoURL);
//         await user.reload();
//       }
//     } catch (e) {
//       throw Exception('Update profile error: $e');
//     }
//   }
// }
