import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PacienteMapaPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final localizacao = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text('$nome - $codigo',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: localizacao,
          zoom: 15,
        ),
        circles: {
          Circle(
            circleId: const CircleId("area"),
            center: localizacao,
            radius: raio,
            fillColor: Colors.blue.withOpacity(0.3),
            strokeColor: Colors.blue,
            strokeWidth: 2,
          )
        },
        myLocationEnabled: true,
      ),
    );
  }
}
