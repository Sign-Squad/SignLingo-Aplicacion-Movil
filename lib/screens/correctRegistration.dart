import 'package:flutter/material.dart';

class CorrectRegistration extends StatelessWidget {
  const CorrectRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black, // Fondo negro
      title: const Text(
        'SignLingo',
        style: TextStyle(color: Colors.white), // Título blanco
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            'https://depor.com/resizer/INa4a6_3QqdktbS0EKSwpq8GfM0=/620x0/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/DFWEOWHCQZAMRNH7ALRFQYVPTU.jpg',
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            'Tu cuenta ha sido creada correctamente.',
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
              backgroundColor: Colors.green, // Fondo del botón verde
            ),
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
          ),
        ),
      ],
    );
  }
}
