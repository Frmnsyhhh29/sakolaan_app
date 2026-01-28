// lib/services/mapel_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
<<<<<<< Updated upstream
import '../config/api_config.dart';
import '../models/mapel_model.dart';
import 'storage_service.dart';

class MapelService {
  final StorageService _storageService;

  // Constructor yang menerima StorageService
  MapelService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  // Fungsi helper untuk mendapatkan headers dengan token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // GET semua data mapel
  Future<List<Mapel>> getAllMapel() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig.mapelEndpoint),
        headers: headers,
      );

      print('Get Mapel Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Mapel> mapelList = (data['data'] as List)
            .map((item) => Mapel.fromJson(item))
            .toList();
        return mapelList;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getAllMapel: $e');
      throw Exception('Error: $e');
    }
  }

  // GET mapel by ID
  Future<Mapel?> getMapelById(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.mapelEndpoint}/$id'),
        headers: headers,
      );

      print('Get Mapel By ID Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Mapel.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getMapelById: $e');
      throw Exception('Error: $e');
    }
  }

  // POST tambah mapel baru
  Future<bool> createMapel(Mapel mapel) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConfig.mapelEndpoint),
        headers: headers,
        body: json.encode(mapel.toJson()),
      );

      print('Create Mapel Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error createMapel: $e');
      throw Exception('Error: $e');
    }
  }

  // PUT update mapel
  Future<bool> updateMapel(int id, Mapel mapel) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConfig.mapelEndpoint}/$id'),
        headers: headers,
        body: json.encode(mapel.toJson()),
      );

      print('Update Mapel Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error updateMapel: $e');
      throw Exception('Error: $e');
    }
  }

  // DELETE hapus mapel
  Future<bool> deleteMapel(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.mapelEndpoint}/$id'),
        headers: headers,
      );

      print('Delete Mapel Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleteMapel: $e');
      throw Exception('Error: $e');
    }
  }

  // GET siswa yang mengambil mapel tertentu
  Future<Map<String, dynamic>> getSiswaByMapel(int mapelId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.mapelEndpoint}/$mapelId/siswa'),
        headers: headers,
      );

      print('Get Siswa By Mapel Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getSiswaByMapel: $e');
      throw Exception('Error: $e');
    }
  }

  // POST assign siswa ke mapel
  Future<bool> assignSiswa(int mapelId, List<int> siswaIds) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.mapelEndpoint}/$mapelId/siswa'),
        headers: headers,
        body: json.encode({'siswa_ids': siswaIds}),
      );

      print('Assign Siswa Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error assignSiswa: $e');
      throw Exception('Error: $e');
    }
  }

  // DELETE remove siswa dari mapel
  Future<bool> removeSiswa(int mapelId, int siswaId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.mapelEndpoint}/$mapelId/siswa/$siswaId'),
        headers: headers,
      );

      print('Remove Siswa Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error removeSiswa: $e');
      throw Exception('Error: $e');
=======
import '../models/mapel_model.dart';

class MapelService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // GET - Semua mapel
  static Future<List<Mapel>> getMapel() async {
    try {
      print('🔄 Fetching mapel from: $baseUrl/mapel');

      final res = await http.get(
        Uri.parse('$baseUrl/mapel'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📥 Response status: ${res.statusCode}');

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => Mapel.fromJson(e)).toList();
      } else {
        throw Exception('Server error: ${res.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Gagal memuat data mapel: $e');
    }
  }

  // ✅ TAMBAHKAN METHOD INI - Alias untuk getMapel
  static Future<List<Mapel>> getAllMapel() async {
    return await getMapel();
  }

  // POST - Tambah mapel baru
  static Future<bool> tambahMapel({
    required String kodeMapel,
    required String namaMapel,
    required String guruPengampu,
    required int jamPelajaran,
    String? deskripsi,
  }) async {
    try {
      print('🔄 Posting mapel to: $baseUrl/mapel');

      final res = await http.post(
        Uri.parse('$baseUrl/mapel'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'kode_mapel': kodeMapel,
          'nama_mapel': namaMapel,
          'guru_pengampu': guruPengampu,
          'jam_pelajaran': jamPelajaran,
          'deskripsi': deskripsi,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📥 Response status: ${res.statusCode}');

      return res.statusCode == 201;
    } catch (e) {
      print('❌ Exception: $e');
      return false;
    }
  }

  // GET - Detail mapel by ID
  static Future<Mapel> getMapelById(String mapelId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/mapel/$mapelId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Mapel.fromJson(data);
      } else {
        throw Exception('Gagal memuat data mapel');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Gagal memuat data mapel: $e');
    }
  }

  // PUT - Update mapel
  static Future<bool> updateMapel({
    required String mapelId,
    required String kodeMapel,
    required String namaMapel,
    required String guruPengampu,
    required int jamPelajaran,
    String? deskripsi,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/mapel/$mapelId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'kode_mapel': kodeMapel,
          'nama_mapel': namaMapel,
          'guru_pengampu': guruPengampu,
          'jam_pelajaran': jamPelajaran,
          'deskripsi': deskripsi,
        }),
      ).timeout(const Duration(seconds: 10));

      return res.statusCode == 200;
    } catch (e) {
      print('❌ Exception: $e');
      return false;
    }
  }

  // DELETE - Hapus mapel
  static Future<bool> deleteMapel(String mapelId) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/mapel/$mapelId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      return res.statusCode == 200;
    } catch (e) {
      print('❌ Exception: $e');
      return false;
>>>>>>> Stashed changes
    }
  }
}