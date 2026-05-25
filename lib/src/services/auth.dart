import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebase(User? user) {
    return user != null
        ? AppUser(uid: user.uid, name: user.displayName, email: user.email)
        : null;
  }

  /// Stream that emits whenever auth state changes (login / logout).
  Stream<AppUser?> get authStateChanges =>
      _auth.authStateChanges().map(_userFromFirebase);

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print('signIn error: $e');
      return null;
    }
  }

  Future<AppUser?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print('signUp error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  String? get currentUid => _auth.currentUser?.uid;
}
