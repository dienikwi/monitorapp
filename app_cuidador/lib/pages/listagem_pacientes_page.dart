import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/paciente_card.dart';
import '../utils/colors.dart';
import '../service/paciente_service.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: PacienteService().listarPacientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                color: AppColors.campoTexto.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Cadastre novos pacientes, você os verá aqui!',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textoEBotao,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final paciente = docs[index];
              final pacienteId = paciente.id;

              return PacienteCard(
                nome: paciente['nome'],
                idade: paciente['idade'],
                endereco: paciente['endereco'],
                codigo: paciente['codigo'],
                onDelete: () async {
                  final erro =
                      await PacienteService().deletarPaciente(pacienteId);
                  if (erro != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(erro)),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.textoEBotao,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _abrirCadastroPaciente(context),
      ),
    );
  }
}
