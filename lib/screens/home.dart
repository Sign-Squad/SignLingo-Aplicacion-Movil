import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'configuration.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _unitsData = [];
  Map<int, List<Map<String, dynamic>>> _levelsBySection = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSectionsData(); // Llamar a la API para obtener secciones
  }

  Future<void> _fetchSectionsData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        debugPrint("Token no encontrado.");
        setState(() => _isLoading = false);
        return;
      }

      var sectionsUrl = Uri.parse('http://10.0.2.2:8080/api/v1/sections');
      var sectionsResponse = await http.get(
        sectionsUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (sectionsResponse.statusCode == 200) {
        var sectionsData = jsonDecode(sectionsResponse.body) as List;

        setState(() {
          _unitsData = sectionsData.map((section) {
            return {
              'id': section['id'],
              'sectionName': section['sectionName'],
              'description': section['description'],
            };
          }).toList();
        });

        // Fetch levels for each section
        for (var section in _unitsData) {
          await _fetchLevelsForSection(section['id'], token);
        }
      } else {
        debugPrint('Error al obtener secciones: ${sectionsResponse.body}');
      }
    } catch (error) {
      debugPrint('Error al conectar con el servidor: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchLevelsForSection(int sectionId, String token) async {
    try {
      var levelsUrl = Uri.parse('http://10.0.2.2:8080/api/v1/levels/section/$sectionId');
      var levelsResponse = await http.get(
        levelsUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (levelsResponse.statusCode == 200) {
        var levelsData = jsonDecode(levelsResponse.body) as List;

        setState(() {
          _levelsBySection[sectionId] = levelsData.map((level) {
            return {
              'id': level['id'],
              'levelName': level['levelName'],
              'iconUrl': level['iconUrl'],
              'position': level['position'] ?? 5,
              'totalQuestions': level['totalQuestions'],
            };
          }).toList();
        });
      } else {
        debugPrint('Error al obtener niveles para la sección $sectionId: ${levelsResponse.body}');
      }
    } catch (error) {
      debugPrint('Error al conectar con el servidor para niveles: $error');
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
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ..._buildContentFromData(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentFromData() {
    return _unitsData.map((unit) {
      var sectionId = unit['id'];
      var levels = _levelsBySection[sectionId] ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUnit(
            sectionName: unit['sectionName'],
            description: unit['description'],
          ),
          const SizedBox(height: 16),
          if (levels.isNotEmpty) _buildLessonsColumn(levels),
          const SizedBox(height: 24),
        ],
      );
    }).toList();
  }

  Widget _buildUnit({required String sectionName, required String description}) {
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

  Widget _buildLessonsColumn(List<Map<String, dynamic>> lessons) {
    lessons.sort((a, b) => a['position'].compareTo(b['position'])); // Ordenar por posición

    return Column(
      children: lessons.map((lesson) {
        return _buildLessonStep(
          iconUrl: lesson['iconUrl'],
          title: lesson['levelName'],
          position: lesson['position'],
        );
      }).toList(),
    );
  }

  Widget _buildLessonStep({required String iconUrl, required String title, required int position}) {
    // Escala el valor de posición más al centro
    double alignmentX = (position - 5) / 6; // Rango más controlado de -1 a 1

    return Align(
      alignment: Alignment(alignmentX, 0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFBCEFB3),
            ),
            child: Icon(
              _getIconFromString(iconUrl),
              size: 30,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconFromString(String iconStr) {
    Map<String, IconData> iconMap = {
      'bookmark': Icons.bookmark,
      'book': Icons.book,
      'abc': Icons.abc,
      'numbers_outlined': Icons.numbers_outlined,
    };
    return iconMap[iconStr] ?? Icons.help;
  }
}
