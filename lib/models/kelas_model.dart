class Kelas {
  final String id;
  final String namaKelas;
  final String waliKelas;

  Kelas({
    required this.id,
    required this.namaKelas,
    required this.waliKelas,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id'],
      namaKelas: json['nama_kelas'],
      waliKelas: json['wali_kelas'],
    );
  }
}
