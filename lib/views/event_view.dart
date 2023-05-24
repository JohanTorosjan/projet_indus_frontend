import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projet_indus/DAOs/clientdao.dart';
import 'package:projet_indus/services/eventservice.dart';
import 'package:projet_indus/views/home_page_view.dart';

import 'package:url_launcher/url_launcher.dart';

import '../models/client.dart';
import '../models/event.dart';

class EventView extends StatefulWidget {
  const EventView(
      {Key? key, required this.client, required this.close, this.event})
      : super(key: key);
  final Event? event;
  final Function close;
  final Client client;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  bool hasClicked = false;
  bool confirmed = false;
  final EventService eventService = EventService();
  void openGoogleMaps() async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.event!.infrastructure.adresse}';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Impossible d\'ouvrir Google Maps';
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.event!.participants.length; i++) {
      if (widget.event!.participants[i].id == widget.client.id) {
        setState(() {
          confirmed = widget.event!.participants[i].isConfirmedAccount;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // title: Text(
            //   "Réponds à quelques questions pour qu'on puisse t'envoyer au bonne endroit",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 30,
            //     color: Color.fromARGB(255, 255, 255, 255),
            //     fontFamily: 'Inter',
            //   ),
            // ),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                if (widget.close != null) {
                  widget.client.has_active_session = true;
                  Navigator.pushAndRemoveUntil(
                    context,
                      PageTransition(
                        type: PageTransitionType
                            .fade, // Spécifie la direction de la transition
                        child: MainView(client: widget.client),
                      ),
                  (route) => false,
                  );
                  widget.close();
                } else {
                  Navigator.of(context).pop();
                }

                // if (widget.client.has_active_session == false) {
                //   widget.client.has_active_session = true;
                //   Navigator.push(
                //       context,
                //       PageTransition(
                //         type: PageTransitionType
                //             .fade, // Spécifie la direction de la transition
                //         child: MainView(client: widget.client),
                //       ));
                // } else {
                //    Navigator.push(
                //       context,
                //       PageTransition(
                //         type: PageTransitionType
                //             .fade, // Spécifie la direction de la transition
                //         child: MainView(client: widget.client),
                //       ));
                // }
              },
            )),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade900,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 116),
                  Text(
                    'Rendez vous : ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    height: 400,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade400,
                          Colors.purple.shade900,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              'Au ${widget.event!.infrastructure.type.toLowerCase()}\n "${widget.event!.infrastructure.name}"',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            GestureDetector(
                              onTap: openGoogleMaps,
                              child: Text(
                                '${widget.event!.infrastructure.adresse}',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.wavy,
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Text(
                              '${formateTime(widget.event!.starting_hour)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 1,
                          color: Colors.purple.shade400,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Icon(
                              Icons.star_rate,
                              color: Colors.yellowAccent,
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Text(
                              'Matching  \n${widget.event!.percentage_of_matching} %',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Icon(
                              Icons.star_rate,
                              color: Colors.yellowAccent,
                            ),
                            Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 1,
                          color: Colors.purple.shade400,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.event!.participants.isEmpty
                            ? Text(
                                "Cette événement a été créé juste pour toi.\nReviens pour voir qui l'a rejoint",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )
                            : Expanded(
                                child:
                                    //     :Expanded(child: ListView(
                                    //       children:[
                                    // //     Column(children:
                                    // //      [
                                    // //       const SizedBox(
                                    // //   height: 10,
                                    // // ),
                                    //       Text(
                                    //                 "Participants :",
                                    //                 textAlign: TextAlign.center,
                                    //                 style: TextStyle(
                                    //                   color: Colors.white,
                                    //                   fontSize: 20,
                                    //                 ),
                                    //               ),

                                    ListView.builder(
                                  //shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: widget.event!.participants.length,
                                  itemBuilder: (context, index) {
                                    if (widget.event!.participants[index].id !=
                                        widget.client.id) {
                                      return ListTile(
                                        title: Text(
                                          "${widget.event!.participants[index].name} - ${widget.event!.participants[index].age} ans",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: widget
                                                  .event!
                                                  .participants[index]
                                                  .isConfirmedAccount
                                              ? Colors.blue.shade900
                                              : Colors.white,
                                          child: Icon(
                                            Icons.check,
                                            color: widget
                                                    .event!
                                                    .participants[index]
                                                    .isConfirmedAccount
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ListTile(
                                        title: Text(
                                          "${widget.event!.participants[index].name} - ${widget.event!.participants[index].age} ans",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: confirmed
                                              ? Colors.blue.shade900
                                              : Colors.white,
                                          child: Icon(Icons.check,
                                              color: Colors.white),
                                        ),
                                      );
                                    }
                                  },
                                ),

                                //   ]
                                // ),
                                // )

                                // )
                                //])
                                //),
                              ),
                      ],
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        confirmeAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: hasClicked
                            ? Colors.blue.shade600
                            : Colors.purple.shade400,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: !confirmed
                          ? Row(
                              children: [
                                Icon(Icons.check),
                                Spacer(),
                                Text("Confirmer sa présence"),
                                Spacer()
                              ],
                            )
                          : Row(
                              children: [
                                Icon(Icons.close),
                                Spacer(),
                                Text("Annuler"),
                                Spacer()
                              ],
                            )),
                  Spacer(),
                ],
              ),
            ),
          ),
        ));
  }

  String formateTime(DateTime starting_hour) {
    final formattedTime = DateFormat('HH:mm').format(starting_hour);
    final hour = formattedTime.split(':')[0];
    return '${hour}h';
  }

  void confirmeAccount() async {
    if (confirmed) {
      //TODO
    } else {
      await eventService.confirmAccount(widget.client.id);
    }
    //setState(() => hasClicked = !hasClicked);
    setState(() {
      // widget.client.confirmed = true;
      confirmed = !confirmed;
    });
  }
}
