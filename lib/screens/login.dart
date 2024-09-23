import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isRegistering = false; // Controla si se está registrando o iniciando sesión

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e8f59), // Fondo verde
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo_hands.png', height: 50), // Reemplazar con la ruta del logo
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
              ),

            // Email Field
            _buildTextField(
              hintText: 'Enter email',
              icon: Icons.email,
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
                    value: false, // Set this to a state variable in a real app
                    onChanged: (value) {},
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
                // Handle create/login action
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                _isRegistering ? 'Crear' : 'Iniciar sesión',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // Social Login Options
            const Text(
              'o con',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon('assets/google_icon.png'),
                _buildSocialIcon('assets/facebook_icon.png'),
                _buildSocialIcon('assets/apple_icon.png'),
              ],
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

  Widget _buildSocialIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          // Handle social login
        },
        child: Image.asset(
          assetPath,
          height: 40,
        ),
      ),
    );
  }
}
