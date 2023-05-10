import 'package:flutter/material.dart';
import 'package:projet_indus/services/AuthService.dart';

class AuthView extends StatefulWidget {

  const AuthView({super.key});
  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  
  final bool _isLogin = false;
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  handleSubmit() async {

    if (!_formKey.currentState!.validate()) return null;
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    setState(() => _loading = true);

    if (_isLogin) {
      await AuthService().loginWithEmailAndPassword(email, password);
    } else {
      await AuthService().registerWithEmailAndPassword(email, password);
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
       child:Padding(padding: const EdgeInsets.all(16.0),
        child:Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Se connecter",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value != null) {
                    if (value.contains('@') && (value.endsWith('.com') || value.endsWith('.fr') || value.endsWith('.net'))) {
                      return null;
                      }
                    return 'Entrez une adresse mail valide';
                    }
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  focusColor: Color.fromARGB(255, 73, 68, 226),
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
                      color: Color.fromARGB(255, 73, 68, 226),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                    : Text(_isLogin ? 'Login' : 'Register'),
              ),
            ],
          ),
        )
       )
      ),
    );
  }
}
