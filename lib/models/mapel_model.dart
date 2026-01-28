// lib/models/mapel_model.dart
class Mapel {
<<<<<<< Updated upstream
  final int? id;
  final String kodeMapel;
  final String namaMapel;
  final String? deskripsi;
  final int? siswaCount; // jumlah siswa yang mengambil mapel ini
  final String? guruPengampu; // Tambahkan property ini
  final String? jamPelajaran; // Tambahkan property ini
=======
  final int id;
  final String kodeMapel;
  final String namaMapel;
  final String guruPengampu;
  final int jamPelajaran;
  final String? deskripsi;
>>>>>>> Stashed changes
  final String? createdAt;
  final String? updatedAt;

  Mapel({
<<<<<<< Updated upstream
    this.id,
    required this.kodeMapel,
    required this.namaMapel,
    this.deskripsi,
    this.siswaCount,
    this.guruPengampu, // Tambahkan di constructor
    this.jamPelajaran, // Tambahkan di constructor
=======
    required this.id,
    required this.kodeMapel,
    required this.namaMapel,
    required this.guruPengampu,
    required this.jamPelajaran,
    this.deskripsi,
>>>>>>> Stashed changes
    this.createdAt,
    this.updatedAt,
  });

<<<<<<< Updated upstream
  // Konversi dari JSON ke Object Mapel
  factory Mapel.fromJson(Map<String, dynamic> json) {
    return Mapel(
      id: json['id'],
      kodeMapel: json['kode_mapel'] ?? '',
      namaMapel: json['nama_mapel'] ?? '',
      deskripsi: json['deskripsi'],
      siswaCount: json['siswa_count'],
      guruPengampu: json['guru_pengampu'], // Tambahkan ini
      jamPelajaran: json['jam_pelajaran'], // Tambahkan ini
=======
  factory Mapel.fromJson(Map<String, dynamic> json) {
    return Mapel(
      id: json['id'],
      kodeMapel: json['kode_mapel'],
      namaMapel: json['nama_mapel'],
      guruPengampu: json['guru_pengampu'],
      jamPelajaran: json['jam_pelajaran'],
      deskripsi: json['deskripsi'],
>>>>>>> Stashed changes
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

<<<<<<< Updated upstream
  // Konversi dari Object Mapel ke JSON
=======
>>>>>>> Stashed changes
  Map<String, dynamic> toJson() {
    return {
      'kode_mapel': kodeMapel,
      'nama_mapel': namaMapel,
<<<<<<< Updated upstream
      'deskripsi': deskripsi,
      'guru_pengampu': guruPengampu, // Tambahkan ini
      'jam_pelajaran': jamPelajaran, // Tambahkan ini
    };
  }

  // Fungsi untuk membuat copy dengan perubahan tertentu
  Mapel copyWith({
    int? id,
    String? kodeMapel,
    String? namaMapel,
    String? deskripsi,
    int? siswaCount,
    String? guruPengampu, // Tambahkan parameter ini
    String? jamPelajaran, // Tambahkan parameter ini
    String? createdAt,
    String? updatedAt,
  }) {
    return Mapel(
      id: id ?? this.id,
      kodeMapel: kodeMapel ?? this.kodeMapel,
      namaMapel: namaMapel ?? this.namaMapel,
      deskripsi: deskripsi ?? this.deskripsi,
      siswaCount: siswaCount ?? this.siswaCount,
      guruPengampu: guruPengampu ?? this.guruPengampu, // Tambahkan ini
      jamPelajaran: jamPelajaran ?? this.jamPelajaran, // Tambahkan ini
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
=======
      'guru_pengampu': guruPengampu,
      'jam_pelajaran': jamPelajaran,
      'deskripsi': deskripsi,
    };
  }
>>>>>>> Stashed changes
}