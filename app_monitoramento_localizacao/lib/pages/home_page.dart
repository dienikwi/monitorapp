import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../services/location_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _codigo;

  @override
  void initState() {
    super.initState();
    _carregarCodigo();
  }

  Future<void> _carregarCodigo() async {
    final prefs = await SharedPreferences.getInstance();
    String? codigo = prefs.getString('codigo');

    if (codigo == null) {
      codigo = _gerarCodigoAleatorio();
      await prefs.setString('codigo', codigo);
    }

    setState(() {
      _codigo = codigo;
    });
  }

  String _gerarCodigoAleatorio() {
    final agora = DateTime.now();
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random(agora.millisecondsSinceEpoch);
    return List.generate(6, (i) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> _enviarLocalizacao() async {
    await LocationService.enviarLocalizacao();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Localização enviada com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Código do aparelho: $_codigo',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Guarde esse código',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _enviarLocalizacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Enviar localização',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
