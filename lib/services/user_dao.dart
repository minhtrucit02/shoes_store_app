import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserDao extends ChangeNotifier {

  String? _displayName;
  String? _photoURL;

  String? get displayName => _displayName;
  String? get photoURL => _photoURL;

  UserDao() {
    final user = auth.currentUser;
    if (user != null) {
      _displayName = user.displayName;
      _photoURL = user.photoURL;
    }
  }

  String errorMsg = "An error has occurred";
  final auth = FirebaseAuth.instance;


  // Check login status
  bool isLoggedIn() => auth.currentUser != null;
  String? userId() => auth.currentUser?.uid;
  String? email() => auth.currentUser?.email;

  // Sign Up
  Future<String?> signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (email.isEmpty) return "Email is blank.";
      if (password.isEmpty) return "Password is empty.";
      if (e.code == 'weak-password') return "The password provided is too weak.";
      if (e.code == 'email-already-in-use') return "The account already exists for that email.";
      return e.message ?? "Signup error occurred.";
    } catch (e) {
      log(e.toString());
      return "An unexpected error occurred.";
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    if (email.isEmpty) return "Email is blank.";
    if (password.isEmpty) return "Password is blank.";

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          return "Invalid email address.";
        case "user-not-found":
          return "No user found for that email.";
        case "wrong-password":
          return "Wrong password provided.";
        default:
          return e.message ?? "An unknown error occurred.";
      }
    } catch (e) {
      log(e.toString());
      return "An unexpected error occurred.";
    }
  }

  // Logout
  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return "Google sign-in cancelled.";

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _displayName = auth.currentUser?.displayName;
      _photoURL = auth.currentUser?.photoURL;

      notifyListeners() ;
      return null;
    } catch (e) {
      log(e.toString());
      return "Google sign-in failed.";
    }
  }
}
