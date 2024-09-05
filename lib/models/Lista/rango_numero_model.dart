import 'package:safe_chat/config/extensions/string_extensions.dart';
import 'package:flutter/services.dart';

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if ((newValue.text.intTryParsed ?? 0) < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return (newValue.text.intTryParsed ?? 0) > max ? oldValue : newValue;
    }
  }
}
