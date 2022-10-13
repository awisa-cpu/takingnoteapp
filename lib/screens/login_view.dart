import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          decoration: const InputDecoration(hintText: 'Enter email here'),
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: _password,
          decoration: const InputDecoration(hintText: 'Enter password here'),
          enableSuggestions: false,
          autocorrect: false,
          obscureText: true,
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
            } on FirebaseAuthException catch (e) {
              switch (e.code) {
                case 'user-not-found':
                  print('USER ERROR: ${e.code} ');
                  break;
                case 'wrong-password':
                  print('PASSWORD ERROR: ${e.code}');
                  break;
                default:
                  print('OTHER ERROR: ${e.code}');
              }
            }
          },
          child: const Text('Login'),
        )
      ],
    );
  }
}
