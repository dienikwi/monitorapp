import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PacienteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> adicionarPaciente({
    required String nome,
    required String idade,
    required String endereco,
    required String codigo,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return 'Usuário não autenticado.';

      await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('pacientes')
          .add({
        'nome': nome,
        'idade': idade,
        'endereco': endereco,
        'codigo': codigo,
      });

      return null;
    } catch (e) {
      return 'Erro ao adicionar paciente: ${e.toString()}';
    }
  }
}
