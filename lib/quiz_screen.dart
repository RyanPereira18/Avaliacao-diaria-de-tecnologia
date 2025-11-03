// lib/quiz_screen.dart

import 'package:flutter/material.dart';
import 'questions_data.dart'; // Importa nossa lista de perguntas
import 'result_screen.dart'; // --- IMPORTA A NOVA TELA ---

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  late List<int?> _selectedAnswers;
  // int _score = 0; // Não precisamos mais calcular o score aqui

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int?>.filled(questions.length, null);
  }

  void _answerQuestion(int? value) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = value;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma resposta.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  // --- FUNÇÃO FINALIZAR QUIZ (ATUALIZADA) ---
  void _finishQuiz() {
    // Verifica a resposta da última pergunta
    if (_selectedAnswers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma resposta.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navega para a tela de resultados
    // Usamos pushReplacement para que o usuário não possa "voltar" para o quiz
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ResultScreen(
          questions: questions,
          userAnswers: _selectedAnswers,
        ),
      ),
    );
  }
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Quiz: Pergunta ${_currentQuestionIndex + 1} de ${questions.length}'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.questionText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ...List.generate(currentQuestion.options.length, (index) {
              return RadioListTile<int>(
                title: Text(currentQuestion.options[index]),
                value: index,
                groupValue: _selectedAnswers[_currentQuestionIndex],
                onChanged: _answerQuestion,
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _currentQuestionIndex < questions.length - 1
                    ? _nextQuestion
                    : _finishQuiz, // Chama a nova função _finishQuiz
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                child: Text(
                  _currentQuestionIndex < questions.length - 1
                      ? 'Próxima Pergunta'
                      : 'Finalizar Quiz',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
