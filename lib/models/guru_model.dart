// lib/models/siswa_model.dart
class Guru {
  final int? id;
  final String nip;
  final String nama;
  final String alamat;
  final String noHp;
  final String? createdAt;
  final String? updatedAt;

  Guru({
    this.id,
    required this.nip,
    required this.nama,
    required this.alamat,
    required this.noHp,
    this.createdAt,
    this.updatedAt,
  });

  // Konversi dari JSON ke Object Siswa
  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      id: json['id'],
      nip: json['nip'].toString(),
      nama: json['nama_guru'] ?? '',
      alamat: json['alamat'] ?? '',
      noHp: json['no_hp'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Konversi dari Object Siswa ke JSON
  Map<String, dynamic> toJson() {
    return {
      'nip': nip,
      'nama': nama,
      'alamat': alamat,
      'no_hp': noHp,
    };
  }

  // Fungsi untuk membuat copy dengan perubahan tertentu
  Guru copyWith({
    int? id,
    String? nis,
    String? nama,
    String? kelas,
    String? alamat,
    String? noHp,
    String? createdAt,
    String? updatedAt,
  }) {
    return Guru(
      id: id ?? this.id,
      nip: nis ?? this.nip,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      noHp: noHp ?? this.noHp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}