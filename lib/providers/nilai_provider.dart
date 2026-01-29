import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nilai.dart';
import '../services/nilai_service.dart';

// Provider untuk NilaiService
final nilaiServiceProvider = Provider((ref) => NilaiService());

// State untuk list nilai
class NilaiState {
  final List<Nilai> nilaiList;
  final bool isLoading;
  final String? error;

  NilaiState({
    this.nilaiList = const [],
    this.isLoading = false,
    this.error,
  });

  NilaiState copyWith({
    List<Nilai>? nilaiList,
    bool? isLoading,
    String? error,
  }) {
    return NilaiState(
      nilaiList: nilaiList ?? this.nilaiList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier untuk manage state nilai
class NilaiNotifier extends StateNotifier<NilaiState> {
  final NilaiService _nilaiService;

  NilaiNotifier(this._nilaiService) : super(NilaiState());

  // Load semua nilai
  Future<void> loadNilai({
    int? siswaId,
    int? mapelId,
    String? semester,
    int? tahunAjaran,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final nilai = await _nilaiService.getAllNilai(
        siswaId: siswaId,
        mapelId: mapelId,
        semester: semester,
        tahunAjaran: tahunAjaran,
      );
      state = state.copyWith(nilaiList: nilai, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Tambah nilai baru
  Future<bool> addNilai(Nilai nilai) async {
    try {
      await _nilaiService.createNilai(nilai);
      await loadNilai(); // Refresh list
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // Update nilai
  Future<bool> updateNilai(int id, Nilai nilai) async {
    try {
      await _nilaiService.updateNilai(id, nilai);
      await loadNilai(); // Refresh list
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // Hapus nilai
  Future<bool> deleteNilai(int id) async {
    try {
      await _nilaiService.deleteNilai(id);
      await loadNilai(); // Refresh list
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

// Provider untuk NilaiNotifier
final nilaiProvider = StateNotifierProvider<NilaiNotifier, NilaiState>((ref) {
  final service = ref.watch(nilaiServiceProvider);
  return NilaiNotifier(service);
});