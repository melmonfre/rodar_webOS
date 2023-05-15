import 'package:flutter/material.dart';

class ContainerCheckIn extends StatefulWidget {
  final String title;
  final ValueChanged<String> onOptionSelected;

  ContainerCheckIn({required this.title, required this.onOptionSelected});

  @override
  _ContainerCheckInState createState() => _ContainerCheckInState();
}

class _ContainerCheckInState extends State<ContainerCheckIn> {
  String? selectedButton; // Alterada para tipo nullable String

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.0),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: <Widget>[
                    RadioListTile(
                      title: Text(
                        'OK',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: 'OK',
                      groupValue: selectedButton,
                      onChanged: (value) {
                        setState(() {
                          selectedButton = value.toString();
                          widget.onOptionSelected(value
                              .toString()); // Chame a função onOptionSelected e passe o valor selecionado
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Defeito',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: 'Defeito',
                      groupValue: selectedButton,
                      onChanged: (value) {
                        setState(() {
                          selectedButton = value.toString();
                          widget.onOptionSelected(value
                              .toString()); // Chame a função onOptionSelected e passe o valor selecionado
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Não Possui',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: 'Não Possui',
                      groupValue: selectedButton,
                      onChanged: (value) {
                        setState(() {
                          selectedButton = value.toString();
                          widget.onOptionSelected(value
                              .toString()); // Chame a função onOptionSelected e passe o valor selecionado
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Observação...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
