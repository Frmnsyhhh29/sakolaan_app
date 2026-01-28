class ApiConfig {
  static const String baseUrl = 'http://192.168.2.166:8000/api';
  
  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/login';
  static const String registerEndpoint = '$baseUrl/register';
  static const String logoutEndpoint = '$baseUrl/logout';
  
  // Siswa endpoints
  static const String siswaEndpoint = '$baseUrl/siswa';
  static const String guruEndpoint = '$baseUrl/guru';
  static const String mapelEndpoint = '$baseUrl/mapel';
}