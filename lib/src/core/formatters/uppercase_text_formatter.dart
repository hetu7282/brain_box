import 'package:flutter/services.dart';

/// A custom [TextInputFormatter] that converts the input text to uppercase.
class UppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Convert the input text to uppercase.
    final text = newValue.text.toUpperCase();

    // Return the updated TextEditingValue with the transformed text and updated selection.
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
