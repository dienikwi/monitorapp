import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../utils/colors.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  void cadastrar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {
                final nome = nomeController.text.trim();
                final email = emailController.text.trim();
                final senha = senhaController.text.trim();
                final confirmarSenha = confirmarSenhaController.text.trim();

                final emailValido = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                if (nome.isEmpty ||
                    email.isEmpty ||
                    senha.isEmpty ||
                    confirmarSenha.isEmpty) {
                  _mostrarAlerta(
                      context, 'Por favor, preencha todos os campos.');
                } else if (!emailValido.hasMatch(email)) {
                  _mostrarAlerta(context, 'Informe um e-mail válido.');
                } else if (senha != confirmarSenha) {
                  _mostrarAlerta(context, 'As senhas não coincidem.');
                } else {
                  cadastrar();
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
}
