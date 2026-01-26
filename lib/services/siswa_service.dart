// lib/services/siswa_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/siswa_model.dart';
import 'storage_service.dart';

class SiswaService {
  final StorageService _storageService = StorageService();

  // Fungsi helper untuk mendapatkan headers dengan token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',  // ← Kirim token
    };
  }

  // GET semua data siswa
  Future<List<Siswa>> getAllSiswa() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig.siswaEndpoint),
        headers: headers,  // ← Pakai headers dengan token
      );

      print('Get Siswa Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Siswa> siswaList = (data['data'] as List)
            .map((item) => Siswa.fromJson(item))
            .toList();
        return siswaList;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getAllSiswa: $e');
      throw Exception('Error: $e');
    }
  }

  // POST tambah siswa baru
  Future<bool> createSiswa(Siswa siswa) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConfig.siswaEndpoint),
        headers: headers,
        body: json.encode(siswa.toJson()),
      );

      print('Create Siswa Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error createSiswa: $e');
      throw Exception('Error: $e');
    }
  }

  // PUT update siswa
  Future<bool> updateSiswa(int id, Siswa siswa) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConfig.siswaEndpoint}/$id'),
        headers: headers,
        body: json.encode(siswa.toJson()),
      );

      print('Update Siswa Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error updateSiswa: $e');
      throw Exception('Error: $e');
    }
  }

  // DELETE hapus siswa
  Future<bool> deleteSiswa(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.siswaEndpoint}/$id'),
        headers: headers,
      );

      print('Delete Siswa Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleteSiswa: $e');
      throw Exception('Error: $e');
    }
  }
}