import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pengumuman_model.dart';

// State untuk Pengumuman
class PengumumanState {
  final List<Pengumuman> pengumumanList;
  final bool isLoading;
  final String? error;
  final String selectedKategori;
  final String searchQuery;

  PengumumanState({
    this.pengumumanList = const [],
    this.isLoading = false,
    this.error,
    this.selectedKategori = 'semua',
    this.searchQuery = '',
  });

  PengumumanState copyWith({
    List<Pengumuman>? pengumumanList,
    bool? isLoading,
    String? error,
    String? selectedKategori,
    String? searchQuery,
  }) {
    return PengumumanState(
      pengumumanList: pengumumanList ?? this.pengumumanList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedKategori: selectedKategori ?? this.selectedKategori,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<Pengumuman> get filteredPengumuman {
    var filtered = pengumumanList;

    // Filter by kategori
    if (selectedKategori != 'semua') {
      filtered = filtered.where((p) => p.kategori == selectedKategori).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.judul.toLowerCase().contains(searchQuery.toLowerCase()) ||
        p.isi.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    // Sort: pinned first, then by date
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.tanggal.compareTo(a.tanggal);
    });

    return filtered;
  }
}

// Notifier untuk Pengumuman
class PengumumanNotifier extends StateNotifier<PengumumanState> {
  PengumumanNotifier() : super(PengumumanState()) {
    loadPengumuman();
  }

  Future<void> loadPengumuman() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Data dummy untuk demo
      final dummyData = [
        Pengumuman(
          id: '1',
          judul: 'Libur Semester Ganjil 2024/2025',
          isi: 'Libur semester ganjil akan dimulai pada tanggal 20 Desember 2024 sampai dengan 5 Januari 2025. Kegiatan belajar mengajar akan dimulai kembali pada tanggal 6 Januari 2025.',
          kategori: 'penting',
          tanggal: DateTime.now().subtract(const Duration(days: 2)),
          penulis: 'Admin Sekolah',
          isPinned: true,
        ),
        Pengumuman(
          id: '2',
          judul: 'Pendaftaran Ekstrakurikuler Semester Genap',
          isi: 'Dibuka pendaftaran ekstrakurikuler untuk semester genap. Pendaftaran dapat dilakukan melalui wali kelas masing-masing paling lambat 15 Januari 2025.',
          kategori: 'kegiatan',
          tanggal: DateTime.now().subtract(const Duration(days: 1)),
          penulis: 'Wakasek Kesiswaan',
          isPinned: true,
        ),
        Pengumuman(
          id: '3',
          judul: 'Pemberitahuan Jadwal Ujian Akhir Semester',
          isi: 'Ujian Akhir Semester akan dilaksanakan pada tanggal 10-14 Desember 2024. Siswa diharapkan mempersiapkan diri dengan baik. Jadwal lengkap dapat dilihat di papan pengumuman sekolah.',
          kategori: 'penting',
          tanggal: DateTime.now().subtract(const Duration(days: 5)),
          penulis: 'Kurikulum',
        ),
        Pengumuman(
          id: '4',
          judul: 'Lomba Kreativitas Siswa',
          isi: 'Akan diadakan lomba kreativitas siswa tingkat sekolah pada tanggal 25 Januari 2025. Kategori lomba meliputi: seni lukis, menulis cerpen, dan videografi. Info lebih lanjut hubungi OSIS.',
          kategori: 'kegiatan',
          tanggal: DateTime.now().subtract(const Duration(days: 7)),
          penulis: 'OSIS',
        ),
        Pengumuman(
          id: '5',
          judul: 'Pembayaran SPP Bulan Januari',
          isi: 'Pembayaran SPP untuk bulan Januari 2025 dibuka mulai tanggal 2 Januari 2025. Bagi yang telat membayar akan dikenakan denda sesuai ketentuan yang berlaku.',
          kategori: 'umum',
          tanggal: DateTime.now().subtract(const Duration(days: 10)),
          penulis: 'Bagian Keuangan',
        ),
        Pengumuman(
          id: '6',
          judul: 'Perubahan Jam Masuk Sekolah',
          isi: 'Mulai tanggal 8 Januari 2025, jam masuk sekolah berubah menjadi pukul 07:00 WIB. Siswa diharapkan sudah berada di sekolah 10 menit sebelum bel masuk berbunyi.',
          kategori: 'penting',
          tanggal: DateTime.now().subtract(const Duration(days: 3)),
          penulis: 'Kepala Sekolah',
        ),
        Pengumuman(
          id: '7',
          judul: 'Bakti Sosial Bulan Ramadhan',
          isi: 'Sekolah akan mengadakan kegiatan bakti sosial menyambut bulan Ramadhan. Kegiatan akan dilaksanakan di panti asuhan dan panti jompo sekitar sekolah. Pendaftaran peserta dibuka mulai sekarang.',
          kategori: 'kegiatan',
          tanggal: DateTime.now().subtract(const Duration(days: 12)),
          penulis: 'Rohis',
        ),
        Pengumuman(
          id: '8',
          judul: 'Pemeliharaan Website Sekolah',
          isi: 'Website sekolah akan mengalami pemeliharaan pada tanggal 30 Januari 2025 pukul 22:00 - 02:00 WIB. Selama periode tersebut, website tidak dapat diakses. Mohon maaf atas ketidaknyamanannya.',
          kategori: 'umum',
          tanggal: DateTime.now().subtract(const Duration(hours: 6)),
          penulis: 'Tim IT',
        ),
      ];

      state = state.copyWith(
        pengumumanList: dummyData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setKategori(String kategori) {
    state = state.copyWith(selectedKategori: kategori);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> tambahPengumuman(Pengumuman pengumuman) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedList = [...state.pengumumanList, pengumuman];
      state = state.copyWith(
        pengumumanList: updatedList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updatePengumuman(Pengumuman pengumuman) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedList = state.pengumumanList.map((p) {
        return p.id == pengumuman.id ? pengumuman : p;
      }).toList();
      
      state = state.copyWith(
        pengumumanList: updatedList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> hapusPengumuman(String id) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedList = state.pengumumanList.where((p) => p.id != id).toList();
      state = state.copyWith(
        pengumumanList: updatedList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> togglePin(String id) async {
    final pengumuman = state.pengumumanList.firstWhere((p) => p.id == id);
    await updatePengumuman(pengumuman.copyWith(isPinned: !pengumuman.isPinned));
  }
}

// Provider
final pengumumanProvider = StateNotifierProvider<PengumumanNotifier, PengumumanState>((ref) {
  return PengumumanNotifier();
});