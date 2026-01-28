// lib/models/mapel_state.dart
import 'mapel_model.dart';

class MapelState {
  final List<Mapel> mapelList;
  final bool isLoading;
  final String? errorMessage;

  MapelState({
    required this.mapelList,
    this.isLoading = false,
    this.errorMessage,
  });

  // State awal (kosong)
  factory MapelState.initial() {
    return MapelState(
      mapelList: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  // State loading
  factory MapelState.loading() {
    return MapelState(
      mapelList: [],
      isLoading: true,
      errorMessage: null,
    );
  }

  // State dengan data
  factory MapelState.loaded(List<Mapel> mapelList) {
    return MapelState(
      mapelList: mapelList,
      isLoading: false,
      errorMessage: null,
    );
  }

  // State error
  factory MapelState.error(String message) {
    return MapelState(
      mapelList: [],
      isLoading: false,
      errorMessage: message,
    );
  }

  // Copy dengan perubahan
  MapelState copyWith({
    List<Mapel>? mapelList,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return MapelState(
      mapelList: mapelList ?? this.mapelList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}