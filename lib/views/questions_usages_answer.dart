import 'dart:async';
import 'package:projet_indus/DTOs/eventrequestdto.dart';
import 'package:projet_indus/services/eventservice.dart';
import 'package:projet_indus/views/event_view.dart';
import 'package:wave_progress_widget/wave_progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_indus/services/questionService.dart';
import 'package:projet_indus/views/question_usages.dart';

import '../models/client.dart';
import '../models/event.dart';
import '../models/friends.dart';
import '../models/questionsusage.dart';
import '../services/friendsService.dart';

class QuestionUsagesAnswer extends StatefulWidget {
  final Function close;
  final Client client;
  final List<Friends>? friends;
  final List<QuestionsUsage> questions;

  const QuestionUsagesAnswer(
      {Key? key,
      required this.client,
      required this.close,
      this.friends,
      required this.questions})
      : super(key: key);

  @override
  State<QuestionUsagesAnswer> createState() => _QuestionUsagesAnswerState();
}

class _QuestionUsagesAnswerState extends State<QuestionUsagesAnswer> {
  final QuestionService questionService = QuestionService();

  Timer? _timer;
  double _progress = 20;
  List<int?> responsesId = [];
  List<int?> questionsId = [];
  bool hasFinished = false;
  int currentQuestionIndex = 0;

  EventService eventService = EventService();
  bool _loading = false;

  @override
  void initState() {
    print(widget.friends);
    // TODO: implement initState
    super.initState();
  }

  void searchEvent() async {
    setState(() {
      _loading = true;
    });
    List<int>? users_id = [];
    users_id.add(widget.client.id!);
    if (widget.friends != null) {
      for (var users in widget.friends!) {
        users_id.add(users.id);
      }
    }

    EventRequestDTO eventRequestDTO = EventRequestDTO(
        users_id: users_id,
        usages_questions_ids: questionsId,
        usages_questions_answers_ids: responsesId);
    Event? event = await eventService.searchEvent(eventRequestDTO);

    if (event != null) {
      //widget.client.has_active_session = true;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EventView(client: widget.client,close: widget.close, event: event)),
      );
    } else {
      print("BUG");
    }
  }

  void submitResponse(int? questionId, int? responseId) {
    setState(() {
      if (hasFinished) {
        if (currentQuestionIndex == widget.questions.length - 1) {
          responsesId.removeLast();
          responsesId.add(responseId);
        }
        return null;
      }
      responsesId.add(responseId);
      questionsId.add(questionId);
      print("a");
      print(responsesId);
      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        hasFinished = true;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (currentQuestionIndex == 0) {
                Navigator.of(context).pop();
              } else {
                setState(() {
                  if (!hasFinished) {
                    hasFinished = false;
                    currentQuestionIndex = currentQuestionIndex - 1;
                    print(currentQuestionIndex);
                    print(responsesId.length);
                    if (currentQuestionIndex == responsesId.length - 1) {
                      questionsId.removeLast();
                      responsesId.removeLast();
                    }
                    print(responsesId);
                  } else {
                    questionsId.removeLast();
                    responsesId.removeLast();
                    questionsId.removeLast();
                    responsesId.removeLast();
                    currentQuestionIndex = currentQuestionIndex - 1;
                    print("else");
                    print(responsesId);
                    hasFinished = false;
                  }
                });
              }
            },
          ),
        ),
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
                    SizedBox(height: 100),

                    //const Spacer(),
                    // AnimatedOpacity(
                    //   opacity: showMessage ? 1.0 : 0.0,
                    //   duration: Duration(milliseconds: 500),
                    //   child: Container(
                    //     color:Colors.blue.shade900,
                    //     child: Center(
                    //       child: Text(
                    //         "Réponds maintenant à quelques questions d'usages pour que l'on puisse t'envoyer au bon endroit !",
                    //         style: TextStyle(
                    //           fontSize: 24,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 16),

                    Text(
                      widget.questions[currentQuestionIndex].label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 35),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget
                          .questions[currentQuestionIndex].answers!.length,
                      itemBuilder: (context, index) {
                        final answer = widget
                            .questions[currentQuestionIndex].answers![index];
                        //   return ListTile(

                        //     title: Text(
                        //       answer.label,
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 20,
                        //       ),
                        //     ),
                        //     onTap: () {
                        //       submitResponse(
                        //           widget.questions[currentQuestionIndex].id,
                        //           answer.id);
                        //     },
                        //   );
                        return InkWell(
                          onTap: () {
                            for (int i = 0;
                                i <
                                    widget.questions[currentQuestionIndex]
                                        .answers!.length;
                                i++) {
                              widget.questions[currentQuestionIndex].answers![i]
                                  .isSelected = false;
                            }
                            widget.questions[currentQuestionIndex]
                                .answers![index].isSelected = true;

                            submitResponse(
                                widget.questions[currentQuestionIndex].id,
                                answer.id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: answer.isSelected ? Colors.purple : null,
                            ),
                            child: ListTile(
                              title: Text(
                                answer.label,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: hasFinished
                          ? () {
                              searchEvent();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        primary:
                            hasFinished ? Colors.purple.shade400 : Colors.grey,
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text('Trouver une soirée'),
                    ),
                    Spacer(),
                    LinearProgressIndicator(
                      value:
                          (currentQuestionIndex + 1) / widget.questions.length,
                      backgroundColor: Colors.purple.shade100,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.purple.shade900),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            )));
  }
}
