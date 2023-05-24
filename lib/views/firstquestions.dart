import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projet_indus/DTOs/ratingdto.dart';
import 'package:projet_indus/models/client.dart';
import 'package:projet_indus/models/question.dart';
import 'package:projet_indus/services/AuthService.dart';
import 'package:projet_indus/services/questionService.dart';
import 'package:projet_indus/views/card_view.dart';
import 'package:projet_indus/views/home_page_view.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

class FirstQuestions extends StatefulWidget {
  const FirstQuestions({Key? key, required this.client}) : super(key: key);

  final Client client;

  @override
  State<FirstQuestions> createState() => _FirstQuestionsState();
}

class _FirstQuestionsState extends State<FirstQuestions> {
  final QuestionService questionService = QuestionService();

  late Future<List<Question>> questions;
  late List<Question> questionList;
  int currentIndex = 0;
  int nextCardIndex = 3;


  Timer? _timer;
  bool _showText = true;

@override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();

  _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showText = false;
      });
    });


    questions = questionService.getStarters();


    questions.then((value) {
      questionList = value;
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
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade600,
                  Colors.blue.shade900,
                ],
                begin: Alignment.topLeft, // Point de départ du dégradé
                end: Alignment.bottomRight, // Point d'arrivée du dégradé
              ),
            ),
            child: 
            
            SafeArea(
              
                child: 
                Column(children: [
                FutureBuilder<List<Question>>(
              future: questions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return 
                      SwipeableCardsSection(
                        cardController: cardController,
                        context: context,
                        items: questionList
                            .getRange(0, min(3, questionList.length))
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

                          if (currentIndex == 10) {
                            swipeToMain();
                          }

                          // Add the next card
                          if (nextCardIndex < questionList.length) {
                            cardController.addItem(_createCard(
                                questionList[nextCardIndex], currentIndex));
                            nextCardIndex++; // Increment nextCardIndex
                          }
                        },
                        enableSwipeUp: false,
                        enableSwipeDown: false,
                      );
                }
              }
            
            )])
            )      

             
              )
              );
                }
      

  

  void swipeToMain() {
    Navigator.of(context).push(PageTransition(
        alignment: Alignment.center,
        type:
            PageTransitionType.scale, // Spécifie la direction de la transition
        child: MainView(client: widget.client)));
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade900,
              ],
              begin: Alignment.topLeft, // Point de départ du dégradé
              end: Alignment.bottomRight, // Point d'arrivée du dégradé
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ));
  }
}
