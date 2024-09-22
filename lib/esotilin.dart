import 'package:flutter/material.dart';

class Tilinaso extends StatelessWidget {
  const Tilinaso({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("El pepe :v", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: Colors.black12)),
          ),
          Icon(Icons.accessibility_new, size: 30, color: Colors.black26)
        ],
      ),
    );
  }
}