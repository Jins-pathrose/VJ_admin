import 'package:flutter/material.dart';

class Studentscreen extends StatefulWidget {
  const Studentscreen({super.key});

  @override
  State<Studentscreen> createState() => _StudentscreenState();
}

class _StudentscreenState extends State<Studentscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Students Screen'),),
    );
  }
}