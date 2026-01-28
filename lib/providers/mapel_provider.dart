// lib/providers/mapel_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mapel_model.dart';
import '../services/mapel_service.dart';

// State class untuk Mapel
class MapelState {
  final List<Mapel> mapelList;
  final bool isLoading;
  final String? errorMessage;

  MapelState({
    this.mapelList = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MapelState copyWith({
    List<Mapel>? mapelList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MapelState(
      mapelList: mapelList ?? this.mapelList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Notifier class untuk mengelola state Mapel
class MapelNotifier extends StateNotifier<MapelState> {
  final MapelService _mapelService;

  MapelNotifier(this._mapelService) : super(MapelState());

  // Load semua data mapel
  Future<void> loadMapel() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final mapelList = await _mapelService.getAllMapel();
      state = state.copyWith(
        mapelList: mapelList,
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

  // Refresh data mapel
  Future<void> refreshMapel() async {
    try {
      final mapelList = await _mapelService.getAllMapel();
      state = state.copyWith(
        mapelList: mapelList,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  // Get mapel by ID
  Future<Mapel?> getMapelById(int id) async {
    try {
      return await _mapelService.getMapelById(id);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  // Tambah mapel baru
  Future<bool> addMapel(Mapel mapel) async {
    try {
      final success = await _mapelService.createMapel(mapel);
      if (success) {
        // Reload data setelah berhasil tambah
        await loadMapel();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // Update mapel
  Future<bool> updateMapel(int id, Mapel mapel) async {
    try {
      final success = await _mapelService.updateMapel(id, mapel);
      if (success) {
        // Reload data setelah berhasil update
        await loadMapel();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // Delete mapel
  Future<bool> deleteMapel(int id) async {
    try {
      final success = await _mapelService.deleteMapel(id);
      if (success) {
        final updatedList = state.mapelList.where((m) => m.id != id).toList();
        state = state.copyWith(
          mapelList: updatedList,
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

  // Assign siswa ke mapel
  Future<bool> assignSiswa(int mapelId, List<int> siswaIds) async {
    try {
      final success = await _mapelService.assignSiswa(mapelId, siswaIds);
      if (success) {
        await loadMapel(); // Reload untuk update siswa_count
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  // Remove siswa dari mapel
  Future<bool> removeSiswa(int mapelId, int siswaId) async {
    try {
      final success = await _mapelService.removeSiswa(mapelId, siswaId);
      if (success) {
        await loadMapel(); // Reload untuk update siswa_count
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

// Provider untuk MapelService
final mapelServiceProvider = Provider<MapelService>((ref) {
  return MapelService();
});

// Provider untuk MapelNotifier
final mapelProvider = StateNotifierProvider<MapelNotifier, MapelState>((ref) {
  final mapelService = ref.watch(mapelServiceProvider);
  return MapelNotifier(mapelService);
});