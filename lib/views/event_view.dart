import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_indus/views/home_page_view.dart';

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
                if (widget.client.has_active_session == false) {
                  widget.client.has_active_session = true;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainView(client: widget.client)));
                } else {
                  widget.close();
                }
              },
            )),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 116),
                  Text(
                    'Rendez vous : ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 35),
                  Text('$widget.event.infrastructure.type')
                ],
              ),
            ),
          ),
        ));
  }
}
