import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_indus/DAOs/clientdao.dart';
import 'package:projet_indus/main.dart';
import 'package:projet_indus/services/AuthService.dart';
import 'package:projet_indus/views/Handler.dart';
import 'package:projet_indus/views/home_page_view.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/client.dart';
import '../Wrapper.dart';

class ProfileView extends StatefulWidget {
  final Client client;

  const ProfileView({Key? key, required this.client}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _instaController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  bool _loading = false;
  bool _loadingPassword = false;

  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _emailController = TextEditingController(text: widget.client.email);
    _instaController =
        TextEditingController(text: "@${widget.client.instagram}");
    _dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(widget.client.dob!));
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.client.dob!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.purple.shade400, // Changed primary color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final age = _calculateAge(picked);
      if (age >= 18) {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Vous devez avoir au moins 18 ans')),
        );
      }
    }
  }

  int _calculateAge(DateTime date) {
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType
                    .leftToRight, // Spécifie la direction de la transition
                child: MainView(client: widget.client),
              ),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        '${_nameController.text} ${_calculateAge(widget.client.dob!)} ans',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(10),
                          //   gradient: LinearGradient(
                          //     colors: [
                          //       Colors.purple.shade400,
                          //       Colors.purple.shade900,
                          //     ],
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //   ),
                          // ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  //Assign controller
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Prénom obligatoire';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Prénom',
                                    focusColor: Colors.purple,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  //Assign controller
                                  controller: _instaController,
                                  decoration: const InputDecoration(
                                    hintText: '@instagram (optionnel)',
                                    focusColor: Colors.purple,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value != null) {
                                      if (value.contains('@') &&
                                          (value.endsWith('.com') ||
                                              value.endsWith('.fr') ||
                                              value.endsWith('.net'))) {
                                        return null;
                                      }
                                      return 'Entrez une adresse mail valide';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                    focusColor: Colors.purple,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  controller: _dateController,
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(
                                        FocusNode()); // Retire le focus du TextFormField
                                    _selectDate(context);
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Date de naissance obligatoire';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Date de naissance',
                                    focusColor: Colors.purple,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  //Assign controller
                                  controller: _passwordController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return null;
                                    }
                                    if (value.trim().length < 8) {
                                      return 'Le mot de passe doit faire au moins 8 caractères';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Nouveau mot de passe',
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.purple,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  //Assign controller
                                  controller: _passwordController2,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return null;
                                    }
                                    if (value.trim().length < 8) {
                                      return 'Le mot de passe doit faire au moins 8 caractères';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Confirmer',
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.purple,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Se déconnecter",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        iconSize:
                                            32, // Increase the size of the button
                                        icon: const Icon(
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .leftToRightWithFade, // Spécifie la direction de la transition
                                              child: MyApp(),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 60,
                                ),

                                ///////////////////////////////////////////
                              ],
                            ),
                          )),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple.shade400,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => handleSubmit(),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Mettre à jour',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      Spacer(),
                    ],
                  )))),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create a new Client instance with updated data
      Client updatedClient = Client(
        id: widget.client.id,
        firebase_id: widget.client.firebase_id,
        name: _nameController.text,
        email: _emailController.text,
        instagram: _instaController.text,
        dob: DateFormat('dd/MM/yyyy').parse(_dateController.text),
        has_active_session: widget.client.has_active_session,
        answered_questions: widget.client.answered_questions,
      );

      ClientDAO clientDao = ClientDAO();
      try {
        Client result = await clientDao.updateClient(updatedClient);
        if (result.id != null) {
          // check if the update was successful
          // Check if the widget is still in the tree
          if (mounted) {
            // Navigate away or show a success message
            Navigator.of(context).pop();
          }
        } else {
          // Show an error message
          print("Failed to update client");
        }
      } catch (err) {
        // Handle any errors here.
        print("Failed to update client: $err");
      }
    }
  }

  handleSubmit() async {
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) return null;

    if (_passwordController.text.isNotEmpty) {
      if (_passwordController.text != _passwordController2.text) {
        scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text('Les mots de passes doivent être similaires')));
        return null;
      }
      showPop(true);
    } else {
      showPop(false);
    }
  }

  showPop(bool updatePassword) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400,
                  Colors.purple.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Veuillez confimer votre mot de passe actuel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      //Assign controller
                      controller: _passwordConfirmation,
                      obscureText: true,
                      textAlign: TextAlign.center,

                      decoration: const InputDecoration(
                        focusColor: Colors.purple,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.purple,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade600,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          updateAccount(updatePassword);
                        },
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        )),
                  ],
                )),
          ),
          backgroundColor: Colors
              .transparent, // Définir la couleur de fond de l'AlertDialog comme transparente
          elevation: 0, // Supprimer l'ombre de l'AlertDialog
        );
      },
    );
  }

  void updateAccount(bool updatePassword) async {
    setState(() {
      _loading = true;
    });
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);
    bool passwordOk = await verifyPassword();
    if (!passwordOk) {
      setState(() {
        _loading = false;
      });
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Mot de passe incorect')),
      );
      return null;
    }

    try {
      Client updatedClient = await authService.updateAccount(
          widget.client,
          _emailController.text,
          _passwordController.text,
          _instaController.text,
          _nameController.text,
          _dateController.text,
          updatePassword);
      setState(() {
        _loading = false;
      });
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Profil mis à jour')),
      );
    } catch (err) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Une erreur est survenue')),
      );
    }
  }

  Future<bool> verifyPassword() async {
    return await authService.verifyPassword(
        widget.client.email!, _passwordConfirmation.text);
  }
}
