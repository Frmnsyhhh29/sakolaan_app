// lib/services/mapel_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    }
  }
}