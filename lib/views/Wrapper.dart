import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_indus/models/client.dart';
import 'package:projet_indus/views/Handler.dart';
import 'package:projet_indus/views/MainView.dart';
import 'package:projet_indus/views/firstquestions.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Client?>(context);

    print("PAS DE USER");
    print(user == null);
    print("??");

    if (user != null) {
      print(user.answered_questions);
    }

    if (user == null) {
      print("ok ici");
      return Handler();
    }
    if (user.answered_questions == 0) {
      print("HAS ANSWERED FAUX");
      print(user);
      return FirstQuestions(client: user);
    } else if (user.answered_questions == null) {
      print("ok la");
      return Handler();
    }
    print("HAS ANSWERED VRAI");
    return MainView(client: user);
  }
  // if (user == null) {
  //   return Handler();
  // } else if (user.has_active_session == "CONNECTED") {

  //   return MainView(
  //     firebaseUser: user,
  //   );
  // } else if (user.code == "CREATING") {
  //   return FirstQuestions(
  //     firebaseUser: user,
  //   );
  // } else {
  //   print(user.code);
  //   return Text("nsm");
  // }
}
