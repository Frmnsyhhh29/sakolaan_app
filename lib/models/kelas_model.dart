
// lib/models/kelas_model.dart
class Kelas {
  final String id;
  final String namaKelas;
  final String tingkat;
  final String jurusan;
  final String? waliKelas;
  final int? kapasitas;
  final int? jumlahSiswa;

  Kelas({
    required this.id,
    required this.namaKelas,
    required this.tingkat,
    required this.jurusan,
    this.waliKelas,
    this.kapasitas,
    this.jumlahSiswa,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id']?.toString() ?? '',
      namaKelas: json['nama_kelas'] ?? '',
      tingkat: json['tingkat'] ?? '',
      jurusan: json['jurusan'] ?? '',
      waliKelas: json['wali_kelas'],
      kapasitas: json['kapasitas'],
      jumlahSiswa: json['jumlah_siswa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kelas': namaKelas,
      'tingkat': tingkat,
      'jurusan': jurusan,
      'wali_kelas': waliKelas,
      'kapasitas': kapasitas,
      'jumlah_siswa': jumlahSiswa,
    };
  }

  // Helper getter untuk display
  String get displayName => '$namaKelas - $jurusan';
}