import 'package:projet_indus/models/answers.dart';

class QuestionsUsage {
  final int id;
  final String label;
  List<Answers>? answers;

  QuestionsUsage(
      {required this.id, required this.label,this.answers});

  factory QuestionsUsage.fromJson(Map<String, dynamic> json) {

    return QuestionsUsage(
      id: json['id'],
      label: json['label'],
      
    );
  }

 
  }







