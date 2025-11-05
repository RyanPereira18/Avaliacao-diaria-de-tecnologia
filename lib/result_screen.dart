import 'package:flutter/material.dart';
import 'quiz_question_model.dart';
import 'review_screen.dart'; 

class ResultScreen extends StatelessWidget {
  final List<QuizQuestion> questions;
  final List<int?> userAnswers;

  const ResultScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  int _calculateCorrectAnswers() {
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctOptionIndex) {
        correctCount++;
      }
    }
    return correctCount;
  }

  @override
  Widget build(BuildContext context) {
    final int correctAnswersCount = _calculateCorrectAnswers();
    final int totalQuestions = questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado do Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Parabéns!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Você acertou',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '$correctAnswersCount / $totalQuestions',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.reviews),
                label: const Text('Mostrar Respostas'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        userAnswers: userAnswers,
                      ),
                    ),
                  );
                },
              ),
              // --------------------

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}