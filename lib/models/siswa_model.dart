// lib/models/siswa_model.dart
class Siswa {
  final String? id;
  final String nis;
  final String nama; 
  final String? kelasId;
  final String? kelas;  // Nama kelas dalam bentuk string
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
    // ✅ PERBAIKAN: Handle kelas yang berupa object atau string
    String? kelasName;
    
    if (json['kelas'] != null) {
      if (json['kelas'] is Map) {
        // Jika kelas berupa object, ambil nama_kelas
        kelasName = json['kelas']['nama_kelas']?.toString();
      } else if (json['kelas'] is String) {
        // Jika kelas berupa string, gunakan langsung
        kelasName = json['kelas'];
      }
    }
    
    // Fallback ke kelas_nama jika ada
    kelasName ??= json['kelas_nama']?.toString();
    
    return Siswa(
      id: json['id']?.toString(),
      nis: json['nis'] ?? '',
      nama: json['nama_lengkap'] ?? '',
      kelasId: json['kelas_id']?.toString(),
      kelas: kelasName,  // ✅ Sudah di-extract nama kelasnya saja
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
      'nama_lengkap': nama,
      if (kelasId != null) 'kelas_id': kelasId,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
      'alamat': alamat,
      'no_hp': noHp,
      if (email != null) 'email': email,
    };
  }

  // Helper untuk display
  String get displayKelas => kelas ?? 'Belum ada kelas';
  String get displayJenisKelamin => jenisKelamin ?? '-';
}