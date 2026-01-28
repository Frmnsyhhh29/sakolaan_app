import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nilai.dart';
import '../config/api_config.dart';

class NilaiService {
  // GET - Semua nilai
  Future<List<Nilai>> getAllNilai({
    int? siswaId,
    int? mapelId,
    String? semester,
    int? tahunAjaran,
  }) async {
    try {
      var url = Uri.parse('${ApiConfig.baseUrl}/nilai');
      
      // Build query parameters
      Map<String, String> queryParams = {};
      if (siswaId != null) queryParams['siswa_id'] = siswaId.toString();
      if (mapelId != null) queryParams['mapel_id'] = mapelId.toString();
      if (semester != null) queryParams['semester'] = semester;
      if (tahunAjaran != null) queryParams['tahun_ajaran'] = tahunAjaran.toString();
      
      if (queryParams.isNotEmpty) {
        url = Uri.parse('${ApiConfig.baseUrl}/nilai').replace(queryParameters: queryParams);
      }

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Nilai.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data nilai');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST - Tambah nilai baru
  Future<Nilai> createNilai(Nilai nilai) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/nilai'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nilai.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Nilai.fromJson(data['data']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Gagal menambahkan nilai');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET - Detail nilai by ID
  Future<Nilai> getNilaiById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/nilai/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Nilai.fromJson(json.decode(response.body));
      } else {
        throw Exception('Nilai tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT - Update nilai
  Future<Nilai> updateNilai(int id, Nilai nilai) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/nilai/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nilai.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Nilai.fromJson(data['data']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengupdate nilai');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE - Hapus nilai
  Future<void> deleteNilai(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/nilai/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Gagal menghapus nilai');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}