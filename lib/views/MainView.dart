import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projet_indus/models/client.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.client});

  final Client client;
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
      
        child:Column(children: [ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text('Sign Out'),
            ),
          Text(widget.client.name!),
            ],)
       
    )
    );
  }
}
