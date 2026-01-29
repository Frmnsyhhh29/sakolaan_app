class Nilai {
  final int id;
  final int siswaId;
  final int mapelId;
  final String semester;
  final int tahunAjaran;
  final double nilaiTugas;
  final double nilaiUts;
  final double nilaiUas;
  final double nilaiAkhir;
  final String grade;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relasi
  final Siswa? siswa;
  final Mapel? mapel;

  Nilai({
    required this.id,
    required this.siswaId,
    required this.mapelId,
    required this.semester,
    required this.tahunAjaran,
    required this.nilaiTugas,
    required this.nilaiUts,
    required this.nilaiUas,
    required this.nilaiAkhir,
    required this.grade,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
    this.siswa,
    this.mapel,
  });

  factory Nilai.fromJson(Map<String, dynamic> json) {
    return Nilai(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      siswaId: json['siswa_id'] is String ? int.parse(json['siswa_id']) : json['siswa_id'],
      mapelId: json['mapel_id'] is String ? int.parse(json['mapel_id']) : json['mapel_id'],
      semester: json['semester']?.toString() ?? '',
      tahunAjaran: json['tahun_ajaran'] is String 
          ? int.parse(json['tahun_ajaran']) 
          : json['tahun_ajaran'],
      nilaiTugas: double.parse(json['nilai_tugas'].toString()),
      nilaiUts: double.parse(json['nilai_uts'].toString()),
      nilaiUas: double.parse(json['nilai_uas'].toString()),
      nilaiAkhir: double.parse(json['nilai_akhir'].toString()),
      grade: json['grade']?.toString() ?? '',
      catatan: json['catatan']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      siswa: json['siswa'] != null ? Siswa.fromJson(json['siswa']) : null,
      mapel: json['mapel'] != null ? Mapel.fromJson(json['mapel']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siswa_id': siswaId,
      'mapel_id': mapelId,
      'semester': semester,
      'tahun_ajaran': tahunAjaran,
      'nilai_tugas': nilaiTugas,
      'nilai_uts': nilaiUts,
      'nilai_uas': nilaiUas,
      'catatan': catatan,
    };
  }
}

// Import models yang dibutuhkan
class Siswa {
  final int id;
  final String nama;
  final String nis;
  
  Siswa({required this.id, required this.nama, required this.nis});
  
  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      nama: json['nama']?.toString() ?? '',
      nis: json['nis']?.toString() ?? '',
    );
  }
}

class Mapel {
  final int id;
  final String namaMapel;
  final String kodeMapel;
  
  Mapel({required this.id, required this.namaMapel, required this.kodeMapel});
  
  factory Mapel.fromJson(Map<String, dynamic> json) {
    return Mapel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      namaMapel: json['nama_mapel']?.toString() ?? '',
      kodeMapel: json['kode_mapel']?.toString() ?? '',
    );
  }
}