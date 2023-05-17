import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_indus/models/friends.dart';
import 'package:projet_indus/services/friendsService.dart';
import 'package:projet_indus/views/questions_usages_answer.dart';
import '../models/client.dart';

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
  List<Friends> friends = [];
  List<Friends> selectedFriends = [];

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  void fetchFriends() async {
    List<Friends> friendsData =
        await friendsService.getFriends(widget.client.id!);
    setState(() {
      friends = friendsData;
    });
  }

  void handleNextPage() {
    selectedFriends = friends.where((friend) => friend.selected).toList();
    Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => QuestionUsagesAnswer(client: widget.client,close: widget.close,friends: selectedFriends,)),
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
        title: Text(
          'Avec des ami.es ? ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Inter',
          ),
        ),
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
                const Spacer(), // Ajoute un espace flexible au-dessus du texte
                // Text(
                //   'Avec des ami.es ? ',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
                // SizedBox(height: 20),
                Expanded(
                  child:friends.length>0?
                  ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        
                          title: Text(friends[index].name,style: TextStyle(
                            
                            fontSize: 20,
                            
                              color: Colors.white,
                        ),),
                          value: friends[index].selected,
                          activeColor: friends[index].selected?  Colors.purple.shade400:null,
                           secondary: Icon(
                                Icons.person,
                                color: Colors.green,
                              ),
                          onChanged: (bool? value) {
                            setState(() {
                              friends[index].selected = value ?? false;
                            });
                          });
                      // return ListTile(
                      //   leading: Icon(Icons.person),
                      //   title: Text(friends[index].name),
                      // );
                    },)
                    :Center(child: const Text(
                          "Tu n'as pas encore d'ami.es ... Sors pour en trouver ! ",
                          textAlign: TextAlign.center,
                        style: TextStyle(
                        
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                          color: Colors.white,
                    ),
                  )),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Répondre à quelques questions ->'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    handleNextPage();
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
