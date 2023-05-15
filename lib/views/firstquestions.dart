import 'package:flutter/material.dart';
import 'package:projet_indus/models/client.dart';
import 'package:projet_indus/views/card_view.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'dart:math';

class FirstQuestions extends StatefulWidget {
  const FirstQuestions({Key? key, required this.client}) : super(key: key);

  final Client client;

  @override
  State<FirstQuestions> createState() => _FirstQuestionsState();
}

class _FirstQuestionsState extends State<FirstQuestions> {
  int counter = 4;
  late List<Question> questions;

  @override
  void initState() {
    super.initState();
    questions = get10FirstQuestions();
  }

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController cardController = SwipeableCardSectionController();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Questions d\'usage'),
        ),
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SwipeableCardsSection(
                  cardController: cardController,
                  context: context,
                  items: questions.map((question) {
                    return CardView(
                      text: question['label'],
                      choice0: question['choix0'],
                      choice1: question['choix1'],
                      progress: counter / 10.0,
                    );
                  }).toList(),
                  onCardSwiped: (dir, index, widget) {
                    if (counter <= 20) {
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
            )
        )
    );
  }
}
