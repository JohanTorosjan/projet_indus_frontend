import 'package:flutter/material.dart';
import 'package:projet_indus/models/client.dart';
import 'package:projet_indus/models/question.dart';
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
  int counter = 0;
  late Future<List<Question>> questions;

  @override
  void initState() {
    super.initState();
    questions = QuestionService().getStarters();
  }

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController cardController = SwipeableCardSectionController();

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
                        items: snapshot.data!.map((question) {
                          return CardView(
                            text: question.label,
                            choice0: question.choice0,
                            choice1: question.choice1,
                            progress: counter / 10.0,
                          );
                        }).toList(),
                        onCardSwiped: (dir, index, widget) {
                          if (counter <= 10) {
                            counter++;
                          }

                          if (dir == Direction.left) {
                            print('onDisliked ${(widget as CardView).text} $index');
                          } else if (dir == Direction.right) {
                            print('onLiked ${(widget as CardView).text} $index');
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
            )
        )
    );
  }
}

