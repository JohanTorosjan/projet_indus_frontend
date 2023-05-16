import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_indus/services/AuthService.dart';
import 'package:projet_indus/views/bunch_of_quesions.dart';
import 'package:projet_indus/views/card_view.dart';
import 'package:projet_indus/views/firstquestions.dart';
import 'package:projet_indus/views/question_usages.dart';

import '../models/client.dart';
import 'package:flutter/material.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.client});

  final Client client;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  bool afficherNouvelleVue = false;

  bool active_session = true;

  @override
  void initState() {
    super.initState();
    setState(
      () => active_session = widget.client.has_active_session!,
    );
  }

  void closeMainButton() {
    setState(() {
      afficherNouvelleVue = !afficherNouvelleVue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double draggableSheetHeight = 0.1;
    final shadow = Shadow(
      color: Colors.black.withOpacity(0.4),
      offset: Offset(0, 2),
      blurRadius: 4,
    );

    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: !afficherNouvelleVue
          ? AppBar(
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
            )
          : null,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Bubbles around the main button
          // ...List.generate(
          //   10,
          //   (index) => Positioned(
          //     left: MediaQuery.of(context).size.width * 0.5 +
          //         80 * cos(2 * pi * index / 10), // Add extra space
          //     top: MediaQuery.of(context).size.height * 0.5 +
          //         80 * sin(2 * pi * index / 10), // Add extra space
          //     child: Container(
          //       width: 24,
          //       height: 24,
          //       decoration: BoxDecoration(
          //         color: Colors.blue.shade300,
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // ),
          Center(
//  child: ScaleTransition(
//           scale: _animation,
//           child: ElevatedButton(
//             child: const Text('Appeler la nouvelle vue'),
//             onPressed: _afficherNouvelleVue,
//           ),
//         ),

            child: !active_session
                ? AnimatedSizeAndFade(
                    vsync: this,
                    fadeDuration: Duration(milliseconds: 300),
                    child: afficherNouvelleVue
                        ? QuestionUsages(
                            client: widget.client,
                            close: closeMainButton,
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                afficherNouvelleVue = true;
                              });
                            },
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.blue.shade900,
                                  ],
                                ),
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  'Sortir\n\nCe\n\nSoir',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [shadow],
                                  ),
                                ),
                              ),
                            ),
                          ))
                : AnimatedSizeAndFade(
                    vsync: this,
                    fadeDuration: Duration(milliseconds: 300),
                    child: afficherNouvelleVue
                        ? //TODO -> CHANGER EN VUE EVENEMENT
                        QuestionUsages(
                            client: widget.client,
                            close: closeMainButton,
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                afficherNouvelleVue = true;
                              });
                            },
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.blue.shade900,
                                  ],
                                ),
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  'Ma Sortie\n\nde Ce\n\nSoir',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [shadow],
                                  ),
                                ),
                              ),
                            ),
                          )),

            // child: ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => QuestionUsages(client: widget.client,)),
            // );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     padding: const EdgeInsets.all(60),
            //     shape: const CircleBorder(),
            //     elevation: 4,
            //   ),
            //   child: active_session
            //       ? const Text(
            //           'Ma sortie de ce soir',
            //           style: TextStyle(fontSize: 24, color: Colors.white),
            //         )
            //       : const Text("Sortir ce soir"),
            // ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.99,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                 //child: CardView(id: 2, text: "bonjour@", choice0: 'kdfk', choice1: 'okok', progress: 3)
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 1, // Nombre d'éléments dans la liste
                  itemBuilder: (BuildContext context, int index) {
                    //return CardView(id: 2, text: "bonjour@", choice0: 'kdfk', choice1: 'okok', progress: 3);
                    
                  },
                ),
              );
            },
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: MediaQuery.of(context).size.height * 0.1,
          //     decoration: BoxDecoration(
          //       borderRadius: const BorderRadius.only(
          //         topLeft: Radius.circular(30),
          //         topRight: Radius.circular(30),
          //       ),
          //       gradient: LinearGradient(
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //         colors: [
          //           Colors.purple.shade400,
          //           Colors.purple.shade100,
          //         ],
          //       ),
          //     ),
          //     child: Center(
          //       child: InkWell(
          //         onTap: () {
          //           showDialog(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return AlertDialog(
          //                 content: const Text('Plus de questions à mettre ici'),
          //                 actions: [
          //                   TextButton(
          //                     onPressed: () => FirebaseAuth.instance
          //                         .signOut(), // Navigator.of(context).pop(),
          //                     child: const Text('Close'),
          //                   ),
          //                 ],
          //               );
          //             },
          //           );
          //         },
          //         child: const Text(
          //           'Affiner tes envies',
          //           style: TextStyle(
          //             fontSize: 18,
          //             color: Colors.white,
          //             decoration: TextDecoration.underline,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          
        ],
        
      ),
     
    );
  }
}
