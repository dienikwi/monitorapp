import 'package:app_cuidador/pages/selecionar_local_page.dart';
import 'package:app_cuidador/service/paciente_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../utils/colors.dart';

class CadastroPacientePage extends StatefulWidget {
  final String? pacienteId;
  final String? nomeInicial;
  final String? idadeInicial;
  final String? enderecoInicial;
  final String? codigoInicial;
  final double? latitudeInicial;
  final double? longitudeInicial;
  final double? raioInicial;
  final bool isEdicao;

  const CadastroPacientePage({
    super.key,
    this.pacienteId,
    this.nomeInicial,
    this.idadeInicial,
    this.enderecoInicial,
    this.codigoInicial,
    this.latitudeInicial,
    this.longitudeInicial,
    this.raioInicial,
    this.isEdicao = false,
  });

  @override
  State<CadastroPacientePage> createState() => _CadastroPacientePageState();
}

class _CadastroPacientePageState extends State<CadastroPacientePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  bool _carregando = false;
  LatLng? _localSelecionado;
  double? _raioSelecionado;

  @override
  void initState() {
    super.initState();
    if (widget.isEdicao) {
      _nomeController.text = widget.nomeInicial ?? '';
      _idadeController.text = widget.idadeInicial ?? '';
      _enderecoController.text = widget.enderecoInicial ?? '';
      _codigoController.text = widget.codigoInicial ?? '';

      if (widget.latitudeInicial != null && widget.longitudeInicial != null) {
        _localSelecionado =
            LatLng(widget.latitudeInicial!, widget.longitudeInicial!);
        _raioSelecionado = widget.raioInicial;
      }
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

  void _salvarPaciente() async {
    final nome = _nomeController.text.trim();
    final idade = _idadeController.text.trim();
    final endereco = _enderecoController.text.trim();
    final codigo = _codigoController.text.trim();

    if (_localSelecionado == null || _raioSelecionado == null) {
      _mostrarAlerta(context, 'Selecione uma área delimitadora no mapa.');
      return;
    }

    if (nome.isEmpty || idade.isEmpty || endereco.isEmpty || codigo.isEmpty) {
      _mostrarAlerta(context, 'Por favor, preencha todos os campos.');
      return;
    }

    setState(() => _carregando = true);

    String? erro;
    String mensagemSucesso;

    if (widget.isEdicao) {
      erro = await PacienteService().atualizarPaciente(
        pacienteId: widget.pacienteId!,
        nome: nome,
        idade: idade,
        endereco: endereco,
        codigo: codigo,
        latitude: _localSelecionado!.latitude,
        longitude: _localSelecionado!.longitude,
        raio: _raioSelecionado!,
      );
      mensagemSucesso = 'Paciente atualizado com sucesso!';
    } else {
      erro = await PacienteService().adicionarPaciente(
        nome: nome,
        idade: idade,
        endereco: endereco,
        codigo: codigo,
        latitude: _localSelecionado!.latitude,
        longitude: _localSelecionado!.longitude,
        raio: _raioSelecionado!,
      );
      mensagemSucesso = 'Paciente adicionado com sucesso!';
    }

    setState(() => _carregando = false);

    if (!mounted) return;

    if (erro == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagemSucesso,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
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
                Text(
                  widget.isEdicao ? 'Editar paciente' : 'Adicionar paciente',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoEBotao,
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  hintText: 'Código',
                  controller: _codigoController,
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Nome completo',
                  controller: _nomeController,
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Idade',
                  controller: _idadeController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Endereço',
                  controller: _enderecoController,
                  obscureText: false,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  texto: widget.isEdicao
                      ? 'Alterar área delimitadora'
                      : 'Criar área delimitadora',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapaAreaPage(
                          onAreaSelecionada: (local, raio) {
                            setState(() {
                              _localSelecionado = local;
                              _raioSelecionado = raio;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  texto: widget.isEdicao ? 'Salvar alterações' : 'Adicionar',
                  onPressed: _carregando ? () {} : _salvarPaciente,
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
