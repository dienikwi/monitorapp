import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../utils/colors.dart';
import '../service/auth_service.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool _carregando = false;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  final _authService = AuthService();

  void _cadastrar() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();
    final confirmarSenha = confirmarSenhaController.text.trim();

    final emailValido = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (nome.isEmpty ||
        email.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      _mostrarAlerta(context, 'Por favor, preencha todos os campos.');
      return;
    }

    if (!emailValido.hasMatch(email)) {
      _mostrarAlerta(context, 'Informe um e-mail válido.');
      return;
    }

    if (senha != confirmarSenha) {
      _mostrarAlerta(context, 'As senhas não coincidem.');
      return;
    }

    setState(() => _carregando = true);

    final erro = await _authService.cadastrarUsuario(
      nome: nome,
      email: email,
      senha: senha,
    );

    setState(() => _carregando = false);

    if (!mounted) return;

    if (erro == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    } else {
      _mostrarAlerta(context, erro);
    }
  }

  void _mostrarAlerta(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(
        mensagem,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.fundo,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Crie sua conta",
                  style: TextStyle(
                    color: AppColors.textoEBotao,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: nomeController,
                  hintText: 'Nome',
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: senhaController,
                  hintText: 'Senha',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: confirmarSenhaController,
                  hintText: 'Digite sua senha novamente',
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  texto: 'Cadastrar-se',
                  onPressed: _carregando ? () {} : _cadastrar,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (_carregando)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 0, 164, 197)),
              ),
            ),
          ),
      ],
    );
  }
}
