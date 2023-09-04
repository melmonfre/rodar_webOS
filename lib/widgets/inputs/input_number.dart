import 'package:flutter/material.dart';

class InputNumber extends StatefulWidget {
  final String labelText;
  final double? initialValue;
  final Function(String)? onChanged;
  final bool showInfoIcon;
  final bool enabled;

  const InputNumber({super.key, 
    required this.labelText,
    this.onChanged,
    this.initialValue,
    this.showInfoIcon = false,
    this.enabled = true,
  });

  @override
  _InputNumberState createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  bool showInfoText = false;

late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null ? widget.initialValue!.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
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
          if (widget.showInfoIcon && showInfoText)
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 10.0, 3.0, 0.0),
              child: Text(
                'O cálculo do valor é feito automaticamente pelo sistema e desconta a sua área de abrangência:\n\n'
                'Distância Informada = 1.00\n'
                'Área de abrangência (ida e volta) = 2 x 0 = 0.00\n'
                'Valor Km = R\$0.00\n'
                'Distância = 1 - (2 x 0) = 1.00\n'
                'Valor = 1 x 0 = R\$0.00',
              ),
            ),
        ],
      ),
    );
  }
}
