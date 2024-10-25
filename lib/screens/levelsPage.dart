import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LevelsPage extends StatefulWidget {
  final String sectionName;
  final String description;
  final int sectionId; // Agregamos el ID de la sección

  const LevelsPage({
    Key? key,
    required this.sectionName,
    required this.description,
    required this.sectionId, // Pasamos el ID de la sección
  }) : super(key: key);

  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  List<Map<String, dynamic>> _levelsData = [];
  bool _isLoading = true; // Mostrar indicador de carga mientras se obtienen los datos

  @override
  void initState() {
    super.initState();
    _fetchLevelsData(); // Llamar a la API para obtener los niveles
  }

  // Función para obtener los niveles de la API
  Future<void> _fetchLevelsData() async {
    try {
      // Obtener el token guardado durante el login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // Realizar la solicitud GET al endpoint con el Bearer Token
        var url = Uri.parse('http://10.0.2.2:8080/api/v1/levels/section/${widget.sectionId}');
        var response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          // Decodificar los datos JSON recibidos
          var data = jsonDecode(response.body) as List;
          setState(() {
            _levelsData = data.map((level) {
              return {
                'id': level['id'],
                'levelName': level['levelName'],
                'iconUrl': level['iconUrl'],
                'position': level['position'],
                'totalQuestions': level['totalQuestions'],
              };
            }).toList();
            _isLoading = false; // Detener el indicador de carga
          });
        } else {
          debugPrint('Error al obtener niveles: ${response.body}');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        debugPrint('Token no encontrado');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      debugPrint('Error al conectar con el servidor: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818), // Mismo fondo que HomePage
      appBar: AppBar(
        title: Text(widget.sectionName, style: const TextStyle(color: Colors.white)), // Texto en blanco
        backgroundColor: Colors.transparent, // Fondo transparente
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Cambiar color de la flecha de retroceso
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/sign-lingo-logo.png', // Asegúrate de que la imagen esté disponible
                    height: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.sectionName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Mostrar la lista de niveles
            _isLoading
                ? const Center(child: CircularProgressIndicator()) // Indicador de carga
                : Expanded(
              child: ListView.builder(
                itemCount: _levelsData.length,
                itemBuilder: (context, index) {
                  var level = _levelsData[index];
                  return _buildLevelCard(
                    levelName: level['levelName'],
                    totalQuestions: level['totalQuestions'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para cada nivel
  Widget _buildLevelCard({
    required String levelName,
    required int totalQuestions,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16), // Espaciado entre niveles
      decoration: BoxDecoration(
        color: const Color(0xFF1e8f59),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nivel $levelName',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalQuestions preguntas',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
