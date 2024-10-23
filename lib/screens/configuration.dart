import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/membership.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedLanguage = 'Español'; // Idioma seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
         'Configuraciones',
         style: TextStyle(
         color: Colors.white,
         fontSize: 30,
         fontWeight: FontWeight.bold),
         ),
        centerTitle: true,
        backgroundColor: Colors.black,
       ),

      backgroundColor: Colors.black, // Fondo negro
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Usuario',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto blanco
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _userController,
              style: const TextStyle(color: Colors.white,fontSize : 18,), // Texto de entrada blanco
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese su nombre de usuario',
                hintStyle: const TextStyle(color: Colors.white), // Texto del hint en blanco suave
                filled: true,
                fillColor: Colors.grey[800], // Fondo de la caja de texto gris oscuro
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Idioma',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto blanco
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              dropdownColor: Colors.grey[800], // Color del dropdown gris oscuro
              style: const TextStyle(color: Colors.white, fontSize: 18), // Texto blanco en el menú
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: <String>['Español', 'Inglés']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[800], // Fondo de la caja desplegable gris oscuro
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Correo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto blanco
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white), // Texto de entrada blanco
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese su correo electrónico',
                hintStyle: const TextStyle(color: Colors.white,fontSize : 18, ), // Texto del hint en blanco suave
                filled: true,
                fillColor: Colors.grey[800], // Fondo de la caja de texto gris oscuro
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contraseña',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto blanco
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible, // Controla la visibilidad de la contraseña
              style: const TextStyle(color: Colors.white), // Texto de entrada blanco
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese su contraseña',
                hintStyle: const TextStyle(color: Colors.white,fontSize : 18,), // Texto del hint en blanco suave
                filled: true,
                fillColor: Colors.grey[800], // Fondo de la caja de texto gris oscuro
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white, // Icono blanco
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Botón de Comprar Membresía
            ElevatedButton.icon(
              onPressed: () {
                 Navigator.push(
                  context,
                 MaterialPageRoute(builder: (context) => const MembershipPage()),
                );
              },
              icon: const Icon(Icons.star, color: Colors.yellow),
              label: const Text(
                'Comprar Membresía',
                style: TextStyle(fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color del botón
                minimumSize: const Size(double.infinity, 50), // Tamaño
              ),
            ),
            const SizedBox(height: 20),
            // Botón de Guardar Cambios
            ElevatedButton(
              onPressed: () {
                // Acción para guardar cambios
              },
              child: const Text(
                'Guardar Cambios',
                style: TextStyle(fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Color del botón
                minimumSize: const Size(double.infinity, 50), // Tamaño
              ),
            ),
            const SizedBox(height: 20),
            // Botón de Cerrar Sesión
            ElevatedButton(
              onPressed: () {
                // Acción para cerrar sesión
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color del botón
                minimumSize: const Size(double.infinity, 50), // Tamaño
              ),
            ),
          ],
        ),
      ),
    );
  }
}
