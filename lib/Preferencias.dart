import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Preferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (title: Text("Preferencias"),),
      body: Center(
        child: ElevatedButton(onPressed: () {
          Navigator.pop(context);
        }
          , child: Text("Página de coniguración")
          ,)
      ),
    );

  }

}