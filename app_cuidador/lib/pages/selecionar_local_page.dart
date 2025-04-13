import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapaAreaPage extends StatefulWidget {
  final Function(LatLng, double) onAreaSelecionada;

  const MapaAreaPage({super.key, required this.onAreaSelecionada});

  @override
  State<MapaAreaPage> createState() => _MapaAreaPageState();
}

class _MapaAreaPageState extends State<MapaAreaPage> {
  LatLng? _localSelecionado;
  double _raio = 100.0;
  GoogleMapController? _mapController;
  bool _carregandoLocalizacao = true;

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
  }

  Future<void> _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      setState(() => _carregandoLocalizacao = false);
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        setState(() => _carregandoLocalizacao = false);
        return;
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      setState(() => _carregandoLocalizacao = false);
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition();
    setState(() {
      _localSelecionado = LatLng(posicao.latitude, posicao.longitude);
      _carregandoLocalizacao = false;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_localSelecionado!, 15),
      );
    }
  }

  void _onTapMapa(LatLng posicao) {
    setState(() => _localSelecionado = posicao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione a área",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _carregandoLocalizacao
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        _localSelecionado ?? const LatLng(-14.2350, -51.9253),
                    zoom: _localSelecionado != null ? 15 : 4,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (_localSelecionado != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLngZoom(_localSelecionado!, 15),
                      );
                    }
                  },
                  onTap: _onTapMapa,
                  markers: _localSelecionado != null
                      ? {
                          Marker(
                            markerId: const MarkerId("selecionado"),
                            position: _localSelecionado!,
                          )
                        }
                      : {},
                  circles: _localSelecionado != null
                      ? {
                          Circle(
                            circleId: const CircleId("area"),
                            center: _localSelecionado!,
                            radius: _raio,
                            fillColor: Colors.blue.withOpacity(0.3),
                            strokeColor: Colors.blue,
                            strokeWidth: 2,
                          )
                        }
                      : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                if (_localSelecionado != null)
                  Positioned(
                    bottom: 80,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Raio: ${_raio.toInt()} metros",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Slider(
                                value: _raio,
                                min: 50,
                                max: 2000,
                                divisions: 39,
                                label: "${_raio.toInt()} m",
                                onChanged: (valor) =>
                                    setState(() => _raio = valor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                          ),
                          icon: const Icon(Icons.check),
                          label: const Text("Confirmar área",
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            widget.onAreaSelecionada(_localSelecionado!, _raio);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
