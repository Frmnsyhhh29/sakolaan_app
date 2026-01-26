// lib/providers/siswa_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/siswa_model.dart';
import '../models/siswa_state.dart';
import '../services/siswa_service.dart';

// Provider untuk SiswaService
final siswaServiceProvider = Provider<SiswaService>((ref) {
  return SiswaService();
});

// Provider utama untuk Siswa State
final siswaProvider = StateNotifierProvider<SiswaNotifier, SiswaState>((ref) {
  return SiswaNotifier(ref);
});

// Notifier untuk mengelola Siswa State
class SiswaNotifier extends StateNotifier<SiswaState> {
  final Ref ref;

  SiswaNotifier(this.ref) : super(SiswaState.initial());

  // LOAD DATA - Ambil semua data siswa dari API
  Future<void> loadSiswa() async {
    // Set state ke loading
    state = SiswaState.loading();

    try {
      final siswaService = ref.read(siswaServiceProvider);
      final siswaList = await siswaService.getAllSiswa();

      // Set state dengan data yang didapat
      state = SiswaState.loaded(siswaList);
    } catch (e) {
      // Set state ke error
      state = SiswaState.error('Gagal memuat data: $e');
    }
  }

  // CREATE - Tambah siswa baru
  Future<bool> createSiswa(Siswa siswa) async {
    try {
      // Tampilkan loading (optional)
      state = state.copyWith(isLoading: true);

      final siswaService = ref.read(siswaServiceProvider);
      final success = await siswaService.createSiswa(siswa);

      if (success) {
        // Reload data setelah berhasil tambah
        await loadSiswa();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal menambah data',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error: $e',
      );
      return false;
    }
  }

  // UPDATE - Edit data siswa
  Future<bool> updateSiswa(int id, Siswa siswa) async {
    try {
      state = state.copyWith(isLoading: true);

      final siswaService = ref.read(siswaServiceProvider);
      final success = await siswaService.updateSiswa(id, siswa);

      if (success) {
        // Reload data setelah berhasil update
        await loadSiswa();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal mengupdate data',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error: $e',
      );
      return false;
    }
  }

  // DELETE - Hapus siswa
  Future<bool> deleteSiswa(int id) async {
    try {
      state = state.copyWith(isLoading: true);

      final siswaService = ref.read(siswaServiceProvider);
      final success = await siswaService.deleteSiswa(id);

      if (success) {
        // Reload data setelah berhasil hapus
        await loadSiswa();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal menghapus data',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error: $e',
      );
      return false;
    }
  }

  // REFRESH - Reload data (untuk pull to refresh)
  Future<void> refreshSiswa() async {
    await loadSiswa();
  }

  // CLEAR ERROR - Hapus pesan error
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}