import 'package:flutter/material.dart';
import 'quiz_question_model.dart'; // Importa o modelo das perguntas

class ResultScreen extends StatelessWidget {
  final List<int?> userAnswers;
  final List<QuizQuestion> questions;

  const ResultScreen({
    super.key,
    required this.userAnswers,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctOptionIndex) {
        score++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado: $score de ${questions.length} acertos'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        // Botão para voltar para a tela inicial (HomeScreen)
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Fecha a tela de resultados e a tela do quiz, voltando para a home
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final userAnswerIndex = userAnswers[index];
          final bool isCorrect =
              userAnswerIndex == question.correctOptionIndex;

          final String userAnswerText = userAnswerIndex != null
              ? question.options[userAnswerIndex]
              : 'Não respondida';
          
          final String correctAnswerText =
              question.options[question.correctOptionIndex];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              // Ícone de Certo ou Errado
              leading: Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 30,
              ),
              // Pergunta
              title: Text(
                '${index + 1}. ${question.questionText}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // Respostas (a do usuário e a correta)
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sua resposta: $userAnswerText',
                      style: TextStyle(
                        color: isCorrect ? Colors.black87 : Colors.red,
                        fontWeight: isCorrect ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    if (!isCorrect) // Só mostra a correta se o usuário errou
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Resposta correta: $correctAnswerText',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

