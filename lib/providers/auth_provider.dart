// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

// Provider untuk AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provider untuk StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Provider utama untuk Auth State
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// Notifier untuk mengelola Auth State
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState.initial()) {
    // Cek login status saat pertama kali
    checkLoginStatus();
  }

  // Fungsi untuk cek apakah user sudah login
  Future<void> checkLoginStatus() async {
    try {
      final storageService = ref.read(storageServiceProvider);
      final isLoggedIn = await storageService.isLoggedIn();

      if (isLoggedIn) {
        // Ambil data user dari storage
        final userData = await storageService.getUserData();
        
        // Cek apakah userData tidak null dan punya semua field yang dibutuhkan
        if (userData != null && 
            userData['id'] != null && 
            userData['name'] != null && 
            userData['email'] != null) {
          
          final user = User(
            id: userData['id'] as int,
            name: userData['name'] as String,
            email: userData['email'] as String,
          );
          
          state = AuthState.authenticated(user);
        } else {
          // Kalau data tidak lengkap, set ke initial
          state = AuthState.initial();
        }
      } else {
        state = AuthState.initial();
      }
    } catch (e) {
      print('Error checkLoginStatus: $e');
      state = AuthState.initial();
    }
  }

  // REGISTER - Daftar user baru
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final authService = ref.read(authServiceProvider);
      
      final response = await authService.register(
        name: name,
        email: email,
        password: password,
      );

      if (response.status && response.user != null) {
        state = AuthState.authenticated(response.user!);
        return true;
      } else {
        state = AuthState.error(response.message);
        return false;
      }
    } catch (e) {
      print('Error register: $e');
      state = AuthState.error('Terjadi kesalahan: $e');
      return false;
    }
  }

  // LOGIN - Masuk dengan akun yang sudah ada
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final authService = ref.read(authServiceProvider);
      
      final response = await authService.login(
        email: email,
        password: password,
      );

      if (response.status && response.user != null) {
        state = AuthState.authenticated(response.user!);
        return true;
      } else {
        state = AuthState.error(response.message);
        return false;
      }
    } catch (e) {
      print('Error login: $e');
      state = AuthState.error('Terjadi kesalahan: $e');
      return false;
    }
  }

  // LOGOUT - Keluar dari aplikasi
  Future<void> logout() async {
    state = AuthState.loading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout();
      
      state = AuthState.initial();
    } catch (e) {
      print('Error logout: $e');
      state = AuthState.initial();
    }
  }

  // Clear error message
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}