import 'package:flutter/material.dart';

class BsPantalla extends StatefulWidget {
  const BsPantalla({super.key});

  @override
  State<BsPantalla> createState() => _BsPantallaState();
}

class _BsPantallaState extends State<BsPantalla> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Buenos días pantalla'),
      ),
    );
  }
}