class Kelas {
  final String id;
  final String namaKelas;
  final String waliKelas;
  final int? jumlahSiswa; // Tambahkan property ini

  Kelas({
    required this.id,
    required this.namaKelas,
    required this.waliKelas,
    this.jumlahSiswa, // Tambahkan di constructor
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id'],
      namaKelas: json['nama_kelas'],
      waliKelas: json['wali_kelas'],
      jumlahSiswa: json['jumlah_siswa'], // Tambahkan ini
    );
  }

  // Opsional: tambahkan method toJson jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kelas': namaKelas,
      'wali_kelas': waliKelas,
      'jumlah_siswa': jumlahSiswa,
    };
  }

  // Opsional: tambahkan method copyWith jika diperlukan
  Kelas copyWith({
    String? id,
    String? namaKelas,
    String? waliKelas,
    int? jumlahSiswa,
  }) {
    return Kelas(
      id: id ?? this.id,
      namaKelas: namaKelas ?? this.namaKelas,
      waliKelas: waliKelas ?? this.waliKelas,
      jumlahSiswa: jumlahSiswa ?? this.jumlahSiswa,
    );
  }
}