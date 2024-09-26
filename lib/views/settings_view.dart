import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late Future<Map<String, dynamic>> userData;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    userData = apiService.fetchUserData(); // Llamar a la API al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('ID: ${user['id']}'),
                  Text('Username: ${user['username']}'),
                  Text('Email: ${user['email']}'),
                  Text('Vidas: ${user['lives']}'),
                  Text('Progreso: ${user['progress']}'),
                  Text('Es VIP: ${user['isVip']}'),
                  Text('Eliminar anuncios: ${user['removeAds']}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}