import 'package:projet_indus/DAOs/questiondao.dart';
import 'package:projet_indus/DTOs/ratingdto.dart';
import 'package:projet_indus/models/question.dart';

class QuestionService {
  Future<List<Question>> getStarters() async {
    List<Question>? questionList = [];
    questionList = await QuestionDAO().getStarters();
    if (questionList != null) {
      return questionList;
    } else {
      List<Question> emptyQuestionList = [];
      return emptyQuestionList;
    }
  }

  void rating(int idUtilisateur, RatingDTO ratingDTO) {
    print(ratingDTO.label);
  }
}
