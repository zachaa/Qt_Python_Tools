import 'package:flutter/services.dart';

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;
  final int decimalsToShow;

  NumericalRangeFormatter({required this.min, required this.max, required this.decimalsToShow});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {

    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return TextEditingValue().copyWith(text: min.toStringAsFixed(decimalsToShow));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}