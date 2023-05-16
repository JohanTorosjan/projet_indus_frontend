import 'package:flutter/cupertino.dart';

import '../models/client.dart';

class BunchOfQuestions extends StatefulWidget {
  const BunchOfQuestions({Key? key, required this.client}) : super(key: key);

  final Client client;

  @override
  State<BunchOfQuestions> createState() => _BunchOfQuestionsState();
}

class _BunchOfQuestionsState extends State<BunchOfQuestions> {
  @override
  Widget build(BuildContext context) {
    return Text("ok insane",style: TextStyle(fontSize: 1000),);
  }
}
