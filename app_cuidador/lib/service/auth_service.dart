import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await _firestore.collection('usuarios').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'nome': nome,
        'email': email,
        'criado_em': Timestamp.now(),
      });

      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Este e-mail já está em uso.';
      } else if (e.code == 'weak-password') {
        return 'A senha deve conter no mínimo 6 caracteres.';
      } else if (e.code == 'invalid-email') {
        return 'E-mail inválido.';
      } else {
        return 'Erro: ${e.message}';
      }
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<void> loginUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Usuário não encontrado.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Senha incorreta.');
      } else if (e.code == 'invalid-email') {
        throw Exception('E-mail inválido.');
      } else {
        throw Exception('Erro: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
