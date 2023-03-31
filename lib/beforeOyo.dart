import 'package:flutter/material.dart';

class beforeOyo extends StatefulWidget {
  const beforeOyo({Key? key}) : super(key: key);

  @override
  State<beforeOyo> createState() => _beforeOyoState();
}

class _beforeOyoState extends State<beforeOyo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/exerciseimage.png"),
    );
  }
}
