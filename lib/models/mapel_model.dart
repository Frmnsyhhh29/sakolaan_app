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

      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      kodeMapel: json['kode_mapel']?.toString() ?? '',
      namaMapel: json['nama_mapel']?.toString() ?? '',
      guruPengampu: json['guru_pengampu']?.toString() ?? '',
      jamPelajaran: json['jam_pelajaran'] is String 
          ? int.parse(json['jam_pelajaran']) 
          : json['jam_pelajaran'],
      deskripsi: json['deskripsi']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
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