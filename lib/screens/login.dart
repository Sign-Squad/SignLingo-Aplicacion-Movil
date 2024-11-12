import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'registerPage.dart'; // Importa la ventana de registro

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    String username = _userNameController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      var loginUrl = Uri.parse('https://signlingo-backend.onrender.com/auth/login');
      var loginResponse = await http.post(
        loginUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (loginResponse.statusCode == 200) {
        var loginData = jsonDecode(loginResponse.body);
        String token = loginData['token'];

        var userUrl = Uri.parse('https://signlingo-backend.onrender.com/api/v1/users/username/$username');
        var userResponse = await http.get(
          userUrl,
          headers: {"Authorization": "Bearer $token"},
        );

        if (userResponse.statusCode == 200) {
          var userData = jsonDecode(userResponse.body);
          String userId = userData['id'].toString();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('userId', userId);
          await prefs.setString('username', username);

          setState(() {
            _isLoading = false;
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          _showError('Error al obtener ID de usuario');
        }
      } else {
        _showError('Error de autenticación');
      }
    } catch (error) {
      _showError('Error al conectar con el servidor');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF248E5C), // Fondo verde
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/sign-lingo-logo.png', height: 50),
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
            _buildTextField(
              controller: _userNameController,
              hintText: 'Ingrese su usuario',
              icon: Icons.person,
            ),
            _buildTextField(
              controller: _passwordController,
              hintText: 'Ingrese su contraseña',
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF323232),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey, // Color plomo
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Registro',
                style: TextStyle(fontSize: 18, color: Colors.white), // Letras blancas
              ),
            ),
          ],
        ),
      ),
    );
  }
}
