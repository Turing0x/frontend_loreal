import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_chat/config/globals/variables.dart';

class DateRnageProvider extends StateNotifier<DateRangeModel> {
  DateRnageProvider()
      : super(DateRangeModel(initialDate: todayGlobal, endDate: todayGlobal));

  void setInitialDate(String date) {
    state = state.copyWith(initialDate: date);
  }

  void setEndDate(String date) {
    state = state.copyWith(endDate: date);
  }
}

class DateRangeModel {
  final String initialDate;
  final String endDate;

  DateRangeModel({
    required this.initialDate,
    required this.endDate,
  });

  copyWith({
    String? initialDate,
    String? endDate,
  }) {
    return DateRangeModel(
      initialDate: initialDate ?? this.initialDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
