import 'package:flutter/material.dart';
import 'camera.dart';
import 'assinatura.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            decoration: BoxDecoration(
              color: Color(0xFF26738e),
            ),
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Color(0xFF26738e),
            ),
            title: Text('Assinatura'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Assinatura()),
              // );
            },
          ),
          ListTile(
              leading: Icon(
                Icons.camera,
                color: Color(0xFF26738e),
              ),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
              }),
        ],
      ),
    );
  }
}
