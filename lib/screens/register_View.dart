import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REGISTRATION')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            enableSuggestions: false, //this too not working yet
            autocorrect: false,
            keyboardType: TextInputType.emailAddress, //this is not working yet
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your password'),
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'email-already-in-use':
                    devtools.log('EMAIL: ${e.code}');
                    break;
                  case 'invalid-email':
                    devtools.log('EMAIL: ${e.code}');
                    break;
                  case 'weak-password':
                    devtools.log('PASSWORD: ${e.code}');
                    break;
                  default:
                    devtools.log('OTHER UNHANDLED ERROR: ${e.code}');
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login/',
                  (route) => false,
                );
              },
              child: const Text('Already Registered? Login here!'))
        ],
      ),
    );
  }
}
