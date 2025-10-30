// lib/quiz_screen.dart

import 'package:flutter/material.dart';
import 'questions_data.dart'; // Importa nossa lista de perguntas

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Índice da pergunta que está sendo exibida
  int _currentQuestionIndex = 0;

  // Lista para armazenar as respostas do usuário (o índice da opção escolhida)
  // Usamos 'late' porque vamos inicializá-la no initState
  late List<int?> _selectedAnswers;

  // Variável para guardar a pontuação final
  int _score = 0;

  @override
  void initState() {
    super.initState();
    // Inicializa a lista de respostas com 'null' para cada pergunta
    _selectedAnswers = List<int?>.filled(questions.length, null);
  }

  // Função chamada quando o usuário seleciona uma opção de rádio
  void _answerQuestion(int? value) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = value;
    });
  }

  // Função para navegar para a próxima pergunta
  void _nextQuestion() {
    // Verifica se o usuário já respondeu à pergunta atual
    if (_selectedAnswers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma resposta.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Para a execução se nenhuma resposta foi dada
    }

    // Se não for a última pergunta, avança
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  // Função para calcular a pontuação e finalizar o quiz
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

    // Reseta a pontuação
    _score = 0;
    // Itera sobre todas as respostas e compara com o gabarito
    for (int i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i].correctOptionIndex) {
        _score++; // Incrementa a pontuação se estiver correta
      }
    }

    // Mostra um diálogo (pop-up) com o resultado
    showDialog(
      context: context,
      barrierDismissible: false, // Impede de fechar clicando fora
      builder: (ctx) => AlertDialog(
        title: const Text('Quiz Finalizado!'),
        content: Text(
          'Você acertou $_score de ${questions.length} perguntas!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Fecha o diálogo
              Navigator.of(ctx).pop(); 
              // Fecha a tela do Quiz e volta para o formulário
              Navigator.of(context).pop(); 
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pega a pergunta atual da lista
    final currentQuestion = questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: Pergunta ${_currentQuestionIndex + 1} de ${questions.length}'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- O Texto da Pergunta ---
            Text(
              currentQuestion.questionText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // --- As Opções de Resposta ---
            // Usamos '... ' (spread operator) para gerar a lista de widgets
            ...List.generate(currentQuestion.options.length, (index) {
              return RadioListTile<int>(
                title: Text(currentQuestion.options[index]),
                value: index, // O valor desta opção é seu próprio índice
                groupValue: _selectedAnswers[_currentQuestionIndex],
                onChanged: _answerQuestion,
                contentPadding: EdgeInsets.zero,
              );
            }),
            
            const SizedBox(height: 40),

            // --- Botão de Próximo / Finalizar ---
            Center(
              child: ElevatedButton(
                // Decide qual função chamar: _nextQuestion ou _finishQuiz
                onPressed: _currentQuestionIndex < questions.length - 1
                    ? _nextQuestion
                    : _finishQuiz,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                // Decide o texto do botão
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