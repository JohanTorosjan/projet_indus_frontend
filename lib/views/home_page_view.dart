import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_indus/services/AuthService.dart';

import '../models/client.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.client});

  final Client client;
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool active_session = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.client.has_active_session!);
    setState(() {
      active_session = widget.client.has_active_session!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade400,
                ),
              ),
            ),
            IconButton(
              iconSize: 32, // Increase the size of the button
              icon: const Icon(Icons.group),
              onPressed: () {
                // Navigate to friends page or show friend list and search field
              },
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.shade400,
                  ),
                ),
              ),
              IconButton(
                iconSize: 32, // Increase the size of the button
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // Navigate to the profile page
                },
              ),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Bubbles around the main button
          ...List.generate(
            10,
            (index) => Positioned(
              left: MediaQuery.of(context).size.width * 0.5 +
                  80 * cos(2 * pi * index / 10), // Add extra space
              top: MediaQuery.of(context).size.height * 0.5 +
                  80 * sin(2 * pi * index / 10), // Add extra space
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('OK insane'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(60),
                shape: const CircleBorder(),
                elevation: 4,
              ),
              child: active_session
                  ? const Text(
                      'Ma sortie de ce soir',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    )
                  : const Text("Sortir ce soir"),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade400,
                    Colors.purple.shade100,
                  ],
                ),
              ),
              child: Center(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('Plus de questions à mettre ici'),
                          actions: [
                            TextButton(
                              onPressed: () => FirebaseAuth.instance
                                  .signOut(), // Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Affiner tes envies',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
