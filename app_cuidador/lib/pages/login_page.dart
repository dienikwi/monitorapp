import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../utils/colors.dart';
import '../service/auth_service.dart';
import 'cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final _authService = AuthService();
  bool _carregando = false;

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

  void _login() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    final emailValido = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (email.isEmpty || senha.isEmpty) {
      _mostrarAlerta(context, 'Por favor, preencha todos os campos.');
      return;
    }

    if (!emailValido.hasMatch(email)) {
      _mostrarAlerta(context, 'Informe um e-mail válido.');
      return;
    }

    setState(() => _carregando = true);

    try {
      await _authService.loginUsuario(email: email, senha: senha);

      final uid = FirebaseAuth.instance.currentUser!.uid;
      await _authService.salvarTokenFCM(uid);

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/pacientes');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      _mostrarAlerta(context, e.toString().replaceAll('Exception: ', ''));
    }

    setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.fundo,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
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
                      onPressed: _carregando ? () {} : _login,
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
        ),
        if (_carregando)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A4C5)),
              ),
            ),
          ),
      ],
    );
  }
}
