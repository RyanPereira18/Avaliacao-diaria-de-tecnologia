import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math'; 
import 'quiz_question_model.dart';
import 'review_screen.dart';
import 'main.dart';
import 'pokemon_model.dart'; 

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
  bool _isSavingResult = false;

  Pokemon? _rewardPokemon; 
  bool _isLoadingReward = true;
  String _pokemonError = '';

  @override
  void initState() {
    super.initState();
    _calculateAndSaveResult();
    _fetchRandomPokemonReward();
  }

  Future<void> _calculateAndSaveResult() async {
    setState(() { _isSavingResult = true; });

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
      setState(() { _isSavingResult = false; });
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar resultado: $e'), backgroundColor: Colors.red),
        );
      }
    }
    // ----------------------------
    
    setState(() { _isSavingResult = false; });
  }

  Future<void> _fetchRandomPokemonReward() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.canalti.com.br/api/pokemons.json'));

      if (response.statusCode == 200) {
        final List<Pokemon> fetchedPokemons = parsePokemons(response.body);

        if (fetchedPokemons.isNotEmpty) {
          final int totalPokemons = fetchedPokemons.length;
          final int randomIndex = Random().nextInt(totalPokemons);

          setState(() {
            _rewardPokemon = fetchedPokemons[randomIndex];
            _isLoadingReward = false;
          });
        } else {
          _showPokemonError('A API não retornou Pokémons.');
        }
      } else {
        _showPokemonError('Falha ao carregar: ${response.statusCode}');
      }
    } catch (e) {
      _showPokemonError('Erro de conexão: $e');
    }
  }
  
  void _showPokemonError(String message) {
     setState(() {
        _pokemonError = message;
        _isLoadingReward = false;
      });
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Parabéns!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              if (_isSavingResult)
                const Center(heightFactor: 3, child: Text('Salvando placar...'))
              else
                Text(
                  '$_correctAnswersCount / $totalQuestions',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              const SizedBox(height: 30),
              
              Text(
                'Seu prêmio aleatório é:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              
              if (_isLoadingReward)
                const Center(child: CircularProgressIndicator())
              else if (_pokemonError.isNotEmpty)
                Center(child: Text(_pokemonError, style: const TextStyle(color: Colors.red)))
              else if (_rewardPokemon != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.network(
                          _rewardPokemon!.img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.error, size: 80),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _rewardPokemon!.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _rewardPokemon!.type.join(', '),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              const Spacer(), 

              ElevatedButton.icon(
                icon: const Icon(Icons.reviews),
                label: const Text('Mostrar Respostas'),
                onPressed: _isSavingResult ? null : () {
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
              const SizedBox(height: 12),
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