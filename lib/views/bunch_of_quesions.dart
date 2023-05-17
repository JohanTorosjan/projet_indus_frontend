import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../DTOs/ratingdto.dart';
import '../models/client.dart';
import '../models/question.dart';
import '../services/questionService.dart';
import 'card_view.dart';

class BunchOfQuestions extends StatefulWidget {
  const BunchOfQuestions({Key? key, required this.client, required this.close})
      : super(key: key);
  final Function close;
  final Client client;

  @override
  State<BunchOfQuestions> createState() => _BunchOfQuestionsState();
}

class _BunchOfQuestionsState extends State<BunchOfQuestions> {
  final QuestionService questionService = QuestionService();
  late Future<List<Question>> questions;
  late List<Question> questionList;
  int currentIndex = 0;
  int nextCardIndex = 3;

  @override
  void initState() {
    super.initState();
    questions = QuestionService().getStarters();
    questions.then((value) {
      setState(() {
        questionList = value;
      });
    });
  }

  CardView _createCard(Question question, int index) {
    return CardView(
      id: question.id,
      text: question.label,
      choice0: question.choice0,
      choice1: question.choice1,
      progress: index / 10.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController cardController =
        SwipeableCardSectionController();
    int? idUtilisateur = widget.client.id;

    return SingleChildScrollView(
      child: FutureBuilder<List<Question>>(
        future: questions,
        builder: (context, snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SwipeableCardsSection(
              cardController: cardController,
              context: context,
              items: questionList
                  .getRange(0, min(3, questionList.length))
                  .toList()
                  .asMap()
                  .map((index, question) =>
                      MapEntry(index, _createCard(question, index)))
                  .values
                  .toList(),
              onCardSwiped: (dir, index, widget) {
                int questionId = (widget as CardView).id;
                if (dir == Direction.left) {
                  RatingDTO ratingDTO =
                      RatingDTO(id: questionId, choice: false);
                  questionService.rating(idUtilisateur!, ratingDTO);
                } else if (dir == Direction.right) {
                  RatingDTO ratingDTO = RatingDTO(id: questionId, choice: true);
                  questionService.rating(idUtilisateur!, ratingDTO);
                }

                if (currentIndex < 10) {
                  setState(() {
                    currentIndex++;
                  });
                }

                if (nextCardIndex < questionList.length) {
                  cardController.addItem(
                      _createCard(questionList[nextCardIndex], currentIndex));
                  setState(() {
                    nextCardIndex++;
                  });
                }
              },
              enableSwipeUp: false,
              enableSwipeDown: false,
            );
          }
        },
      ),
    );
    // return Scaffold(
    //   body: Container(
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [
    //           Colors.blue.shade600,
    //           Colors.blue.shade900,
    //         ],
    //       ),
    //     ),
    //     child:SingleChildScrollView(child: Text("bonjour"),)
    //     // child: FutureBuilder<List<Question>>(
    //     //   future: questions,
    //     //   builder: (context, snapshot) {
    //     //     if (snapshot.connectionState == ConnectionState.waiting) {
    //     //       return Center(child: CircularProgressIndicator());
    //     //     } else if (snapshot.hasError) {
    //     //       return Center(child: Text('Error: ${snapshot.error}'));
    //     //     } else {
    //     //       return SwipeableCardsSection(
    //     //         cardController: cardController,
    //     //         context: context,
    //     //         items: questionList
    //     //             .getRange(0, min(3, questionList.length))
    //     //             .toList()
    //     //             .asMap()
    //     //             .map((index, question) =>
    //     //                 MapEntry(index, _createCard(question, index)))
    //     //             .values
    //     //             .toList(),
    //     //         onCardSwiped: (dir, index, widget) {
    //     //           int questionId = (widget as CardView).id;
    //     //           if (dir == Direction.left) {
    //     //             RatingDTO ratingDTO =
    //     //                 RatingDTO(id: questionId, choice: false);
    //     //             questionService.rating(idUtilisateur!, ratingDTO);
    //     //           } else if (dir == Direction.right) {
    //     //             RatingDTO ratingDTO =
    //     //                 RatingDTO(id: questionId, choice: true);
    //     //             questionService.rating(idUtilisateur!, ratingDTO);
    //     //           }

    //     //           if (currentIndex < 10) {
    //     //             setState(() {
    //     //               currentIndex++;
    //     //             });
    //     //           }

    //     //           if (nextCardIndex < questionList.length) {
    //     //             cardController.addItem(
    //     //                 _createCard(questionList[nextCardIndex], currentIndex));
    //     //             setState(() {
    //     //               nextCardIndex++;
    //     //             });
    //     //           }
    //     //         },
    //     //         enableSwipeUp: false,
    //     //         enableSwipeDown: false,
    //     //       );
    //     //     }
    //     //   },
    //     // ),
    //   ),
    // );
  }
}
