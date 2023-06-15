import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputHodometro extends StatefulWidget {
  final String labelText;
  final Function(String)? onChanged;
 

  const InputHodometro({
    required this.labelText,

    this.onChanged,
  });

  @override
  State<InputHodometro> createState() => _InputHodometroState();
}

class _InputHodometroState extends State<InputHodometro> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(fontSize: 14.0),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 8.0,
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _HodometroInputFormatter(),
        ],
        onChanged: widget.onChanged,
      ),
    );
  }
}

class _HodometroInputFormatter extends TextInputFormatter {
  final _numberFormat = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final text = newValue.text;
    final value = int.tryParse(text.replaceAll(',', ''));

    if (value != null) {
      final formattedValue = _numberFormat.format(value);
      return newValue.copyWith(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }

    return newValue;
  }
}
