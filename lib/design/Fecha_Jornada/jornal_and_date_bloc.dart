import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticker_maker/config/globals/variables.dart';

class JAndDateProvider extends StateNotifier<JAndDateModel> {
  JAndDateProvider()
      : super(JAndDateModel(
            currentDate: todayGlobal, currentJornada: jornalGlobal));

  void setCurrentDate(String date) {
    state = state.copyWith(currentDate: date);
  }

  void setCurrentJornada(String jornada) {
    state = state.copyWith(currentJornada: jornada);
  }
}

class JAndDateModel {
  final String currentDate;
  final String currentJornada;

  JAndDateModel({
    required this.currentDate,
    required this.currentJornada,
  });

  copyWith({
    String? currentDate,
    String? currentJornada,
  }) {
    return JAndDateModel(
      currentDate: currentDate ?? this.currentDate,
      currentJornada: currentJornada ?? this.currentJornada,
    );
  }
}
