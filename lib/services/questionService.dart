import 'package:projet_indus/DAOs/questiondao.dart';
import 'package:projet_indus/DTOs/ratingdto.dart';
import 'package:projet_indus/models/question.dart';

class QuestionService {
  Future<List<Question>?> getStarters() async {
    return await QuestionDAO().getStarters();
  }

  void rating(int idUtilisateur, RatingDTO ratingDTO) {
    print(ratingDTO.label);
  }
}
