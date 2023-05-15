import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projet_indus/models/client.dart';

class FirstQuestions extends StatefulWidget {
  const FirstQuestions({super.key, required this.client});

  final Client client;
  @override
  State<FirstQuestions> createState() => _FirstQuestionsState();
}

class _FirstQuestionsState extends State<FirstQuestions> {
  @override
  Widget build(BuildContext context) {
    print(widget.client.email);
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text('Sign Out MAIS LE NOUVO'),
        ),
        Text(widget.client.name!),
      ],
    )));
  }
}
