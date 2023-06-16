import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class InputDate extends StatefulWidget {
  final String labelText;
  final Function(String)? onChanged;

  const InputDate({required this.labelText, this.onChanged,});

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  DateTime? _selectedDate;

   _selectDate(BuildContext context) {
    final DateTime pickedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _selectDate(context),
            child: IgnorePointer(
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
                controller: TextEditingController(
                  text: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
