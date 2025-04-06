import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/colors.dart';
import 'cadastro_paciente_page.dart';

class ListagemPacientesPage extends StatelessWidget {
  const ListagemPacientesPage({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _abrirCadastroPaciente(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroPacientePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: AppColors.textoEBotao,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Logado com sucesso!',
          style: TextStyle(fontSize: 20, color: AppColors.textoEBotao),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.textoEBotao,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _abrirCadastroPaciente(context),
      ),
    );
  }
}
