import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_indus/services/AuthService.dart';
import 'package:projet_indus/services/eventservice.dart';
import 'package:projet_indus/views/bunch_of_quesions.dart';
import 'package:projet_indus/views/card_view.dart';
import 'package:projet_indus/views/event_view.dart';
import 'package:projet_indus/views/firstquestions.dart';
import 'package:projet_indus/views/profile/profile_view.dart';
import 'package:projet_indus/views/question_usages.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:wave_progress_widget/wave_progress.dart';

import '../models/client.dart';
import 'package:flutter/material.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';

import '../models/event.dart';

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
  double draggableSheetHeight = 0.1;

  late AnimationController _animationController;
  late Animation<double> _animation;


  Event? event;
  EventService eventService = EventService();
  @override
  void initState() {
    super.initState();


    // if (event == null) {
    //   widget.client.has_active_session = true;
    // }

    setState(
      () => active_session = widget.client.has_active_session!,
    );
    // Créer l'AnimationController avec une durée et un vsync
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Définir la courbe d'animation (par exemple, une courbe en forme de pulsation)
    final curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Définir l'animation en utilisant un Tween pour animer la propriété souhaitée (par exemple, l'échelle)
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(curve);

    // Démarrer l'animation en boucle
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void closeMainButton() {
    setState(() {
      afficherNouvelleVue = !afficherNouvelleVue;
    });
  }

  void closeSwipeSection() {
    setState(() {
      draggableSheetHeight = 0.1;
    });
  }

  void fetchEvent() async {
    Event? eventFuture =  await eventService.getEvent(widget.client.id);
    setState(() {
         event = eventFuture;
    });
    if(eventFuture != null){
      setState(() {
        widget.client.has_active_session = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                       gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.blue.shade900,
                                  ],
                                ),
                      ),
                    ),
                  ),
                  IconButton(
                    iconSize: 32, // Increase the size of the button
                    icon: const Icon(Icons.group),
                    onPressed: () {},
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
                         gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.blue.shade900,
                                  ],
                                ),
                        ),
                      ),
                    ),
                    IconButton(
                        iconSize: 32, // Increase the size of the button
                        icon: const Icon(Icons.account_circle),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ProfileView(client: widget.client);
                              });
                        }),
                  ],
                ),
              ],
            )
          : null,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
              Colors.purple.shade900,
          ],
          begin: Alignment.topLeft, // Point de départ du dégradé
          end: Alignment.bottomRight, // Point d'arrivée du dégradé
        ),
      ),
        child:
      Stack(

        children: [
          
          Center(
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
                              width: 250,
                              height: 250,
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ))
                : AnimatedSizeAndFade(
                    vsync: this,
                    fadeDuration: Duration(milliseconds: 300),
                    child: afficherNouvelleVue
                        ? 
                       EventView(client: widget.client,close: closeMainButton, event: event)
                        : InkWell(
                            onTap: () {
                              setState(() {
                                afficherNouvelleVue = true;
                              });
                            },
                            child: Container(
                              width: 250,
                              height: 250,
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )),
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
      )
    );
  }
}
