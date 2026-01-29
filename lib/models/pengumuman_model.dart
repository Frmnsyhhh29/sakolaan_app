class Pengumuman {
  final String id;
  final String judul;
  final String isi;
  final String kategori; // 'umum', 'penting', 'kegiatan'
  final DateTime tanggal;
  final String? penulis;
  final bool isPinned;

  Pengumuman({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.tanggal,
    this.penulis,
    this.isPinned = false,
  });

  factory Pengumuman.fromJson(Map<String, dynamic> json) {
    return Pengumuman(
      id: json['id'] ?? '',
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      kategori: json['kategori'] ?? 'umum',
      tanggal: json['tanggal'] != null 
          ? DateTime.parse(json['tanggal']) 
          : DateTime.now(),
      penulis: json['penulis'],
      isPinned: json['isPinned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
      'penulis': penulis,
      'isPinned': isPinned,
    };
  }

  Pengumuman copyWith({
    String? id,
    String? judul,
    String? isi,
    String? kategori,
    DateTime? tanggal,
    String? penulis,
    bool? isPinned,
  }) {
    return Pengumuman(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      tanggal: tanggal ?? this.tanggal,
      penulis: penulis ?? this.penulis,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}