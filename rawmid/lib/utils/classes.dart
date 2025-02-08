import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    String formatted = '+7';
    if (digits.length > 1) formatted += ' (${digits.substring(1, digits.length > 4 ? 4 : digits.length)}';
    if (digits.length > 4) formatted += ') ${digits.substring(4, digits.length > 7 ? 7 : digits.length)}';
    if (digits.length > 7) formatted += ' ${digits.substring(7, digits.length > 9 ? 9 : digits.length)}';
    if (digits.length > 9) formatted += ' ${digits.substring(9)}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length)
    );
  }
}