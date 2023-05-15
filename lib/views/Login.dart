import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_indus/models/client.dart';


import '../services/AuthService.dart';

class Login extends StatefulWidget {
  final Function? toggleView;
  Login({this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;
  bool _error = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  changeError() {
    _error = false;
  }

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return null;
    setState(() => _loading = true);
      final email = _emailController.value.text;
      final password = _passwordController.value.text;
      Client user =
          await AuthService().loginWithEmailAndPassword(email, password);
      if (user.firebase_id == null) {
      _error = true;
      setState(() => _error = true);
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
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
                      "Se connecter",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w800,color:  Colors.black),
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
                        focusColor:  Colors.black,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:  Colors.black,
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
                            color:  Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                   
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.black,
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
                          : const Text('Se connecter'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.toggleView!();
                      },
                      child: _error?const Text(
                    "Pas de comptes associés, vous pouvez un créer un ici !",
                    style: TextStyle(color: Colors.red),
                    textAlign:TextAlign.center,
                    ):
                    const Text("Pas encore de compte ?"),
                    )
                  , 
                  ],
                ),
              )
            )
          ),
    );
  }
}
