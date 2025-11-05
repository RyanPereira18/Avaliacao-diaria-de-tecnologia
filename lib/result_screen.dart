import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa Supabase
import 'quiz_question_model.dart';
import 'review_screen.dart';
import 'main.dart'; // Importa o atalho 'supabase'

class ResultScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final List<int?> userAnswers;

  const ResultScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _correctAnswersCount = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _calculateAndSaveResult();
  }

  Future<void> _calculateAndSaveResult() async {
    setState(() { _isSaving = true; });

    int correctCount = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.userAnswers[i] == widget.questions[i].correctOptionIndex) {
        correctCount++;
      }
    }
    setState(() {
      _correctAnswersCount = correctCount;
    });

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      setState(() { _isSaving = false; });
      return;
    }

    final quizResultData = {
      'user_id': userId,
      'score': _correctAnswersCount,
      'total_questions': widget.questions.length,
      'answers': widget.userAnswers,
    };

    try {
      await supabase.from('resultados_quiz').insert(quizResultData);
    } on PostgrestException catch (e) {
      // ****** CORREÇÃO 1 APLICADA AQUI ******
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar resultado: ${e.message}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // ****** CORREÇÃO 2 APLICADA AQUI ******
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
    
    setState(() { _isSaving = false; });
  }

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = widget.questions.length;

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
              
              if (_isSaving)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Salvando seu resultado...'),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      'Você acertou',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '$_correctAnswersCount / $totalQuestions',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 40),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.reviews),
                label: const Text('Mostrar Respostas'),
                onPressed: _isSaving ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(
                        userAnswers: widget.userAnswers,
                      ),
                    ),
                  );
                },
              ),
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