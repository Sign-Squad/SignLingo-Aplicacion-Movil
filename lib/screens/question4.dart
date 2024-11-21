import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'detect-image.dart';
import 'navigateToQuestion.dart';
import 'playSound.dart';

class QuestionType4 extends StatefulWidget {
  final List<dynamic> questions; // Lista de preguntas
  final int questionIndex; // Índice de la pregunta actual

  const QuestionType4({
    Key? key,
    required this.questions,
    required this.questionIndex,
  }) : super(key: key);

  @override
  _QuestionType4State createState() => _QuestionType4State();
}

class _QuestionType4State extends State<QuestionType4> {
  XFile? _imageFile; // Foto capturada
  final ImagePicker _picker = ImagePicker();
  String _detectedClass = ''; // Clase detectada por el servidor

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });

      // Llamar a la función para cargar la imagen al servidor
      final detectedClass = await uploadImage(File(_imageFile!.path));
      if (detectedClass != null) {
        setState(() {
          _detectedClass = detectedClass;
        });
      }
    }
  }

  Future<void> _validateAndContinue() async {
    final currentQuestion = widget.questions[widget.questionIndex];
    final String correctAnswer = currentQuestion['correctAnswer']?['textContent'] ?? '';

    if (_detectedClass == correctAnswer) {
      // Respuesta correcta
      await playSound('sounds/correct.mp3'); // Reproduce sonido de éxito
      await _showDialog(
        title: 'Respuesta Correcta',
        color: Colors.green,
        buttonText: 'Continuar',
        onPressed: _goToNextQuestion,
      );
    } else {
      // Respuesta incorrecta
      await playSound('sounds/incorrect.mp3'); // Reproduce sonido de error
      await _showDialog(
        title: 'Respuesta Incorrecta',
        color: Colors.red,
        buttonText: 'Volver a Intentar',
        onPressed: Navigator.of(context).pop, // Cierra el diálogo
      );
    }
  }

  Future<void> _showDialog({
    required String title,
    required Color color,
    required String buttonText,
    required VoidCallback onPressed,
  }) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText),
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToNextQuestion() {
    if (widget.questionIndex + 1 < widget.questions.length) {
      Navigator.pop(context); // Cierra el diálogo actual
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
        title: const Text(
          '¿Seguro que quieres terminar tu lección?',
          style: TextStyle(color: Colors.white),
        ),
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
    final String title = currentQuestion['title'] ?? 'Pregunta sin título';
    final String imageUrl = currentQuestion['correctAnswer']?['imageUrl'] ?? '';

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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Imagen de correctAnswer
              imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey,
                  child: const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.black45,
                  ),
                ),
              )
                  : Container(
                width: 200,
                height: 200,
                color: Colors.grey,
                child: const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.black45,
                ),
              ),
              const Spacer(),
              // Imagen capturada
              _imageFile == null
                  ? Container(
                width: 200,
                height: 200,
                color: Colors.grey,
                child: const Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: Colors.black45,
                ),
              )
                  : Image.file(
                File(_imageFile!.path),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
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
                onPressed: _validateAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF323232),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _goToNextQuestion, // Ir a la siguiente pregunta
                child: const Text(
                  'Omitir',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
