import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:projet_indus/DTOs/ratingdto.dart';
import 'package:projet_indus/models/answers.dart';
import 'package:projet_indus/views/question_usages.dart';

import '../models/question.dart';
import 'package:http/http.dart' as http;

import '../models/questionsusage.dart';

class QuestionDAO {
  static String API_URL = "https://sortir-ce-soir-back.cluster-ig4.igpolytech.fr";

  Future<List<Question>?> getStarters() async {
    final String apiUrl = '$API_URL/questions/getStarters';
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

  Future<List<Question>?> getBunchOfQuestions(int id) async {
    final String apiUrl =
        '$API_URL/questions/getBunchOfQuestions/$id';
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
        '$API_URL/questions/rating/$idUtilisateur';
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

  static String formatTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    final hour = formattedTime.split(':')[0];
    return '${hour}h';
  }

  static List<QuestionsUsage> formateDate(List<QuestionsUsage> questionList) {
    List<Answers> hours = questionList[0].answers!;
    for (var hour in hours) {
      hour.label = QuestionDAO.formatTime(hour.label);
    }
    questionList[0].answers = hours;
    return questionList;
  }

  Future<List<QuestionsUsage>?> getQuestionsUsages() async {
    final String apiUrl = '$API_URL/usages_questions';
    print(apiUrl);

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonString = response.body;
      final jsonData = json.decode(utf8.decode(jsonString.runes.toList()));
      if (response.statusCode == 200) {
        List<QuestionsUsage> questionList = [];
        for (var questionsUsageData in jsonData) {
          List<Answers> answers = [];
          for (var answersData in questionsUsageData["answers"]) {
            Answers answer = Answers.fromJson(answersData);
            answers.add(answer);
          }

          QuestionsUsage question =
              QuestionsUsage.fromJson(questionsUsageData["question"]);
          question.answers = answers;
          questionList.add(question);
        }
        return formateDate(questionList);
      }
    } catch (err) {
      print(err);
      return null;
    }
  }
}
