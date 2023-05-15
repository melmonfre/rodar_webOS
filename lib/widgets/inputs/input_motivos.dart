import 'package:flutter/material.dart';

class InputMotivos extends StatefulWidget {
  final String labelText;
  final Function(String)? onChanged;

  const InputMotivos({
    required this.labelText,
    this.onChanged,
  });

  @override
  _InputMotivosState createState() => _InputMotivosState();
}

class _InputMotivosState extends State<InputMotivos> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
            ),
            minLines: 5,
            maxLines: null,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
