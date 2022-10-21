import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:takingnoteapp/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    noteView,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailView,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'user-not-found':
                    await showErrorDialog(
                      context,
                      'User Not Found',
                    );
                    break;
                  case 'wrong-password':
                    await showErrorDialog(
                      context,
                      'Wrong Password Credentails',
                    );
                    break;
                  case 'invalid-email':
                    await showErrorDialog(
                      context,
                      'Invalid Email Entered',
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
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                register,
                (route) => false,
              );
            },
            child: const Text('Not Registered Yet? Register Here!'),
          ),
        ],
      ),
    );
  }
}
