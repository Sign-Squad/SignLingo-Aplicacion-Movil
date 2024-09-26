import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home",
      theme: ThemeData(
          primarySwatch: Colors.blueGrey
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _Home createState() => _Home();
}

class _Home extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}