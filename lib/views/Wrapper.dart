
import 'package:flutter/cupertino.dart';
import 'package:projet_indus/views/Handler.dart';
import 'package:projet_indus/views/MainView.dart';
import 'package:provider/provider.dart';
import '../models/FirebaseUser.dart';

class Wrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    final user =  Provider.of<FirebaseUser?>(context);

    if(user == null)
    {
      return Handler();
    }
    else if (user.uid == null)
    {
      return Handler();
    }
    else
    {
      return MainView(firebaseUser: user);
    }

  }
}