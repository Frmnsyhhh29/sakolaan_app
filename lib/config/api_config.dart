import 'package:flutter/foundation.dart';

class ApiConfig {
  static final String baseUrl = kIsWeb
      ? 'http://localhost:8000/api'
      : 'http://10.0.2.2:8000/api';

  // Auth endpoints
  static final String loginEndpoint = '$baseUrl/login';
  static final String registerEndpoint = '$baseUrl/register';
  static final String logoutEndpoint = '$baseUrl/logout';

  // Siswa endpoints
  static final String siswaEndpoint = '$baseUrl/siswa';

  // Mapel endpoints (biar sekalian rapi)
  static final String mapelEndpoint = '$baseUrl/mapel';
}
