import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? currentUser;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.currentUser
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? currentUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
