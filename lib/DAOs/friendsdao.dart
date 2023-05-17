import 'dart:convert';

import '../models/friends.dart';
import 'package:http/http.dart' as http;

class FriendsDAO {
  Future<List<Friends>?> getFriends(int id) async {
    final String apiUrl = 'https://localhost:8443/user/friends/$id';
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonString = response.body;
      print(response.statusCode);
      final jsonData = json.decode(utf8.decode(jsonString.runes.toList()));
      if (response.statusCode == 200) {
        List<Friends> friendsList = [];
        for (var friendsData in jsonData) {
          Friends friends = Friends.fromJson(friendsData);
          friendsList.add(friends);
        }
        return friendsList;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }
}
