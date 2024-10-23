import 'package:flutter/material.dart';

class ErrorPayment extends StatelessWidget {
  const ErrorPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black, // Fondo negro
      title: const Text(
        'Error',
        style: TextStyle(color: Colors.white), // Título blanco
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            'https://i.pinimg.com/enabled_hi/564x/01/0c/14/010c149fb7d9c04a49e64fa8a9a77adb.jpg',
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            'Ha ocurrido un error en el procesamiento del pago.',
            style: TextStyle(color: Colors.white), // Texto en blanco
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Center( // Centra el botón
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red, // Fondo del botón rojo
            ),
            child: const Text(
              'Volver',
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
          ),
        ),
      ],
    );
  }
}
