// lib/models/siswa_state.dart
import 'siswa_model.dart';

class SiswaState {
  final List<Siswa> siswaList;
  final bool isLoading;
  final String? errorMessage;

  SiswaState({
    required this.siswaList,
    this.isLoading = false,
    this.errorMessage,
  });

  // State awal (kosong)
  factory SiswaState.initial() {
    return SiswaState(
      siswaList: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  // State loading
  factory SiswaState.loading() {
    return SiswaState(
      siswaList: [],
      isLoading: true,
      errorMessage: null,
    );
  }

  // State dengan data
  factory SiswaState.loaded(List<Siswa> siswaList) {
    return SiswaState(
      siswaList: siswaList,
      isLoading: false,
      errorMessage: null,
    );
  }

  // State error
  factory SiswaState.error(String message) {
    return SiswaState(
      siswaList: [],
      isLoading: false,
      errorMessage: message,
    );
  }

  // Copy dengan perubahan
  SiswaState copyWith({
    List<Siswa>? siswaList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SiswaState(
      siswaList: siswaList ?? this.siswaList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}