import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PacienteCard extends StatelessWidget {
  final String nome;
  final String idade;
  final String endereco;
  final String codigo;
  final VoidCallback onDelete;

  const PacienteCard({
    super.key,
    required this.nome,
    required this.idade,
    required this.endereco,
    required this.codigo,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.campoTexto.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Código: $codigo",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Nome: $nome", style: const TextStyle(fontSize: 16)),
                  Text("Idade: $idade", style: const TextStyle(fontSize: 16)),
                  Text("Endereço: $endereco",
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Excluir paciente',
            ),
          ],
        ),
      ),
    );
  }
}
