import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math' show cos, sqrt, asin;

class PacienteMapaPage extends StatefulWidget {
  final String nome;
  final String codigo;
  final double latitude;
  final double longitude;
  final double raio;

  const PacienteMapaPage({
    super.key,
    required this.nome,
    required this.codigo,
    required this.latitude,
    required this.longitude,
    required this.raio,
  });

  @override
  State<PacienteMapaPage> createState() => _PacienteMapaPageState();
}

class _PacienteMapaPageState extends State<PacienteMapaPage> {
  LatLng? _ultimaLocalizacao;
  DatabaseReference? _ref;
  bool _alertaMostradoForaDoRaio = false;

  @override
  void initState() {
    super.initState();
    _iniciarStreamDeLocalizacao();
  }

  void _iniciarStreamDeLocalizacao() {
    _ref = FirebaseDatabase.instance.ref("localizacoes/${widget.codigo}");

    _ref!.get().then((snapshot) {
      if (snapshot.exists) {
        _atualizarLocalizacao(snapshot);
      }
    });

    // Escuta atualizações
    _ref!.onValue.listen((event) {
      if (event.snapshot.exists) {
        _atualizarLocalizacao(event.snapshot);
      }
    });
  }

  double _calcularDistancia(LatLng ponto1, LatLng ponto2) {
    const p = 0.017453292519943295; // Pi / 180
    final a = 0.5 -
        cos((ponto2.latitude - ponto1.latitude) * p) / 2 +
        cos(ponto1.latitude * p) *
            cos(ponto2.latitude * p) *
            (1 - cos((ponto2.longitude - ponto1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  void _atualizarLocalizacao(DataSnapshot snapshot) {
    final dados = snapshot.value as Map?;
    if (dados != null &&
        dados['latitude'] != null &&
        dados['longitude'] != null) {
      final novaLocalizacao = LatLng(
        dados['latitude'] * 1.0,
        dados['longitude'] * 1.0,
      );

      setState(() {
        _ultimaLocalizacao = novaLocalizacao;
      });

      final localizacaoCentral = LatLng(widget.latitude, widget.longitude);
      final distancia = _calcularDistancia(localizacaoCentral, novaLocalizacao);

      if (distancia > widget.raio) {
        if (!_alertaMostradoForaDoRaio) {
          _mostrarAlerta(
              context, '${widget.nome} está fora da área designada!');
          _alertaMostradoForaDoRaio = true;
        }
      } else {
        _alertaMostradoForaDoRaio = false;
      }
    }
  }

  void _mostrarAlerta(BuildContext context, String mensagem,
      [Color cor = Colors.red]) {
    if (!mounted) return;

    final snackBar = SnackBar(
      content: Text(
        mensagem,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: cor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _ref?.onValue.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizacaoPadrao = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nome} - ${widget.codigo}',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _ultimaLocalizacao ?? localizacaoPadrao,
          zoom: 15,
        ),
        circles: {
          Circle(
            circleId: const CircleId("area"),
            center: localizacaoPadrao,
            radius: widget.raio,
            fillColor: Colors.blue.withOpacity(0.3),
            strokeColor: Colors.blue,
            strokeWidth: 2,
          )
        },
        markers: _ultimaLocalizacao != null
            ? {
                Marker(
                  markerId: const MarkerId('ultima_localizacao'),
                  position: _ultimaLocalizacao!,
                  infoWindow: const InfoWindow(title: 'Última localização'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                )
              }
            : {},
        myLocationEnabled: true,
      ),
    );
  }
}
