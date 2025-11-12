import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart'; // Importa o atalho 'supabase'

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Pega o e-mail do usuário logado para exibir na tela
  final String _userEmail = supabase.auth.currentUser?.email ?? 'Usuário não encontrado';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- FUNÇÃO DE SAIR (LOGOUT) ---
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signOut();
      // O AuthWrapper vai detectar o signOut e navegar
      // para a LoginScreen automaticamente.
      // Como o AuthWrapper cuida disso, não precisamos do Navigator.popUntil
    } on AuthException catch (e) {
      _showError('Erro ao fazer logout: ${e.message}');
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- FUNÇÃO DE MUDAR SENHA (UPDATE) ---
  void _showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    _passwordController.clear();
    _confirmPasswordController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mudar Senha'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Nova Senha'),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirmar Nova Senha'),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context); // Fecha o pop-up
                  await _updatePassword(_passwordController.text);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePassword(String newPassword) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _showSuccess('Senha alterada com sucesso!');
    } on AuthException catch (e) {
      _showError('Erro ao alterar senha: ${e.message}');
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- FUNÇÃO DE EXCLUIR CONTA (DELETE) ---
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Conta'),
          content: const Text(
              'Você tem certeza? Todos os seus dados (formulários e resultados de quizzes) serão apagados permanentemente. Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context); // Fecha o pop-up
                await _deleteAccount();
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;

      // 1. Apaga os dados do formulário
      await supabase.from('formularios').delete().eq('user_id', userId);

      // 2. Apaga os resultados do quiz
      await supabase.from('resultados_quiz').delete().eq('user_id', userId);

      // 3. Faz o logout (o AuthWrapper cuidará da navegação)
      await supabase.auth.signOut();
      
      // NOTA: Para apagar o LOGIN (auth.users), precisaríamos de uma Edge Function.
      // Por agora, estamos "anônimizando" a conta ao apagar todos os dados.

    } catch (e) {
      _showError('Erro ao excluir dados: ${e.toString()}');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    // Não precisamos setar _isLoading = false aqui, pois o signOut
    // vai desmontar esta tela.
  }

  // Funções de Feedback
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Mostra o e-mail do usuário (apenas leitura)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Conta Logada'),
                    subtitle: Text(_userEmail),
                  ),
                ),
                const SizedBox(height: 20),
                
                // UPDATE
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Mudar Senha'),
                  subtitle: const Text('Altere a senha da sua conta'),
                  onTap: _showChangePasswordDialog,
                ),
                const Divider(),
                
                // LOGOUT
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sair (Logout)'),
                  subtitle: const Text('Desconecte-se do aplicativo'),
                  onTap: _logout,
                ),
                const Divider(),
                
                // DELETE
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Excluir Conta',
                      style: TextStyle(color: Colors.red)),
                  subtitle: const Text('Apagar permanentemente seus dados'),
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),
    );
  }
}