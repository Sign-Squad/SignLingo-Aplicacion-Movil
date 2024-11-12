import 'package:flutter/material.dart';

class CorrectPayment extends StatelessWidget {
  const CorrectPayment({super.key});

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
            'https://img.freepik.com/fotos-premium/me-gusta-o-simbolo-correcto-boton-confirmado-o-aprobado-icono-marca-verificacion-ilustracion-3d_90099-1536.jpg',
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          const Text(
            'Tu pago ha sido procesado correctamente.',
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
