import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static Future<void> enviarLocalizacao() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente');
    }

    final posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final prefs = await SharedPreferences.getInstance();
    final codigo = prefs.getString('codigo') ?? 'SEM_CODIGO';

    final timestamp = DateTime.now().toIso8601String();
    final dados = {
      'codigo': codigo,
      'timestamp': timestamp,
      'latitude': posicao.latitude,
      'longitude': posicao.longitude,
    };

    await FirebaseDatabase.instance.ref("localizacoes/$codigo").set(dados);
  }
}
