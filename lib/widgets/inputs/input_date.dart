import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class InputDate extends StatefulWidget {
  final String labelText;

  const InputDate({required this.labelText});

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
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
                  text: _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
