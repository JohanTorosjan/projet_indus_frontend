import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projet_indus/services/AuthService.dart';
import 'package:projet_indus/views/Wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'models/client.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await dotenv.load(fileName: ".env");
  // print("loaded");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //       title: 'Sortir Ce Soir',
  //       theme: ThemeData(
  //         // This is the theme of your application.
  //         //
  //         // Try running your application with "flutter run". You'll see the
  //         // application has a blue toolbar. Then, without quitting the app, try
  //         // changing the primarySwatch below to Colors.green and then invoke
  //         // "hot reload" (press "r" in the console where you ran "flutter run",
  //         // or simply save your changes to "hot reload" in a Flutter IDE).
  //         // Notice that the counter didn't reset back to zero; the application
  //         // is not restarted.
  //         primarySwatch: Colors.deepPurple,
  //       ),
  //       home: StreamBuilder<User?>(
  //           stream: FirebaseAuth.instance.authStateChanges(),
  //           builder: (context, snapshot) {
  //             final user = Provider.of<FirebaseUser?>(context);
  //             print(user.toString());
  //             if (snapshot.hasData) {
  //               if (user != null) {
  //                 return MainView(firebaseUser: user);
  //               }
  //               return AuthView();
  //             } else {
  //               return const AuthView();
  //             }
  //           }));
  // }
  
  @override
   Widget build(BuildContext context) {

    return StreamProvider<Client?>.value(
      
       value: AuthService().user.transform(StreamTransformer.fromHandlers(
    handleData: (futureClient, sink) async {
      sink.add(await futureClient);
    },
  )),
      initialData: null,
      
      child: MaterialApp(
          
        theme: ThemeData(
          
          brightness: Brightness.light,
          primaryColor: Colors.deepPurple,
          buttonTheme: ButtonThemeData(
            buttonColor:Colors.deepPurple,
            textTheme: ButtonTextTheme.primary,
            colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
          ),
          fontFamily: 'Inter',
        ),
        home: Wrapper(),
        
      ),);


  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text('Sign Out'),
            )

            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            //    Column(
            //     // Column is also a layout widget. It takes a list of children and
            //     // arranges them vertically. By default, it sizes itself to fit its
            //     // children horizontally, and tries to be as tall as its parent.
            //     //
            //     // Invoke "debug painting" (press "p" in the console, choose the
            //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
            //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            //     // to see the wireframe for each widget.
            //     //
            //     // Column has various properties to control how it sizes itself and
            //     // how it positions its children. Here we use mainAxisAlignment to
            //     // center the children vertically; the main axis here is the vertical
            //     // axis because Columns are vertical (the cross axis would be
            //     // horizontal).
            //     mainAxisAlignment: MainAxisAlignment.center,

            //     children: <Widget>[

            //       const Text(
            //         'You have pushed the button this many times:',
            //       ),
            //        Text(widget.title),

            //       Text(
            //         '$_counter',
            //         style: Theme.of(context).textTheme.headlineMedium,
            //       ),
            //     ],
            //   ),

            // ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: _incrementCounter,
            //   tooltip: 'Increment',
            //   child: const Icon(Icons.add),
            // ), // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}

