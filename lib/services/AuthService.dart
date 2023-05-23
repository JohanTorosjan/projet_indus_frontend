import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:projet_indus/models/client.dart';

import '../DAOs/clientDAO.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ClientDAO clientDAO = ClientDAO();
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

  Future<Client> updateAccount(Client client, String email, String password,
      String insta, String prenom, String dob, bool updatePassword) async {
    insta = removeLeadingAtSymbol(insta);
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.updateEmail(email).then((_) {
          print("Adresse e-mail mise à jour avec succès");
        }).catchError((error) {
          print("Erreur lors de la mise à jour de l'adresse e-mail : $error");
        });
        if (updatePassword) {
          user.updatePassword(password).then((_) {
            print("Mot de passe mis à jour avec succès");
          }).catchError((error) {
            print("Erreur lors de la mise à jour du mot de passe : $error");
          });
        }
        client.email = email;
        client.instagram = insta;
        client.name = prenom;
        client.dob = DateTime.parse(dob.split('/').reversed.join('-'));
        Future<Client> updatedClient = clientDAO.updateClient(client);
        print('DAO FINISHED');
        return updatedClient;
      } else {
        print("ERROR");
        throw (Error());
      }
    } catch (err) {
      throw (err);
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

  Future<bool> verifyPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Si la connexion réussit, le mot de passe est correct
      return true;
    } catch (error) {
      // Si une erreur se produit, le mot de passe est incorrect
      return false;
    }
  }

  String removeLeadingAtSymbol(String input) {
    if (input.isNotEmpty && input.startsWith('@')) {
      return input.substring(1);
    } else {
      return input;
    }
  }
}
