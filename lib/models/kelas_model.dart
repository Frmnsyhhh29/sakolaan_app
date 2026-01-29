
class Kelas {
  final int id;

  final String namaKelas;
  final String tingkat;
  final String jurusan;
  final String waliKelas;
  final int? kapasitas;

  final int jumlahSiswa;


  Kelas({
    required this.id,
    required this.namaKelas,
    required this.tingkat,
    required this.jurusan,
    required this.waliKelas,
    this.kapasitas,

    required this.jumlahSiswa,

  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(

      id: json['id'] ?? 0,
      namaKelas: json['nama_kelas'] ?? '',
      tingkat: json['tingkat'] ?? '',
      jurusan: json['jurusan'] ?? '',
      waliKelas: json['wali_kelas'] ?? '-',
      kapasitas: json['kapasitas'],
      jumlahSiswa: json['siswa_count'] ?? 0,
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
      'siswa_count': jumlahSiswa,
    };
  }

  String get displayName => '$namaKelas - $jurusan';

}