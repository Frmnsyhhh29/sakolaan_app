// lib/models/auth_response_model.dart
import 'user_model.dart';

class AuthResponse {
  final bool status;
  final String message;
  final String? token;
  final User? user;

  AuthResponse({
    required this.status,
    required this.message,
    this.token,
    this.user,
  });

  // Konversi dari JSON response API
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'user': user?.toJson(),
    };
  }
}