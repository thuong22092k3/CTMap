// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctmap/data/type.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

class AccidentStateNotifier extends StateNotifier<List<AccidentData>> {
  AccidentStateNotifier() : super([]);

  void setAccidents(List<AccidentData> accidents) {
    state = accidents;
  }

  List<AccidentData> getAccidents() => state;

  void addAccident(Map<String, Object> accidentData) {
    try {
      final accident = AccidentData(
        id: accidentData['id'] as String,
        date: DateFormat('dd/MM/yyyy').parse(accidentData['date'] as String),
        deaths: int.parse(accidentData['deaths'] as String),
        injuries: int.parse(accidentData['injuries'] as String),
        level: int.parse(accidentData['level'] as String),
        cause: int.parse(accidentData['cause'] as String),
        position: LatLng(
          double.parse(accidentData['positionLat'] as String),
          double.parse(accidentData['positionLng'] as String),
        ),
        link: accidentData['link'] as String,
        sophuongtienlienquan:
            int.parse(accidentData['sophuongtienlienquan'] as String),
        userName: accidentData['userName'] as String,
        location: accidentData['location'] as String,
        city: accidentData['city'] as String,
        showUserName: accidentData['showUserName'] as bool,
      );

      state = [...state, accident];
    } catch (e) {
      print("Error converting data: $e");
    }
  }

  // void removeAccident(AccidentData accident) {
  //   state = state.where((acc) => acc.id != accident.id).toList();
  // }

  void removeAccident(String id) {
    state = state.where((accident) => accident.id != id).toList();
  }

  // void updateAccident(AccidentData updatedAccident) {
  //   state = state.map((accident) {
  //     return accident.id == updatedAccident.id ? updatedAccident : accident;
  //   }).toList();
  // }

   void updateAccident(String id, Map<String, Object> updatedData) {
    state = [
      for (final accident in state)
        if (accident.id == id)
          accident.copyWith(updatedData)
        else
          accident
    ];
  }
}

final accidentProvider =
    StateNotifierProvider<AccidentStateNotifier, List<AccidentData>>((ref) {
  return AccidentStateNotifier();
});
