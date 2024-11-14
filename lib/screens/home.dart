import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'levelsPage.dart'; // Importar la nueva pantalla LevelsPage
import 'configuration.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _unitsData = [];
  bool _isLoading = true; // Mostrar indicador de carga mientras se obtienen los datos

  @override
  void initState() {
    super.initState();
    _fetchSectionsData(); // Llamar a la API para obtener las secciones
  }

  // Función para obtener el token y llamar al API
  Future<void> _fetchSectionsData() async {
    try {
      // Obtener el token guardado durante el login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // Realizar la solicitud GET al endpoint con el Bearer Token
        var url = Uri.parse('http://10.0.2.2:8080/api/v1/sections');
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
            _unitsData = data.map((section) {
              return {
                'id': section['id'],
                'sectionName': section['sectionName'],
                'description': section['description'],
              };
            }).toList();
            _isLoading = false; // Detener el indicador de carga
          });
        } else {
          debugPrint('Error al obtener secciones: ${response.body}');
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigurationPage()));
          },
        ),
        actions: const [
          Row(
            children: [
              Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.favorite,
                size: 30,
                color: Colors.red,
              ),
              SizedBox(width: 8),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // Mostrar indicador de carga
            : SingleChildScrollView(
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

              // Mostrar las unidades obtenidas de la API
              ..._buildContentFromData(),
            ],
          ),
        ),
      ),
    );
  }

  // Construir las unidades desde los datos obtenidos de la API
  List<Widget> _buildContentFromData() {
    return _unitsData.map((unit) {
      // Crear el widget para la unidad
      return Column(
        children: [
          _buildUnit(
            sectionName: unit['sectionName'],
            description: unit['description'],
            id: unit['id']
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 24),
        ],
      );
    }).toList();
  }

  // Widget para cada unidad
  Widget _buildUnit({
    required String sectionName,
    required String description,
    required int id
  }) {
    return GestureDetector(
      onTap: () {
        // Navegar a la nueva pantalla LevelsPage con los detalles de la sección
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelsPage(
              sectionName: sectionName,
              description: description,
              sectionId: id,

            ),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
