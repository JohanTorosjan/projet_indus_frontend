import 'package:projet_indus/DAOs/questiondao.dart';
import 'package:projet_indus/DTOs/ratingdto.dart';
import 'package:projet_indus/models/question.dart';
import 'package:projet_indus/models/questionsusage.dart';

class QuestionService {
  QuestionDAO questionDAO = QuestionDAO();

  Future<List<Question>> getStarters() async {
    List<Question>? questionList = [];
    questionList = await questionDAO.getStarters();
    print(questionList);
    if (questionList != null) {
      return questionList;
    } else {
      List<Question> emptyQuestionList = [];
      return emptyQuestionList;
    }
  }

  void rating(int idUtilisateur, RatingDTO ratingDTO) {
    QuestionDAO().rate(idUtilisateur, ratingDTO);
  }

  Future<List<QuestionsUsage>> getQuestionsUsage() async {
    List<QuestionsUsage>? questionsUsageList = [];
    print("ICI");

    questionsUsageList = await questionDAO.getQuestionsUsages();
    if (questionsUsageList != null) {
      return questionsUsageList;
    } else {
      List<QuestionsUsage> emptyList = [];
      return emptyList;
    }
  }
}
