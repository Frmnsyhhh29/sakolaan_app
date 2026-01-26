// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/auth_response_model.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();

  // REGISTER - Daftar user baru
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print('Register Response: ${response.body}'); // Debug

      final authResponse = AuthResponse.fromJson(json.decode(response.body));

      // Jika berhasil, simpan token dan data user
      if (authResponse.status && authResponse.token != null) {
        await _storageService.saveToken(authResponse.token!);
        
        if (authResponse.user != null) {
          await _storageService.saveUserData(
            userId: authResponse.user!.id,
            name: authResponse.user!.name,
            email: authResponse.user!.email,
          );
        }
      }

      return authResponse;
    } catch (e) {
      print('Register Error: $e'); // Debug
      return AuthResponse(
        status: false,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }

  // LOGIN - Masuk dengan email dan password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Login Response: ${response.body}'); // Debug

      final authResponse = AuthResponse.fromJson(json.decode(response.body));

      // Jika berhasil login, simpan token dan data user
      if (authResponse.status && authResponse.token != null) {
        await _storageService.saveToken(authResponse.token!);
        
        if (authResponse.user != null) {
          await _storageService.saveUserData(
            userId: authResponse.user!.id,
            name: authResponse.user!.name,
            email: authResponse.user!.email,
          );
        }
      }

      return authResponse;
    } catch (e) {
      print('Login Error: $e'); // Debug
      return AuthResponse(
        status: false,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }

  // LOGOUT - Keluar dan hapus data local
  Future<bool> logout() async {
    try {
      final token = await _storageService.getToken();

      if (token != null) {
        // Panggil API logout (opsional, tergantung backend)
        await http.post(
          Uri.parse(ApiConfig.logoutEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      // Hapus semua data local
      await _storageService.clearAll();
      return true;
    } catch (e) {
      print('Logout Error: $e');
      // Tetap hapus data local meskipun API gagal
      await _storageService.clearAll();
      return true;
    }
  }

  // CEK STATUS LOGIN
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  // GET USER DATA dari local storage
  Future<Map<String, dynamic>?> getUserData() async {
    final userId = await _storageService.getUserId();
    final userName = await _storageService.getUserName();
    final userEmail = await _storageService.getUserEmail();

    if (userId != null && userName != null && userEmail != null) {
      return {
        'id': userId,
        'name': userName,
        'email': userEmail,
      };
    }
    return null;
  }
}