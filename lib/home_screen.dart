import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _nome;
  String? _selectedFaixaEtaria;
  String? _selectedGenero;

  final Map<String, bool> _dispositivos = {
    'Smartphone': false,
    'Notebook/PC': false,

    'Tablet': false,
    'Smartwatch': false,
  };

  bool _aceitaNotificacoes = false;
  double _horasEstudo = 1.0;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGenero == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione seu gênero.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Obrigado, $_nome! Formulário enviado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Uso de Tecnologia'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Qual seu nome?',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O nome é obrigatório.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nome = value;
                },
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedFaixaEtaria,
                decoration: const InputDecoration(
                  labelText: 'Qual sua faixa etária?',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                hint: const Text('Selecione...'),
                items: [
                  'Menos de 18',
                  '18-24',
                  '25-30',
                  'Mais de 30',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedFaixaEtaria = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),
              Text('Qual seu gênero?',
                  style: Theme.of(context).textTheme.titleMedium),
              RadioListTile<String>(
                title: const Text('Masculino'),
                value: 'masculino',
                groupValue: _selectedGenero,
                onChanged: (value) {
                  setState(() {
                    _selectedGenero = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Feminino'),
                value: 'feminino',
                groupValue: _selectedGenero,
                onChanged: (value) {
                  setState(() {
                    _selectedGenero = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Outro'),
                value: 'outro',
                groupValue: _selectedGenero,
                onChanged: (value) {
                  setState(() {
                    _selectedGenero = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('Quais dispositivos você usa?',
                  style: Theme.of(context).textTheme.titleMedium),
              ..._dispositivos.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: _dispositivos[key],
                  onChanged: (bool? value) {
                    setState(() {
                      _dispositivos[key] = value!;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Deseja receber notificações?'),
                secondary: const Icon(Icons.notifications),
                value: _aceitaNotificacoes,
                onChanged: (bool value) {
                  setState(() {
                    _aceitaNotificacoes = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                  'Em média, quantas horas por dia você usa tecnologia para estudar?',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                '${_horasEstudo.round()} horas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              Slider(
                value: _horasEstudo,
                min: 0,
                max: 10,
                divisions: 10,
                label: _horasEstudo.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _horasEstudo = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Enviar Formulário'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuizScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                      ),
                      child: const Text('Ir para o Quiz'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}