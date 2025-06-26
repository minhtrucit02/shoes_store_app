import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_state.dart';
import '../models/userDB.dart';
import '../providers/user_provider.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final _auth = FirebaseAuth.instance;

  AuthNotifier(this.ref) : super(const AuthState());

  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Email or password cannot be empty.";
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = state.copyWith(currentUser: _auth.currentUser);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-credential":
          return "Email or password incorrect";
        case "invalid-email":
          return "Invalid email address.";
        case "user-not-found":
          return "No user found with that email.";
        case "wrong-password":
          return "Incorrect password.";
        default:
          return e.message ?? "Login failed.";
      }
    } catch (e) {
      return "An unexpected error occurred.";
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = state.copyWith(errorMessage: "Google sign-in cancelled.");
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        state = state.copyWith(currentUser: user);
        final userService = ref.read(userServiceProvider);
        final existing = await userService.getEmailUser(user.uid);
        if (existing == null) {
          final userDB = UserDB(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            password: '',
            phone: '',
            address: '',
            createdAt: DateTime.now().toIso8601String(),
          );
          await userService.addUser(userDB);
        }
      }
    } catch (e) {
      state = state.copyWith(errorMessage: "Google sign-in failed.");
      log(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<String?> signup(String email, String password, String name) async {
    if (email.isEmpty) return "Email is required.";
    if (password.isEmpty) return "Password is required.";
    if (name.isEmpty) return "Name is required.";

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final userDB = UserDB(
          id: user.uid,
          name: name,
          email: email,
          password: password,
          phone: '',
          address: '',
          createdAt: DateTime.now().toIso8601String(),
        );
        await ref.read(userServiceProvider).addUser(userDB);
        state = state.copyWith(currentUser: user);
        return null;
      } else {
        return "Signup failed. User is null.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        return "An account already exists for that email.";
      } else {
        return e.message ?? "Signup failed.";
      }
    } catch (e) {
      return "An unexpected error occurred.";
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    state = const AuthState();
  }


  void initialize() {
    state = state.copyWith(currentUser: _auth.currentUser);
  }


  User? get currentUser => _auth.currentUser;
}
