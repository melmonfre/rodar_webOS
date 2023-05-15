import 'package:flutter/material.dart';

class BotaoCancelar extends StatelessWidget {
  final VoidCallback onPressed;
  final int index;

  BotaoCancelar({required this.onPressed, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: IconButton(
        icon: Icon(Icons.close),
        onPressed: onPressed,
        color: Colors.black,
      ),
    );
  }
}
