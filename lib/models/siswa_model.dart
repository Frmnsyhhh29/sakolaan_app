// lib/models/siswa_model.dart
class Siswa {
  final String? id;
  final String nis;
  final String nama;
  final String? kelasId;  // ✅ Untuk relasi ke tabel kelas
  final String? kelas;    // ✅ Untuk display nama kelas (dari response API)
  final String? jenisKelamin;
  final String? tanggalLahir;
  final String alamat;
  final String noHp;
  final String? email;

  Siswa({
    this.id,
    required this.nis,
    required this.nama,
    this.kelasId,
    this.kelas,
    this.jenisKelamin,
    this.tanggalLahir,
    required this.alamat,
    required this.noHp,
    this.email,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id']?.toString(),
      nis: json['nis'] ?? '',
      nama: json['nama'] ?? '',
      kelasId: json['kelas_id']?.toString(),
      kelas: json['kelas']?.toString() ?? json['kelas_nama'], // Support both formats
      jenisKelamin: json['jenis_kelamin'],
      tanggalLahir: json['tanggal_lahir'],
      alamat: json['alamat'] ?? '',
      noHp: json['no_hp'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nis': nis,
      'nama': nama,
      if (kelasId != null) 'kelas_id': kelasId,
      if (kelas != null) 'kelas': kelas,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
      'alamat': alamat,
      'no_hp': noHp,
      if (email != null) 'email': email,
    };
  }

  // Helper untuk display
  String get displayKelas => kelas ?? 'Belum ada kelas';
  String get displayJenisKelamin {
    if (jenisKelamin == 'L') return 'Laki-laki';
    if (jenisKelamin == 'P') return 'Perempuan';
    return '-';
  }
}