import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projet_indus/DTOs/ratingdto.dart';
import 'package:projet_indus/models/client.dart';
import 'package:projet_indus/models/question.dart';
import 'package:projet_indus/services/AuthService.dart';
import 'package:projet_indus/services/questionService.dart';
import 'package:projet_indus/views/card_view.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

class FirstQuestions extends StatefulWidget {
  const FirstQuestions({Key? key, required this.client}) : super(key: key);

  final Client client;

  @override
  State<FirstQuestions> createState() => _FirstQuestionsState();
}

class _FirstQuestionsState extends State<FirstQuestions> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final QuestionService questionService = QuestionService();
  Timer? _timer;
  late Future<List<Question>> questions;
  late List<Question> questionList; // New variable to hold all questions
  int currentIndex = 0; // New variable to keep track of current index

  @override
  void initState() {
    super.initState();
    questions = QuestionService().getStarters();
    questions.then((value) {
      questionList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController cardController =
        SwipeableCardSectionController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Questions d\'usage'),
        ),
        body: SafeArea(
            child: FutureBuilder<List<Question>>(
          future: questions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SwipeableCardsSection(
                    cardController: cardController,
                    context: context,
                    items: questionList
                        .getRange(0, min(3, questionList.length))
                        .map((question) {
                      // Updated
                      return CardView(
                        id: question.id,
                        text: question.label,
                        choice0: question.choice0,
                        choice1: question.choice1,
                        progress: currentIndex / 10.0,
                      );
                    }).toList(),
                    onCardSwiped: (dir, index, widget) {
                      if (currentIndex <= 10) {
                        currentIndex++;
                      }
                      int questionId = (widget as CardView).id;
                      String questionLabel = (widget).text;
                      if (dir == Direction.left) {
                        RatingDTO ratingDTO =
                            RatingDTO(label: questionLabel, choice: false);
                        questionService.rating(questionId, ratingDTO);
                      } else if (dir == Direction.right) {
                        RatingDTO ratingDTO =
                            RatingDTO(label: questionLabel, choice: true);
                        questionService.rating(questionId, ratingDTO);
                      }

                      // Add the next card
                      if (currentIndex < questionList.length - 1) {
                        currentIndex++;
                        cardController.addItem(
                          CardView(
                            id: questionList[currentIndex].id,
                            text: questionList[currentIndex].label,
                            choice0: questionList[currentIndex].choice0,
                            choice1: questionList[currentIndex].choice1,
                            progress: currentIndex / 10.0,
                          ),
                        );
                      }
                    },
                    enableSwipeUp: false,
                    enableSwipeDown: false,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          child: const Icon(Icons.chevron_left),
                          onPressed: () => cardController.triggerSwipeLeft(),
                        ),
                        FloatingActionButton(
                          child: const Icon(Icons.chevron_right),
                          onPressed: () => cardController.triggerSwipeRight(),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        )));
  }
}
