import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.settings,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Acción de configuración
          },
        ),
        actions: [
          Row(
            children: [
              const Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.favorite,
                size: 30,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centrar el logo y el texto
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/sign-lingo-logo.png',
                    height: 80,
                  ),
                  const Text(
                    'SignLingo',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Unidad Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1e8f59),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Unidad 1\nIntroduccion de Señas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // First Lesson - Introducción
            _buildLessonStep(
              icon: Icons.book,
              title: 'Introducción',
              iconColor: Colors.greenAccent,
              position: 1, // Casi a la izquierda
            ),
            const SizedBox(height: 50),

            _buildLessonStep(
              icon: Icons.abc,
              title: 'Abecedario 1',
              iconColor: Colors.greenAccent,
              position: 3, // Un poco más a la izquierda
            ),
            const SizedBox(height: 50),

            _buildLessonStep(
              icon: Icons.numbers_outlined,
              title: 'Numeros 1',
              iconColor: Colors.greenAccent,
              position: 7, // Un poco más a la derecha
            ),
          ],
        ),
      ),
    );
  }

  // Widget para cada lección con la nueva propiedad 'position'
  Widget _buildLessonStep({
    required IconData icon,
    required String title,
    required Color iconColor,
    required int position, // Posición entre 1 (izquierda), 5 (centro), 9 (derecha)
  }) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: _getPositionAlignment(position),
            child: Column(
              children: [
                // Icono circular
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor,
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Función para obtener la alineación en función de la posición
  Alignment _getPositionAlignment(int position) {
    // La posición va de 1 (muy a la izquierda) a 9 (muy a la derecha)
    // Mapeamos de 1-9 a -1.0 (izquierda) a 1.0 (derecha)
    double alignmentX = (position - 5) / 4;
    return Alignment(alignmentX, 0);  // Sólo manipulamos el eje X
  }
}
