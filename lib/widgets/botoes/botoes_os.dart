import 'package:flutter/material.dart';

class BotaoFuturas extends StatelessWidget {
  final GestureTapCallback onTap;

  const BotaoFuturas({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0xFFA0E8A1),
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Icon(
          Icons.more_time,
          color: Colors.black,
          size: 25.0,
        ),
      ),
    );
  }
}


class BotaoAmanha extends StatelessWidget {
  final GestureTapCallback onTap;

  const BotaoAmanha({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0xFFFFE192),
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Icon(
          Icons.more_time,
          color: Colors.black,
          size: 25.0,
        ),
      ),
    );
  }
}

class BotaoHoje extends StatelessWidget {
  final GestureTapCallback onTap;

  const BotaoHoje({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0xFF9CDEFF),
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Icon(
          Icons.more_time,
          color: Colors.black,
          size: 25.0,
        ),
      ),
    );
  }
}

class BotaoAtrasado extends StatelessWidget {
  final GestureTapCallback onTap;

  const BotaoAtrasado({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0xFFE8716F),
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Icon(
          Icons.more_time,
          color: Colors.black,
          size: 25.0,
        ),
      ),
    );
  }
}

