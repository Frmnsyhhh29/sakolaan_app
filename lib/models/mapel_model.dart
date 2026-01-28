// lib/models/mapel_model.dart
class Mapel {
  final int? id;
  final String kodeMapel;
  final String namaMapel;
  final String? deskripsi;
  final int? siswaCount; // jumlah siswa yang mengambil mapel ini
  final String? createdAt;
  final String? updatedAt;

  Mapel({
    this.id,
    required this.kodeMapel,
    required this.namaMapel,
    this.deskripsi,
    this.siswaCount,
    this.createdAt,
    this.updatedAt,
  });

  // Konversi dari JSON ke Object Mapel
  factory Mapel.fromJson(Map<String, dynamic> json) {
    return Mapel(
      id: json['id'],
      kodeMapel: json['kode_mapel'] ?? '',
      namaMapel: json['nama_mapel'] ?? '',
      deskripsi: json['deskripsi'],
      siswaCount: json['siswa_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Konversi dari Object Mapel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'kode_mapel': kodeMapel,
      'nama_mapel': namaMapel,
      'deskripsi': deskripsi,
    };
  }

  // Fungsi untuk membuat copy dengan perubahan tertentu
  Mapel copyWith({
    int? id,
    String? kodeMapel,
    String? namaMapel,
    String? deskripsi,
    int? siswaCount,
    String? createdAt,
    String? updatedAt,
  }) {
    return Mapel(
      id: id ?? this.id,
      kodeMapel: kodeMapel ?? this.kodeMapel,
      namaMapel: namaMapel ?? this.namaMapel,
      deskripsi: deskripsi ?? this.deskripsi,
      siswaCount: siswaCount ?? this.siswaCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}