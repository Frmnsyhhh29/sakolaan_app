// lib/models/siswa_model.dart
class Siswa {
  final int? id;
  final String nis;
  final String nama;
  final String kelas;
  final String alamat;
  final String noHp;
  final String? createdAt;
  final String? updatedAt;

  Siswa({
    this.id,
    required this.nis,
    required this.nama,
    required this.kelas,
    required this.alamat,
    required this.noHp,
    this.createdAt,
    this.updatedAt,
  });

  // Konversi dari JSON ke Object Siswa
  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'],
      nis: json['nis'].toString(),
      nama: json['nama'] ?? '',
      kelas: json['kelas'] ?? '',
      alamat: json['alamat'] ?? '',
      noHp: json['no_hp'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Konversi dari Object Siswa ke JSON
  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama': nama,
      'kelas': kelas,
      'alamat': alamat,
      'no_hp': noHp,
    };
  }

  // Fungsi untuk membuat copy dengan perubahan tertentu
  Siswa copyWith({
    int? id,
    String? nis,
    String? nama,
    String? kelas,
    String? alamat,
    String? noHp,
    String? createdAt,
    String? updatedAt,
  }) {
    return Siswa(
      id: id ?? this.id,
      nis: nis ?? this.nis,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      alamat: alamat ?? this.alamat,
      noHp: noHp ?? this.noHp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}