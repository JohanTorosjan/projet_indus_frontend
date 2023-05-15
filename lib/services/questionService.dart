import 'package:projet_indus/DAOs/questiondao.dart';
import 'package:projet_indus/models/question.dart';

class QuestionService {
  Future<List<Question>?> getStarters() async {
    return await QuestionDAO().getStarters();
  }
}
