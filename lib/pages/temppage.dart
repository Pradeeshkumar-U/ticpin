import 'package:flutter/material.dart';

class Temppage extends StatefulWidget {
  const Temppage({super.key});

  @override
  State<Temppage> createState() => _TemppageState();
}

class _TemppageState extends State<Temppage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Hello there')));
  }
}
