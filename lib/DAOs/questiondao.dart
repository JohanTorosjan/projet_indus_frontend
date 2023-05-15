import 'dart:convert';

import '../models/question.dart';
import 'package:http/http.dart' as http;

class QuestionDAO {
  Future<List<Question>?> getStarters() async {
    final String apiUrl = 'https://localhost:8443/questions/getStarters';
    print(apiUrl);
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonData = json.decode(response.body);
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
}
