import 'package:app_cuidador/pages/cadastro_page.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../utils/colors.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Bem vindo de volta!",
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.textoEBotao,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 150),
                CustomTextField(
                  hintText: 'E-mail',
                  controller: emailController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Senha',
                  controller: senhaController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  texto: 'Entrar',
                  onPressed: () {
                    // Abrir tela com pacientes, lista carregada...
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CadastroPage()),
                    );
                  },
                  child: const Text(
                    "Não possui conta? Registre-se",
                    style: TextStyle(
                      color: AppColors.textoEBotao,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
