import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:takingnoteapp/constants/routes.dart';
import 'package:takingnoteapp/utilities/show_error_dialog.dart';

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
                    await showErrorDialog(
                      context,
                      'Email Already In Use',
                    );
                    break;
                  case 'invalid-email':
                    await showErrorDialog(
                      context,
                      'Invalid Email Entered',
                    );
                    break;
                  case 'weak-password':
                    await showErrorDialog(
                      context,
                      'Weak Password',
                    );
                    break;
                  default:
                    await showErrorDialog(
                      context,
                      'ERROR: ${e.code}',
                    );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  'UNKNOWN ERROR: ${e.toString()}',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  login,
                  (route) => false,
                );
              },
              child: const Text('Already Registered? Login here!'))
        ],
      ),
    );
  }
}
