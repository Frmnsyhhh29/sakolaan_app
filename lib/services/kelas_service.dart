// lib/services/kelas_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kelas_model.dart';
import '../models/siswa_model.dart'; // ✅ TAMBAH IMPORT INI

class KelasService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // GET - Semua kelas
  static Future<List<Kelas>> getKelas() async {
    try {
      print('🔄 Fetching kelas from: $baseUrl/kelas');

      final res = await http.get(
        Uri.parse('$baseUrl/kelas'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📥 Response status: ${res.statusCode}');

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => Kelas.fromJson(e)).toList();
      } else {
        throw Exception('Server error: ${res.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Gagal memuat data kelas: $e');
    }
  }

  // GET - Detail kelas by ID
  static Future<Kelas> getKelasById(String kelasId) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/kelas/$kelasId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Kelas.fromJson(data);
      } else {
        throw Exception('Gagal memuat data kelas');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Gagal memuat data kelas: $e');
    }
  }

  // ✅ TAMBAH METHOD INI - GET Detail kelas dengan daftar siswa
  static Future<Map<String, dynamic>> getKelasDetail(String kelasId) async {
    try {
      print('🔄 Fetching kelas detail from: $baseUrl/kelas/$kelasId/detail');

      final res = await http.get(
        Uri.parse('$baseUrl/kelas/$kelasId/detail'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📥 Response status: ${res.statusCode}');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        
        // Parse siswa list
        List<Siswa> siswaList = [];
        if (data['siswa'] != null) {
          siswaList = (data['siswa'] as List)
              .map((e) => Siswa.fromJson(e))
              .toList();
        }

        return {
          'namaKelas': data['nama_kelas'] ?? '',
          'waliKelas': data['wali_kelas'] ?? '-',
          'siswa': siswaList,
        };
      } else {
        throw Exception('Gagal memuat detail kelas');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Gagal memuat detail kelas: $e');
    }
  }

  // POST - Tambah kelas baru
  static Future<bool> tambahKelas({
    required String namaKelas,
    required String tingkat,
    required String jurusan,
    String? waliKelas,
    int? kapasitas,
  }) async {
    try {
      print('🔄 Posting kelas to: $baseUrl/kelas');

      final res = await http.post(
        Uri.parse('$baseUrl/kelas'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama_kelas': namaKelas,
          'tingkat': tingkat,
          'jurusan': jurusan,
          'wali_kelas': waliKelas,
          'kapasitas': kapasitas,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📥 Response status: ${res.statusCode}');

      return res.statusCode == 201;
    } catch (e) {
      print('❌ Exception: $e');
      return false;
    }
  }

  // PUT - Update kelas
  static Future<bool> updateKelas({
    required String kelasId,
    required String namaKelas,
    required String tingkat,
    required String jurusan,
    String? waliKelas,
    int? kapasitas,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/kelas/$kelasId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama_kelas': namaKelas,
          'tingkat': tingkat,
          'jurusan': jurusan,
          'wali_kelas': waliKelas,
          'kapasitas': kapasitas,
        }),
      ).timeout(const Duration(seconds: 10));

      return res.statusCode == 200;
    } catch (e) {
      print('❌ Exception: $e');
      return false;
    }
  }

  // DELETE - Hapus kelas
  static Future<bool> deleteKelas(String kelasId) async {
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/kelas/$kelasId'),
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