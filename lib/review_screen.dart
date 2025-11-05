import 'package:flutter/material.dart';
import 'questions_data.dart';

class ReviewScreen extends StatefulWidget {
  final List<int?> userAnswers;

  const ReviewScreen({
    super.key,
    required this.userAnswers,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _currentQuestionIndex = 0;
  void _nextOrFinish() {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[_currentQuestionIndex];
    final userAnswerIndex = widget.userAnswers[_currentQuestionIndex];
    final correctAnswerIndex = question.correctOptionIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Revisão: Pergunta ${_currentQuestionIndex + 1} de ${questions.length}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...question.options.asMap().entries.map((entry) {
              int optionIndex = entry.key;
              String optionText = entry.value;

              Color? tileColor;
              Color? iconColor;
              IconData? leadingIcon;

              if (optionIndex == correctAnswerIndex) {
                tileColor = Colors.green.withAlpha(50);
                iconColor = Colors.green;
                leadingIcon = Icons.check_circle;
              } else if (optionIndex == userAnswerIndex) {
                tileColor = Colors.red.withAlpha(50);
                iconColor = Colors.red;
                leadingIcon = Icons.cancel;
              } else {
                tileColor = null;
                iconColor = Colors.grey.shade600;
                leadingIcon = Icons.radio_button_unchecked;
              }

              return Card(
                elevation: 0,
                color: tileColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: tileColor == null
                        ? Colors.grey.shade300
                        : Colors.transparent,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Icon(leadingIcon, color: iconColor),
                  title: Text(
                    optionText,
                    style: TextStyle(
                      fontWeight: (optionIndex == correctAnswerIndex ||
                              optionIndex == userAnswerIndex)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            Card(
              elevation: 0,
              color: Colors.blueGrey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blueGrey.shade100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explicação:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.explanation,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.blueGrey.shade700,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _nextOrFinish,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _currentQuestionIndex == questions.length - 1
                    ? 'Finalizar Revisão'
                    : 'Próxima',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}