// lib/providers/guru_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/guru_model.dart';
import '../services/guru_service.dart';

// State class untuk Guru
class GuruState {
  final List<Guru> guruList;
  final bool isLoading;
  final String? errorMessage;

  GuruState({
    this.guruList = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  GuruState copyWith({
    List<Guru>? guruList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GuruState(
      guruList: guruList ?? this.guruList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Notifier class untuk mengelola state Guru
class GuruNotifier extends StateNotifier<GuruState> {
  final GuruService _guruService;

  GuruNotifier(this._guruService) : super(GuruState());

  // Load semua data guru
  Future<void> loadGuru() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final guruList = await _guruService.getAllGuru();
      state = state.copyWith(
        guruList: guruList,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Refresh data guru
  Future<void> refreshGuru() async {
    try {
      final guruList = await _guruService.getAllGuru();
      state = state.copyWith(
        guruList: guruList,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  // Get guru by ID
  Future<Guru?> getGuruById(int id) async {
    try {
      return await _guruService.getGuruById(id);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  // Tambah guru baru
  Future<bool> addGuru(Guru guru) async {
    try {
      final success = await _guruService.createGuru(guru);
      if (success) {
        // Reload data setelah berhasil tambah
        await loadGuru();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // Update guru
  Future<bool> updateGuru(int id, Guru guru) async {
    try {
      final success = await _guruService.updateGuru(id, guru);
      if (success) {
        // Reload data setelah berhasil update
        await loadGuru();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // Delete guru
  Future<bool> deleteGuru(int id) async {
    try {
      final success = await _guruService.deleteGuru(id);
      if (success) {
        final updatedList = state.guruList.where((g) => g.id != id).toList();
        state = state.copyWith(
          guruList: updatedList,
          errorMessage: null,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Provider untuk GuruService
final guruServiceProvider = Provider<GuruService>((ref) {
  return GuruService();
});

// Provider untuk GuruNotifier
final guruProvider = StateNotifierProvider<GuruNotifier, GuruState>((ref) {
  final guruService = ref.watch(guruServiceProvider);
  return GuruNotifier(guruService);
});