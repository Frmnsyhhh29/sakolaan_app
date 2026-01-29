// lib/models/siswa_state.dart
import 'package:flutter/foundation.dart';
import 'siswa_model.dart';

@immutable
class SiswaState {
  final List<Siswa> siswaList;
  final bool isLoading;
  final String? errorMessage;

  const SiswaState({
    this.siswaList = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  // Factory constructors untuk state yang berbeda
  factory SiswaState.initial() {
    return const SiswaState();
  }

  factory SiswaState.loading() {
    return const SiswaState(isLoading: true);
  }

  factory SiswaState.loaded(List<Siswa> siswaList) {
    return SiswaState(
      siswaList: siswaList,
      isLoading: false,
    );
  }

  factory SiswaState.error(String message) {
    return SiswaState(
      isLoading: false,
      errorMessage: message,
    );
  }

  // CopyWith untuk update state
  SiswaState copyWith({
    List<Siswa>? siswaList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SiswaState(
      siswaList: siswaList ?? this.siswaList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Getter untuk kemudahan akses
  bool get hasError => errorMessage != null;
  bool get hasData => siswaList.isNotEmpty;
}