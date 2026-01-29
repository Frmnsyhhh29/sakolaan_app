class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/login';
  static const String registerEndpoint = '$baseUrl/register';
  static const String logoutEndpoint = '$baseUrl/logout';

  // Siswa endpoints
  static const String siswaEndpoint = '$baseUrl/siswa';
  
  // Mapel endpoints
  static const String mapelEndpoint = '$baseUrl/mapel';
  
  // Guru endpoints - TAMBAHKAN INI
  static const String guruEndpoint = '$baseUrl/guru';
  
  // Kelas endpoints (jika ada)
  static const String kelasEndpoint = '$baseUrl/kelas';
  
  // Nilai endpoints (jika ada)
  static const String nilaiEndpoint = '$baseUrl/nilai';
}