import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_indus/models/friends.dart';
import 'package:projet_indus/services/friendsService.dart';
import 'package:projet_indus/services/questionService.dart';
import 'package:projet_indus/views/questions_usages_answer.dart';
import '../models/client.dart';
import '../models/questionsusage.dart';

class QuestionUsages extends StatefulWidget {
  final Function close;
  final Client client;

  const QuestionUsages({Key? key, required this.client, required this.close})
      : super(key: key);

  @override
  State<QuestionUsages> createState() => _QuestionUsagesState();
}

class _QuestionUsagesState extends State<QuestionUsages> {
  final FriendsService friendsService = FriendsService();
  final QuestionService questionService = QuestionService();
  List<Friends> friends = [];
  List<Friends> selectedFriends = [];
  List<QuestionsUsage> questions = [];
  @override
  void initState() {
    super.initState();
    fetchFriends();
    fetchQuestionUsage();
  }

  void fetchFriends() async {
    List<Friends> friendsData =
        await friendsService.getFriends(widget.client.id!);
    setState(() {
      friends = friendsData;
    });
  }

  void fetchQuestionUsage() async {
    List<QuestionsUsage> questionsData =
        await questionService.getQuestionsUsage();

    setState(() {
      questions = questionsData;
    });
  }

  void handleNextPage() {
    selectedFriends = friends.where((friend) => friend.selected).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuestionUsagesAnswer(
                client: widget.client,
                close: widget.close,
                friends: selectedFriends,
                questions: questions,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();

    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: Text(
        //   'Avec des ami.es ? ',
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
            widget.close();
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
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(height: 116),
                Text(
                  'Avec des ami.es ? ',
                //  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ), // Ajoute un espace flexible au-dessus du texte
                // Text(
                //   'Avec des ami.es ? ',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                // SizedBox(height: 20),
               Spacer(),
                Expanded(
                  child: friends.length > 0
                      ? ListView.builder(
                                    itemCount: friends.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
            title: Text(
              friends[index].name,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onTap: () {
              setState(() {
                friends[index].selected = !friends[index].selected;
              });
            },
            leading: CircleAvatar(
              backgroundColor: friends[index].selected ? Colors.purple.shade400 : Colors.transparent,
              child: Icon(
                Icons.person,
                color: friends[index].selected ? Colors.white : Colors.purple.shade400,
              ),
            ),
          );

                            // return ListTile(
                            //   leading: Icon(Icons.person),
                            //   title: Text(friends[index].name),
                            // );
                          },
                        )
                      : Center(
                          child: const Text(
                          "Tu n'as pas encore d'ami.es ... sors pour en trouver ! ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                ),
                SizedBox(height: 20),
              Spacer(),
                ElevatedButton(
                  child: Text('Répondre à quelques questions ->'),
                  style: ElevatedButton.styleFrom(
                        primary:
                            Colors.purple.shade400,
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                  onPressed: () {
                    handleNextPage();
                  },
                ),
                Spacer(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
