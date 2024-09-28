import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isRegistering = false; // Controla si se está registrando o iniciando sesión
  bool _termsAccepted = false; // Controla si el checkbox de términos está marcado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF248E5C), // Fondo verde
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/sign-lingo-logo.png', height: 50), // Reemplazar con la ruta del logo
                const SizedBox(width: 8),
                const Text(
                  'SignLingo',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Toggle Login/Register Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('Iniciar sesión', !_isRegistering),
                _buildToggleButton('Registrarse', _isRegistering),
              ],
            ),
            const SizedBox(height: 16),

            // User Name Field (Only show when registering)
            if (_isRegistering)
              _buildTextField(
                hintText: 'Enter user name',
                icon: Icons.person,
                obscureText: true,
              ),

            // Email Field
            _buildTextField(
              hintText: 'Enter email',
              icon: Icons.email,
              obscureText: true,
            ),

            // Password Field
            _buildTextField(
              hintText: 'Enter password',
              icon: Icons.lock,
              obscureText: true,
            ),

            // Terms and Conditions (only for register)
            if (_isRegistering)
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted, // Valor del estado actual del checkbox
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false; // Actualiza el estado del checkbox
                      });
                    },
                  ),
                  const Text(
                    'I accept all the Terms and Conditions',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Create or Login Button
            ElevatedButton(
              onPressed: () {
                if (_isRegistering && !_termsAccepted) {
                  // Muestra un mensaje de error si el usuario no aceptó los términos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You must accept the terms and conditions'),
                    ),
                  );
                } else {
                  // Maneja la acción de crear cuenta o iniciar sesión
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF323232), // Color del botón
              ),
              child: Text(
                _isRegistering ? 'Crear' : 'Iniciar sesión',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isRegistering = (text == 'Registrarse');
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}