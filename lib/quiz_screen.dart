import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Armazena a resposta selecionada para a pergunta 1
  String? _respostaQ1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz: Conhecimento Digital'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Pergunta 1 ---
            Text(
              'Pergunta 1',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'O que é "Phishing"?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Opções de Resposta (usando RadioListTile)
            RadioListTile<String>(
              title: const Text('Um novo aplicativo de rede social.'),
              value: 'a',
              groupValue: _respostaQ1,
              onChanged: (value) {
                setState(() {
                  _respostaQ1 = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text(
                  'Uma técnica de golpe online para roubar dados pessoais.'),
              value: 'b', // Resposta correta
              groupValue: _respostaQ1,
              onChanged: (value) {
                setState(() {
                  _respostaQ1 = value;
                });
              },
            ),
            RadioListTile<String>(
              title:
                  const Text('Um software usado para organizar arquivos no PC.'),
              value: 'c',
              groupValue: _respostaQ1,
              onChanged: (value) {
                setState(() {
                  _respostaQ1 = value;
                });
              },
            ),
            // --- Fim da Pergunta 1 ---

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para verificar a resposta
                  String feedback;
                  Color corFeedback;
                  if (_respostaQ1 == 'b') {
                    feedback = 'Correto! Phishing é uma fraude online.';
                    corFeedback = Colors.green;
                  } else {
                    feedback = 'Ops, resposta errada. Tente novamente.';
                    corFeedback = Colors.red;
                  }

                  // Mostra o feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(feedback),
                      backgroundColor: corFeedback,
                    ),
                  );
                },
                child: const Text('Verificar Resposta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}