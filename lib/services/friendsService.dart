import 'package:projet_indus/DAOs/friendsdao.dart';
import 'package:projet_indus/models/friends.dart';

class FriendsService {
  final FriendsDAO friendsDAO = FriendsDAO();
  
  
  Future<List<Friends>> getFriends(int id) async {
    List<Friends>? friendsList = [];
    friendsList = await friendsDAO.getFriends(id);

    if (friendsList == null) {
      friendsList = [];
      return friendsList;
    } else {
      return friendsList;
    }
  }
}
