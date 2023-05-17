import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/client.dart';
import '../models/friends.dart';

class QuestionUsagesAnswer extends StatefulWidget {
  final Function close;
  final Client client;
  final List<Friends>? friends;

  const QuestionUsagesAnswer(
      {Key? key, required this.client, required this.close,this.friends})
      : super(key: key);

  @override
  State<QuestionUsagesAnswer> createState() => _QuestionUsagesAnswerState();
}

class _QuestionUsagesAnswerState extends State<QuestionUsagesAnswer> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("ok"));
  }
}
