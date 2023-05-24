import 'package:flutter/material.dart';

class InputNumber extends StatefulWidget {
  final String labelText;
  final Function(String)? onChanged;
  final bool showInfoIcon;
  final bool enabled;

  const InputNumber({
    required this.labelText,
    this.onChanged,
    this.showInfoIcon = false,
    this.enabled = true,
  });

  @override
  _InputNumberState createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  bool showInfoText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
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
                  onChanged: widget.onChanged,
                  enabled: widget.enabled,
                ),
              ),
              if (widget.showInfoIcon)
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    setState(() {
                      showInfoText = !showInfoText;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
