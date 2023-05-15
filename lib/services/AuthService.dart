import 'package:firebase_auth/firebase_auth.dart';

import 'package:projet_indus/models/client.dart';

import '../DAOs/clientDAO.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<Future<Client?>> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  Future registerWithEmailAndPassword(String email, String password,
      String prenom, String insta, String dob) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = user.user;
      Client newClient = Client(
          firebase_id: firebaseUser!.uid,
          dob: DateTime.parse(dob.split('/').reversed.join('-')),
          email: email,
          has_active_session: false,
          instagram: insta,
          name: prenom,
          answered_questions: 0);
      await _auth.signOut();
      return ClientDAO().createNewClient(newClient);
    } on FirebaseAuthException catch (e) {
      print('firebase exception :');
      print(e);
      return Client();
    }

    // Client newClient = Client(firebase_id: firebaseUser!.uid,)
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = user.user;

      // return await ClientDAO().getByFirebaseId(firebaseId: firebaseUser!.uid);

      return _firebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      print('firebase exception :');
      print(e);
      return Client();
    }
  }

  Future<Client?> _firebaseUser(User? user) async {
    if (user != null) {
      Client client = await ClientDAO().getByFirebaseId(firebaseId: user.uid);

      print("PAS DE  WRAP USER");
      print(user == null);
      print("??");

      print(client.answered_questions);
      return client;
    }
    return null;
  }
}
