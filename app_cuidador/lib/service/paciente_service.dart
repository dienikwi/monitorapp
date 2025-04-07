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

  Future<String?> deletarPaciente(String pacienteId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return 'Usuário não autenticado.';

      await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('pacientes')
          .doc(pacienteId)
          .delete();

      return null;
    } catch (e) {
      return 'Erro ao deletar paciente: ${e.toString()}';
    }
  }

  Stream<QuerySnapshot> listarPacientes() {
    final uid = _auth.currentUser?.uid;
    return _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('pacientes')
        .snapshots();
  }
}
