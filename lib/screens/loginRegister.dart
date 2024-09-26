import 'package:flutter/material.dart';
import 'package:signlingo_aplicacion_movil/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LoginRegister",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: const LoginRegister(),
    );
  }
}

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  _LoginRegisterPage createState() => _LoginRegisterPage();
}

class _LoginRegisterPage extends State<LoginRegister>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if(email != "" && password != "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Welcome"))
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("SignLingo")),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16.0),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder()
              ),
            ),

            const SizedBox(height: 24.0,),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login")
            )

          ],
        ),
      )
    );
  }
}
