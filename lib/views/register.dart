import 'package:flutter/cupertino.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/AuthService.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _loading = false;
  bool _error = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _instaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return null;
    setState(() => _loading = true);

    final email = _emailController.value.text;
    final password = _passwordController.value.text;
    final prenom = _prenomController.value.text;
    final insta = _instaController.value.text.isEmpty
        ? ""
        : _passwordController.value.text;
    final dob = _dateController.value.text;
    Client user = await AuthService()
        .registerWithEmailAndPassword(email, password, prenom, insta, dob);
    if (user.firebase_id == null) {
      _error = true;
      setState(() => _error = true);
    }
    else {
      print('NEW USER FROM VUE : ');
      print(user.firebase_id);
      Client finaluser =
          await AuthService().loginWithEmailAndPassword(email, password);
    }
    setState(() => _loading = false);
    //  FirebaseUser firebaseUser =
    //     await AuthService().registerWithEmailAndPassword(email, password);

    // if (firebaseUser.uid == null) {
    //   _error = true;
    //   print(_error);
    //   setState(() => _error = true);
    // }
    setState(() => _loading = false);
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Color.fromARGB(255, 0, 0, 0), // Changez la couleur ici
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous devez avoir au moins 18 ans')),
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
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Créer un compte",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
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
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        focusColor: Colors.black,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //Assign controller
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mot de passe obligatoire';
                        }
                        if (value.trim().length < 8) {
                          return 'Le mot de passe doit faire au moins caractères';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Mot de passe',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      //Assign controller
                      controller: _prenomController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Prénom obligatoire';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Prénom',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //Assign controller
                      controller: _instaController,
                      decoration: const InputDecoration(
                        hintText: '@instagram (optionnel)',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      controller: _dateController,
                      onTap: () {
                        FocusScope.of(context).requestFocus(
                            new FocusNode()); // Retire le focus du TextFormField
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
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ///////////////////////////////////////////
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
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
                          : const Text('Créer un compte'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.toggleView!();
                      },
                      child: _error
                          ? const Text(
                              "Cette adresse mail est déja associée à un compte, essayez de vous connecter !",
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            )
                          : const Text("Se connecter"),
                    ),
                  ],
                ),
              ))),
    );
  }
}
