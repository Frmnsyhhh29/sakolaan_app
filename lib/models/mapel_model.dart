// lib/models/mapel_model.dart
class Mapel {
  final int id;
  final String kodeMapel;
  final String namaMapel;
  final String guruPengampu;
  final int jamPelajaran;
  final String? deskripsi;
  final String? createdAt;
  final String? updatedAt;

  Mapel({
    required this.id,
    required this.kodeMapel,
    required this.namaMapel,
    required this.guruPengampu,
    required this.jamPelajaran,
    this.deskripsi,
    this.createdAt,
    this.updatedAt,
  });

  factory Mapel.fromJson(Map<String, dynamic> json) {
    return Mapel(
      id: json['id'],
      kodeMapel: json['kode_mapel'],
      namaMapel: json['nama_mapel'],
      guruPengampu: json['guru_pengampu'],
      jamPelajaran: json['jam_pelajaran'],
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_mapel': kodeMapel,
      'nama_mapel': namaMapel,
      'guru_pengampu': guruPengampu,
      'jam_pelajaran': jamPelajaran,
      'deskripsi': deskripsi,
    };
  }
}