import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {
  final List<double> progress = List.generate(10, (index) => (index + 1) * 10.0); // Progreso ficticio

  ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: progress.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Lección ${index + 1}"),
          trailing: Text("${progress[index]}%"),
        );
      },
    );
  }
}
