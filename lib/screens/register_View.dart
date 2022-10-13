import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
    return Column(
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
            } on FirebaseAuthException catch (e) {
              switch (e.code) {
                case 'email-already-in-use':
                  print('EMAIL: ${e.code}');
                  break;
                case 'invalid-email':
                  print('EMAIL: ${e.code}');
                  break;
                case 'weak-password':
                  print('PASSWORD: ${e.code}');
                  break;
                default:
                  print('OTHER UNHANDLED ERROR: ${e.code}');
              }
            }
          },
          child: const Text('Register'),
        )
      ],
    );
  }
}
