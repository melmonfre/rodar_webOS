import 'package:flutter/material.dart';

class BotaoFuturas extends StatelessWidget {

  const BotaoFuturas();

  @override
  Widget build(BuildContext context) {
    return  Container(
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
    );
  }
}


class BotaoAmanha extends StatelessWidget {

  const BotaoAmanha();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class BotaoHoje extends StatelessWidget {

  const BotaoHoje();

  @override
  Widget build(BuildContext context) {
     return Container(
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
    );
  }
}

class BotaoAtrasado extends StatelessWidget {

  const BotaoAtrasado();

  @override
  Widget build(BuildContext context) {
    return
       Container(
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
      );

  }
}

