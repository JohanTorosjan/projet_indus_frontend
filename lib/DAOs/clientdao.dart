import 'dart:convert';
import 'dart:io';

import 'package:projet_indus/models/client.dart';
import 'package:http/http.dart' as http;

class ClientDAO {
  //TODO
  Future<Client> getByFirebaseId({required String firebaseId}) async {
    final String apiUrl = 'https://localhost:8443/user/firebase_id/$firebaseId';
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
          if (jsonData != null && jsonData['id'] != null && jsonData['firebase_id'] != null) {
             return Client.fromJson(jsonData);}
                     else {
    // Les données JSON sont incomplètes ou nulles, retourner un objet vide
    return Client();
  }
        return Client.fromJson(jsonData);
      } else { 
        return Client();
      }
    } catch (err) {
      print(err);
      return Client();
    }
  }

  Future<Client> createNewClient(Client newClient) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    const String apiUrl = 'https://localhost:8443/user';
    print(apiUrl);
    try {
      final jsonBody = json.encode(newClient.toJson());
      print('ok encode');
      print(jsonBody);
      final response =
          await http.post(Uri.parse(apiUrl),headers: headers, body: jsonBody);

      print(response.statusCode);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(Client.fromJson(jsonData as Map<String,dynamic>).answered_questions);
        return Client.fromJson(jsonData as Map<String,dynamic>);
      } else {
        return Client();
      }
    } catch (err) {
      print(err);
      return Client();
    }
  }
}