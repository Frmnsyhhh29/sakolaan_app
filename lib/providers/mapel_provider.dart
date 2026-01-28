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
  MapelNotifier() : super(MapelState());

  // Load semua data mapel
  Future<void> loadMapel() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final mapelList = await MapelService.getAllMapel();
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
      final mapelList = await MapelService.getAllMapel();
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
  Future<Mapel?> getMapelById(String id) async {
    try {
      return await MapelService.getMapelById(id);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  // Tambah mapel baru
  Future<bool> addMapel({
    required String kodeMapel,
    required String namaMapel,
    required String guruPengampu,
    required int jamPelajaran,
    String? deskripsi,
  }) async {
    try {
      final success = await MapelService.createMapel(
        kodeMapel: kodeMapel,
        namaMapel: namaMapel,
        guruPengampu: guruPengampu,
        jamPelajaran: jamPelajaran,
        deskripsi: deskripsi,
      );
      if (success) {
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
  Future<bool> updateMapel({
    required String mapelId,
    required String kodeMapel,
    required String namaMapel,
    required String guruPengampu,
    required int jamPelajaran,
    String? deskripsi,
  }) async {
    try {
      final success = await MapelService.updateMapel(
        mapelId: mapelId,
        kodeMapel: kodeMapel,
        namaMapel: namaMapel,
        guruPengampu: guruPengampu,
        jamPelajaran: jamPelajaran,
        deskripsi: deskripsi,
      );
      if (success) {
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
      final success = await MapelService.deleteMapel(id.toString());
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
      final success = await MapelService.assignSiswa(mapelId, siswaIds);
      if (success) {
        await loadMapel();
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
      final success = await MapelService.removeSiswa(mapelId, siswaId);
      if (success) {
        await loadMapel();
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

// Provider untuk MapelNotifier
final mapelProvider = StateNotifierProvider<MapelNotifier, MapelState>((ref) {
  return MapelNotifier();
});