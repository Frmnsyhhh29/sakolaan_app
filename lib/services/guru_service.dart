// lib/services/guru_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/guru_model.dart';
import 'storage_service.dart';

class GuruService {
  final StorageService _storageService;

  // Constructor yang menerima StorageService
  GuruService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  // Fungsi helper untuk mendapatkan headers dengan token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',  // ← Kirim token
    };
  }

  // GET semua data guru
  Future<List<Guru>> getAllGuru() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig.guruEndpoint),
        headers: headers,  // ← Pakai headers dengan token
      );

      print('Get Guru Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Guru> guruList = (data['data'] as List)
            .map((item) => Guru.fromJson(item))
            .toList();
        return guruList;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getAllGuru: $e');
      throw Exception('Error: $e');
    }
  }

  // GET guru by ID
  Future<Guru?> getGuruById(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.guruEndpoint}/$id'),
        headers: headers,
      );

      print('Get Guru By ID Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Guru.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid');
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getGuruById: $e');
      throw Exception('Error: $e');
    }
  }

  // POST tambah guru baru
  Future<bool> createGuru(Guru guru) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConfig.guruEndpoint),
        headers: headers,
        body: json.encode(guru.toJson()),
      );

      print('Create Guru Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error createGuru: $e');
      throw Exception('Error: $e');
    }
  }

  // PUT update guru
  Future<bool> updateGuru(int id, Guru guru) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConfig.guruEndpoint}/$id'),
        headers: headers,
        body: json.encode(guru.toJson()),
      );

      print('Update Guru Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error updateGuru: $e');
      throw Exception('Error: $e');
    }
  }

  // DELETE hapus guru
  Future<bool> deleteGuru(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.guruEndpoint}/$id'),
        headers: headers,
      );

      print('Delete Guru Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleteGuru: $e');
      throw Exception('Error: $e');
    }
  }
}