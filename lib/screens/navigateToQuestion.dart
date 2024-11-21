import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/question3.dart';
import 'package:flutter_application_1/screens/question4.dart';

void navigateToQuestion(BuildContext context, List<dynamic> questions, int questionIndex) {
  final currentQuestion = questions[questionIndex];
  final String questionType = currentQuestion['questionType'] ?? '';

  if (questionType == 'pregunta-tipo3') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionType3(
          questions: questions,
          questionIndex: questionIndex,
        ),
      ),
    );
  } else if (questionType == 'pregunta-tipo4') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionType4(
          questions: questions,
          questionIndex: questionIndex,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tipo de pregunta desconocido: $questionType')),
    );
  }
}
