import 'package:app_cuidador/service/paciente_service.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../utils/colors.dart';

class CadastroPacientePage extends StatefulWidget {
  const CadastroPacientePage({super.key});

  @override
  State<CadastroPacientePage> createState() => _CadastroPacientePageState();
}

class _CadastroPacientePageState extends State<CadastroPacientePage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();

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

  void _adicionarPaciente() async {
    final nome = nomeController.text.trim();
    final idade = idadeController.text.trim();
    final endereco = enderecoController.text.trim();
    final codigo = codigoController.text.trim();

    if (nome.isEmpty || idade.isEmpty || endereco.isEmpty || codigo.isEmpty) {
      _mostrarAlerta(context, 'Por favor, preencha todos os campos.');
      return;
    }

    setState(() => _carregando = true);

    final erro = await PacienteService().adicionarPaciente(
      nome: nome,
      idade: idade,
      endereco: endereco,
      codigo: codigo,
    );

    setState(() => _carregando = false);

    if (!mounted) return;

    if (erro == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paciente adicionado com sucesso!',
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
                  'Adicionar paciente',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoEBotao,
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  hintText: 'Código',
                  controller: codigoController,
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Nome completo',
                  controller: nomeController,
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Idade',
                  controller: idadeController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Endereço',
                  controller: enderecoController,
                  obscureText: false,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  texto: 'Criar área delimitadora',
                  onPressed: () {
                    // lógica futura
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  texto: 'Adicionar',
                  onPressed: _carregando ? () {} : _adicionarPaciente,
                ),
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
