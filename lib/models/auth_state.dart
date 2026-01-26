// lib/models/auth_state.dart
import 'user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });

  // Copy state dengan perubahan
  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // State awal (belum login)
  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      user: null,
      errorMessage: null,
    );
  }

  // State loading
  factory AuthState.loading() {
    return AuthState(
      isLoading: true,
      isAuthenticated: false,
      user: null,
      errorMessage: null,
    );
  }

  // State authenticated (sudah login)
  factory AuthState.authenticated(User user) {
    return AuthState(
      isLoading: false,
      isAuthenticated: true,
      user: user,
      errorMessage: null,
    );
  }

  // State error
  factory AuthState.error(String message) {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      user: null,
      errorMessage: message,
    );
  }
}