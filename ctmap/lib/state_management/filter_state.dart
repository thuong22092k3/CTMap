import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterState {
  final DateTime selectedFromDate;
  final DateTime selectedToDate;
  final List<int> selectedLevels;
  final int selectedAcciType;

  FilterState({
    required this.selectedFromDate,
    required this.selectedToDate,
    required this.selectedLevels,
    required this.selectedAcciType,
  });

  FilterState copyWith({
    DateTime? selectedFromDate,
    DateTime? selectedToDate,
    List<int>? selectedLevels,
    int? selectedAcciType,
  }) {
    return FilterState(
      selectedFromDate: selectedFromDate ?? this.selectedFromDate,
      selectedToDate: selectedToDate ?? this.selectedToDate,
      selectedLevels: selectedLevels ?? this.selectedLevels,
      selectedAcciType: selectedAcciType ?? this.selectedAcciType,
    );
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier()
      : super(FilterState(
          selectedFromDate: DateTime.now(),
          selectedToDate: DateTime.now(),
          selectedLevels: [1, 2, 3, 4, 5],  
          selectedAcciType: 0,  
        ));

  void updateFilters({
    DateTime? fromDate,
    DateTime? toDate,
    List<int>? levels,
    int? acciType,
  }) {
    state = state.copyWith(
      selectedFromDate: fromDate ?? state.selectedFromDate,
      selectedToDate: toDate ?? state.selectedToDate,
      selectedLevels: levels ?? state.selectedLevels,
      selectedAcciType: acciType ?? state.selectedAcciType,
    );
  }

  void resetFilters() {
    state = FilterState(
      selectedFromDate: DateTime.now(),
      selectedToDate: DateTime.now(),
      selectedLevels: [1, 2, 3, 4, 5],  
      selectedAcciType: 0,  
    );
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});
