import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'navigateToQuestion.dart';


class QuestionType3 extends StatefulWidget {
  final List<dynamic> questions; // Lista de preguntas
  final int questionIndex; // Índice de la pregunta actual

  const QuestionType3({
    Key? key,
    required this.questions,
    required this.questionIndex,
  }) : super(key: key);

  @override
  _QuestionType3State createState() => _QuestionType3State();
}

class _QuestionType3State extends State<QuestionType3> {
  XFile? _imageFile; // Foto capturada
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _goToNextQuestion() {
    if (widget.questionIndex + 1 < widget.questions.length) {
      navigateToQuestion(context, widget.questions, widget.questionIndex + 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Has completado todas las preguntas')),
      );
      Navigator.popUntil(context, (route) => route.isFirst); // Regresa al inicio
    }
  }


  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('¿Seguro que quieres terminar tu lección?',
          style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Confirmar salida
            },
            child: const Text(
              'Sí, salir',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false); // Cancelar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1e8f59),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ) ??
        false; // Por defecto no salir
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[widget.questionIndex];

    return WillPopScope(
      onWillPop: _onWillPop, // Manejo de botón de retroceso
      child: Scaffold(
        backgroundColor: const Color(0xFF181818),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
            onPressed: () async {
              bool shouldExit = await _onWillPop();
              if (shouldExit) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.favorite, size: 30, color: Colors.red),
                ],
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                currentQuestion['title'] ?? 'Pregunta sin título',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _imageFile == null
                  ? Container(
                width: 200,
                height: 200,
                color: Colors.grey,
                child: const Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.black45,
                ),
              )
                  : Image.file(
                File(_imageFile!.path),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _takePhoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1e8f59),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Tomar Foto',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToNextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF323232),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Omitir',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
