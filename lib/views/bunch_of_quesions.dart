import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../DTOs/ratingdto.dart';
import '../models/client.dart';
import '../models/question.dart';
import '../services/questionService.dart';
import 'card_view.dart';
import 'home_page_view.dart';

class BunchOfQuestions extends StatefulWidget {
  const BunchOfQuestions(
      {Key? key,
      required this.client,
      required this.close,
      required this.questions})
      : super(key: key);
  final Function close;
  final Client client;
  final List<Question> questions;

  @override
  State<BunchOfQuestions> createState() => _BunchOfQuestionsState();
}

class _BunchOfQuestionsState extends State<BunchOfQuestions> {
  final QuestionService questionService = QuestionService();

  int currentIndex = 0;
  int nextCardIndex = 3;
  List<Question> questionsList = [];
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
  void initState() {
    setState(() {
      questionsList = widget.questions;
    });
    print(questionsList);
    print(questionsList);
    print(questionsList);
    print(questionsList);
    print(questionsList);
    print(questionsList);
  }

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController cardController =
        SwipeableCardSectionController();
    int? idUtilisateur = widget.client.id;
    int questionsLength = widget.questions.length;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // title: Text(
          //   'Avec des ami.es ? ',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 30,
          //     color: Color.fromARGB(255, 255, 255, 255),
          //     fontFamily: 'Inter',
          //   ),
          // ),
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade600,
                  Colors.blue.shade900,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 
                  SwipeableCardsSection(
                    cardController: cardController,
                    context: context,
                    items: questionsList
                        .getRange(0, min(3, questionsList.length))
                        .toList() // Convert Iterable to List
                        .asMap() // Convert to a map to get index and value
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
                        RatingDTO ratingDTO =
                            RatingDTO(id: questionId, choice: true);
                        questionService.rating(idUtilisateur!, ratingDTO);
                      }

                      // Increment currentIndex after the card swipe action is complete
                      if (currentIndex < 10) {
                        currentIndex++;
                      }
                      if (currentIndex == questionsLength) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.purple.shade400,
                              title: Text(
                                "Tu as répondu à toutes les questions pour aujourd'hui !\nReviens demain pour de nouvelles questions",
                                textAlign: TextAlign.center,
                              ),
                              actions: <Widget>[
                                Center(
                                  child: ElevatedButton(
                                    child: Text('Ok'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue.shade600,
                                      onPrimary: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      close();
                                    },
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }

                      // Add the next card
                      if (nextCardIndex < questionsLength) {
                        cardController.addItem(_createCard(
                            questionsList[nextCardIndex], currentIndex));
                        nextCardIndex++; // Increment nextCardIndex
                      }
                    },
                    enableSwipeUp: false,
                    enableSwipeDown: false,
                  ),
                 
                ],
              ),
            )));

    return questionsLength > 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SwipeableCardsSection(
                cardController: cardController,
                context: context,
                items: widget.questions
                    .getRange(0, min(3, widget.questions.length))
                    .toList() // Convert Iterable to List
                    .asMap() // Convert to a map to get index and value
                    .map((index, question) =>
                        MapEntry(index, _createCard(question, index)))
                    .values
                    .toList(),
                onCardSwiped: (dir, index, widget) {
                  int questionId = (widget as CardView).id;
                  Question question = Question(
                      choice0: widget.choice0,
                      choice1: widget.choice1,
                      label: widget.text,
                      id: widget.id);
                  if (dir == Direction.left) {
                    RatingDTO ratingDTO =
                        RatingDTO(id: questionId, choice: false);
                    questionService.rating(idUtilisateur!, ratingDTO);
                  } else if (dir == Direction.right) {
                    RatingDTO ratingDTO =
                        RatingDTO(id: questionId, choice: true);
                    questionService.rating(idUtilisateur!, ratingDTO);
                  }

                  // Increment currentIndex after the card swipe action is complete
                  if (currentIndex < 10) {
                    currentIndex++;
                  }

                  // Add the next card
                  if (nextCardIndex < questionsLength) {
                    cardController.addItem(_createCard(
                        questionsList[nextCardIndex], currentIndex));
                    nextCardIndex++; // Increment nextCardIndex
                  }
                },
                enableSwipeUp: false,
                enableSwipeDown: false,
              ),
            ],
          )
        : Text("TTTT");
  }

  void close() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType
            .leftToRight, // Spécifie la direction de la transition
        child: MainView(client: widget.client),
      ),
    );
  }
}
