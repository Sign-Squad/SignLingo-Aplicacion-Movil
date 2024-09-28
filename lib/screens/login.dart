import 'dart:convert'; // Para JSON encode/decode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP
import 'package:shared_preferences/shared_preferences.dart'; // Para almacenar el token
import 'package:flutter_application_1/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userNameController = TextEditingController();

  bool _isRegistering = false; // Controla si se está registrando o iniciando sesión
  bool _termsAccepted = false; // Controla si el checkbox de términos está marcado
  bool _isLoading = false; // Para mostrar el indicador de carga mientras se realiza el login o registro
  String? _token; // Almacenar el token para mostrarlo

  // Función para validar el email
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Por favor ingrese su correo';
    } else if (!email.contains('@')) {
      return 'Correo inválido, falta @';
    }
    return null;
  }

  // Función para validar la contraseña
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Por favor ingrese su contraseña';
    } else if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Función para validar la confirmación de la contraseña
  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Por favor confirme su contraseña';
    } else if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // Método para manejar el login
  Future<void> _handleLogin() async {
    String username = _userNameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Muestra el indicador de carga
    });

    try {
      var url = Uri.parse('https://signlingo-backend.onrender.com/auth/login');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['token'];

        // Guardar el token en almacenamiento local
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Almacenar el token en la variable de estado para mostrarlo
        setState(() {
          _token = token;
          _isLoading = false; // Detener el indicador de carga
        });

        // Redirigir al HomePage después de 5 segundos
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      } else {
        // Mostrar el mensaje de error con detalles del servidor
        debugPrint('Error de autenticación: ${response.body}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: ${response.body}')),
        );
      }
    } catch (error) {
      // Manejar errores de conexión y mostrar el error en consola
      debugPrint('Error al conectar con el servidor: $error');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Ocultar el indicador de carga
      });
    }
  }

  // Método para manejar el envío del formulario
  void _handleFormSubmission() {
    String? emailError = _validateEmail(_emailController.text);
    String? passwordError = _validatePassword(_passwordController.text);

    if (_isRegistering) {
      String? confirmPasswordError = _validateConfirmPassword(
          _passwordController.text, _confirmPasswordController.text);

      if (_userNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingrese su nombre de usuario')),
        );
      } else if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe aceptar los términos y condiciones')),
        );
      } else if (emailError != null || passwordError != null || confirmPasswordError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(emailError ?? passwordError ?? confirmPasswordError!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
      }
    } else {
      if (emailError != null || passwordError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(emailError ?? passwordError!)),
        );
      } else {
        _handleLogin(); // Realizar el login
      }
    }
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

            // Mostrar el token si está disponible
            if (_token != null)
              Text(
                'Token: $_token',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),

            const SizedBox(height: 16),

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
            _buildTextField(
              controller: _userNameController,
              hintText: _isRegistering
                  ? 'Ingrese su nombre de usuario'
                  : 'Ingrese su usuario',
              icon: Icons.person,
              obscureText: false,
            ),

            // Email Field (Solo para registro)
            if (_isRegistering)
              _buildTextField(
                controller: _emailController,
                hintText: 'Ingrese su correo electrónico',
                icon: Icons.email,
                obscureText: false,
              ),

            // Password Field
            _buildTextField(
              controller: _passwordController,
              hintText: 'Ingrese su contraseña',
              icon: Icons.lock,
              obscureText: true,
            ),

            // Confirm Password Field (solo para registro)
            if (_isRegistering)
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirme su contraseña',
                icon: Icons.lock_outline,
                obscureText: true,
              ),

            // Terms and Conditions (solo para registro)
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
                    'Acepto los términos y condiciones',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Create or Login Button
            ElevatedButton(
              onPressed: () {
                if (_isRegistering) {
                  _handleFormSubmission(); // Llama a _handleFormSubmission si está registrando
                } else {
                  _handleLogin(); // Llama a _handleLogin si no está registrando
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF323232), // Color del botón
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
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
}
