import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String baseUrl = 'http://192.168.2.27:8000/api';
  // Auth endpoints
  static final String loginEndpoint = '$baseUrl/login';
  static final String registerEndpoint = '$baseUrl/register';
  static final String logoutEndpoint = '$baseUrl/logout';

  // Siswa endpoints
  static const String siswaEndpoint = '$baseUrl/siswa';
  static const String guruEndpoint = '$baseUrl/guru';
  static const String mapelEndpoint = '$baseUrl/mapel';
}