import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'package:app_monitoramento_localizacao/pages/home_page.dart';
import 'package:app_monitoramento_localizacao/services/location_service.dart';

const taskName = "enviar_localizacao_periodicamente";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print(
      '[Workmanager CB] Tarefa em background iniciada: $task com dados: $inputData',
    );
    try {
      await Firebase.initializeApp();
      print('[Workmanager CB] Firebase inicializado no callback.');

      await LocationService.enviarLocalizacao();
      print(
        '[Workmanager CB] LocationService.enviarLocalizacao executado com sucesso.',
      );
      return Future.value(true);
    } catch (e, s) {
      print('[Workmanager CB] ERRO na tarefa em background: $e');
      print(s);
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Workmanager().registerPeriodicTask(
    "1", // ID único
    taskName,
    frequency: const Duration(minutes: 30),
    initialDelay: const Duration(seconds: 20),
    constraints: Constraints(networkType: NetworkType.connected),

    existingWorkPolicy: ExistingWorkPolicy.replace,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
