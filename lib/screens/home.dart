import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
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
        child: SingleChildScrollView(
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

              // Construir las unidades y lecciones dinámicamente desde el JSON
              ..._buildContentFromData(),
            ],
          ),
        ),
      ),
    );
  }

  // Datos de las unidades
  List<Map<String, dynamic>> _getUnitsData() {
    return [
      {
        "id": 1,
        "sectionName": "Abecedario",
        "description": "Aprenderás el abecedario en lenguaje de señas"
      },
      {
        "id": 2,
        "sectionName": "Saludos",
        "description": "Aprenderás a saludar en lenguaje de señas"
      },
    ];
  }

  // Función que retorna los datos de las lecciones como un JSON interno
  List<Map<String, dynamic>> _getLessonsData() {
    return [
      {
        'icon': 'book',
        'title': 'Introducción',
        'position': 1,
        'SectionID': 1,
      },
      {
        'icon': 'abc',
        'title': 'Abecedario 1',
        'position': 3,
        'SectionID': 1,
      },
      {
        'icon': 'numbers_outlined',
        'title': 'Números 1',
        'position': 7,
        'SectionID': 2,
      },
      {
        'icon': 'numbers_outlined',
        'title': 'Números 2',
        'SectionID': 2, // sin 'position', debe centrarse automáticamente
      },
      {
        'icon': 'bookmark',
        'title': 'Resumen',
        'SectionID': 1, // sin 'position', debe centrarse automáticamente
      },
    ];
  }

  // Combina unidades y lecciones
  List<Widget> _buildContentFromData() {
    var unitsData = _getUnitsData();
    var lessonsData = _getLessonsData();

    return unitsData.map((unit) {
      // Crear el widget para la unidad
      List<Widget> content = [
        _buildUnit(
          sectionName: unit['sectionName'],
          description: unit['description'],
        ),
        const SizedBox(height: 16),
      ];

      // Agregar lecciones correspondientes a esta unidad
      var filteredLessons = lessonsData.where((lesson) => lesson['SectionID'] == unit['id']).toList();
      content.addAll(filteredLessons.map((lesson) {
        return _buildLessonStep(
          icon: _getIconFromString(lesson['icon']),
          title: lesson['title'],
          iconColor: const Color(0xFFBCEFB3),
          position: lesson['position'] ?? 5,
        );
      }).toList());

      // Separar cada unidad
      content.add(const SizedBox(height: 24));

      return Column(children: content);
    }).toList();
  }

  // Widget para cada unidad
  Widget _buildUnit({
    required String sectionName,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e8f59),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para cada lección con la propiedad 'position'
  Widget _buildLessonStep({
    required IconData icon,
    required String title,
    required Color iconColor,
    required int position,
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
    double alignmentX = (position - 5) / 4;
    return Alignment(alignmentX, 0);
  }

  // Optimización de _getIconFromString usando un mapa para evitar múltiples casos
  IconData _getIconFromString(String iconStr) {
    Map<String, IconData> iconMap = {
      'book': Icons.book,
      'abc': Icons.abc,
      'numbers_outlined': Icons.numbers_outlined,
      'bookmark': Icons.bookmark,
    };
    return iconMap[iconStr] ?? Icons.help;
  }
}
