import 'dart:math';

import './card_view.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 4;

  @override
  Widget build(BuildContext context) {
    //create a CardController
    SwipeableCardSectionController cardController =
    SwipeableCardSectionController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SwipeableCardsSection(
            cardController: cardController,
            context: context,
            //add the first 3 cards
            items: const [
              CardView(id: 0, text: "question 1", choice0: "Choix 0", choice1: "Choix 1", progress: 0),
              CardView(id: 1, text: "question 2", choice0: "Choix 0", choice1: "Choix 1", progress: 0.5),
              CardView(id: 2, text: "question 3", choice0: "Choix 0", choice1: "Choix 1", progress: 1)
            ],
            onCardSwiped: (dir, index, widget) {
              //Add the next card
              if (counter <= 20) {
                cardController.addItem(CardView(id: counter, text: "Card $counter", choice0: "Choix 0", choice1: "Choix 1", progress: (Random().nextDouble() * 1.0)));
                counter++;
              }

              if (dir == Direction.left) {
                print('onDisliked ${(widget as CardView).text} $index');
              } else if (dir == Direction.right) {
                print('onLiked ${(widget as CardView).text} $index');
              } else if (dir == Direction.up) {
                print('onUp ${(widget as CardView).text} $index');
              } else if (dir == Direction.down) {
                print('onDown ${(widget as CardView).text} $index');
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
      ),
    );
  }
}