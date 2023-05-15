import 'dart:convert';

import 'package:projet_indus/DTOs/ratingdto.dart';

import '../models/question.dart';
import 'package:http/http.dart' as http;

class QuestionDAO {
  Future<List<Question>?> getStarters() async {
    final String apiUrl = 'https://localhost:8443/questions/getStarters';
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));

      final jsonString = response.body;
      final jsonData = json.decode(utf8.decode(jsonString.runes.toList()));
      if (response.statusCode == 200) {
        List<Question> questionList = [];
        for (var questionData in jsonData) {
          Question question = Question.fromJson(questionData);
          questionList.add(question);
        }
        return questionList;
      } else {
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  void rate(int idUtilisateur, RatingDTO ratingDTO) async {
    final String apiUrl =
        'https://localhost:8443/questions/rating/$idUtilisateur';
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    print(apiUrl);
    try {
      final jsonBody = json.encode(ratingDTO.toJson());
      print(jsonBody);
      final response =
          await http.put(Uri.parse(apiUrl), headers: headers, body: jsonBody);
      print(response.statusCode);
    } catch (err) {
      print(err);
    }
  }
}
