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
    return Column(

    );
  }
}
